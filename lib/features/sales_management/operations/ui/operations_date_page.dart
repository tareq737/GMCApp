import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_call_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_visit_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class OperationsDatePage extends StatefulWidget {
  const OperationsDatePage({super.key});

  @override
  State<OperationsDatePage> createState() => _OperationsDatePageState();
}

class _OperationsDatePageState extends State<OperationsDatePage> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fromDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _toDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();

      const fileName = 'تقرير زيارات المبيعات.xlsx';
      final path = '${directory.path}\\$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

      // Open the file
      final result = await OpenFilex.open(path);

      if (result.type != ResultType.done) {
        await _showDialog('Error', 'لم يتم فتح الملف: ${result.message}');
      }

      Navigator.of(context).pop(); // Close the page
    } catch (e) {
      await _showDialog('Error', 'Failed to save/open file:\n$e');
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SalesBloc>(),
        ),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
              apiClient: getIt<ApiClient>(),
              checkUserSessionStatus: getIt<CheckUserSessionStatus>())),
        ),
      ],
      child: Builder(builder: (context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  Text('عمليات الزبائن'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.info_outline),
                ],
              ),
              actions: [
                if (defaultTargetPlatform == TargetPlatform.windows)
                  BlocConsumer<OperationsBloc, OperationsState>(
                    listener: (context, state) async {
                      if (state is OperationsError) {
                        showSnackBar(
                          context: context,
                          content: state
                              .errorMessage, // Use the error message from the state
                          failure: true,
                        );
                      } else if (state is OperationsSuccess<Uint8List>) {
                        // Handle the successful download of the Excel file
                        await _saveFile(state.result);
                      }
                    },
                    builder: (context, state) {
                      return IconButton(
                        icon: const Icon(FontAwesomeIcons.fileExport),
                        onPressed: () {
                          if (_fromDateController.text.isNotEmpty &&
                              _toDateController.text.isNotEmpty) {
                            context.read<OperationsBloc>().add(
                                  ExportExcelOperations(
                                    fromDate: _fromDateController.text,
                                    toDate: _toDateController.text,
                                  ),
                                );
                          } else {
                            showSnackBar(
                              context: context,
                              content:
                                  'الرجاء تحديد تاريخ البدء وتاريخ الانتهاء',
                              failure: true,
                            );
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _fromDateController,
                                labelText: 'من تاريخ',
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _fromDateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _toDateController,
                                labelText: 'إلى تاريخ',
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _toDateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Mybutton(
                          text: 'بحث',
                          onPressed: () {
                            if (_fromDateController.text.isNotEmpty &&
                                _toDateController.text.isNotEmpty) {
                              context.read<OperationsBloc>().add(
                                    GetAllOperationsForDate(
                                      date1: _fromDateController.text,
                                      date2: _toDateController.text,
                                    ),
                                  );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<OperationsBloc, OperationsState>(
                    builder: (context, state) {
                      if (state is OperationsLoading) {
                        return const Loader();
                      } else if (state
                          is OperationsSuccess<List<OperationsModel>>) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.result.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: Icon(
                                    state.result[index].type == 'visit'
                                        ? Icons.work_history_outlined
                                        : state.result[index].type == 'call'
                                            ? Icons.call
                                            : Icons.error,
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(state.result[index].customer_name ??
                                          ""),
                                      Text(state.result[index].shop_name ?? "")
                                    ],
                                  ),
                                  title: Center(
                                    child: Text(state.result[index].date!),
                                  ),
                                  trailing:
                                      Text("${state.result[index].duration}"),
                                  onTap: () {
                                    if (state.result[index].type == 'visit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return NewVisitPage(
                                              operationsModel:
                                                  state.result[index],
                                            );
                                          },
                                        ),
                                      );
                                    }
                                    if (state.result[index].type == 'call') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return NewCallPage(
                                              operationsModel:
                                                  state.result[index],
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is OperationsError) {
                        return const Center(
                            child:
                                Text('حدث خطأ عند الحصول على عمليات الزبون'));
                      } else {
                        return const Center(child: Text(''));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
