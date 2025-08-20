import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
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

class OperationsDatePage extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final String? reception;
  final bool? bill;
  final bool? paid_money;

  const OperationsDatePage({
    super.key,
    required this.fromDate,
    required this.toDate,
    this.reception,
    this.bill,
    this.paid_money,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SalesBloc>()),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
            apiClient: getIt<ApiClient>(),
            checkUserSessionStatus: getIt<CheckUserSessionStatus>(),
          )),
        ),
      ],
      child: OperationsDatePageChild(
        fromDate: fromDate,
        toDate: toDate,
        reception: reception,
        bill: bill,
        paid_money: paid_money,
      ),
    );
  }
}

class OperationsDatePageChild extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String? reception;
  final bool? bill;
  final bool? paid_money;
  const OperationsDatePageChild({
    super.key,
    required this.fromDate,
    required this.toDate,
    this.reception,
    this.bill,
    this.paid_money,
  });

  @override
  State<OperationsDatePageChild> createState() =>
      _OperationsDatePageChildState();
}

class _OperationsDatePageChildState extends State<OperationsDatePageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  bool isLoadingMore = false;
  List<OperationsModel> _model = [];
  bool isInitialDataLoaded = false;
  double width = 0;
  @override
  void initState() {
    super.initState();
    _fromDateController.text = widget.fromDate;
    _toDateController.text = widget.toDate;
    _scrollController.addListener(_onScroll);
    runBloc();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  void _onScroll() {
    // Calculate the halfway point
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;

    // Check if the current scroll position is at or beyond the halfway point
    if (_scrollController.position.pixels >= halfwayPoint && !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;

    runBloc();
  }

  void runBloc({bool reset = false}) {
    if (reset) {
      setState(() {
        currentPage = 1;
        _model.clear();
        isInitialDataLoaded = false;
      });
    }

    context.read<OperationsBloc>().add(
          GetAllOperationsForDate(
            page: currentPage,
            date1: _fromDateController.text,
            date2: _toDateController.text,
            reception: widget.reception,
            bill: widget.bill,
            paid_money: widget.paid_money,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text('عمليات الزبائن'),
              SizedBox(width: 10),
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
                      content: state.errorMessage,
                      failure: true,
                    );
                  } else if (state is OperationsSuccess<Uint8List>) {
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
                          content: 'الرجاء تحديد تاريخ البدء وتاريخ الانتهاء',
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
                              runBloc(reset: true);
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
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
                              runBloc(reset: true);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Mybutton(
                      text: 'بحث',
                      onPressed: () {
                        if (_fromDateController.text.isNotEmpty &&
                            _toDateController.text.isNotEmpty) {
                          runBloc();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocConsumer<OperationsBloc, OperationsState>(
                  listener: (context, state) {
                    if (state is OperationsSuccess<List<OperationsModel>>) {
                      setState(() {
                        if (currentPage == 1) {
                          _model = state.result;
                        } else {
                          _model.addAll(state.result);
                        }
                        isLoadingMore = false;
                        isInitialDataLoaded = true;
                      });
                    } else if (state is OperationsError) {
                      setState(() {
                        isLoadingMore = false;
                      });
                    }
                  },
                  builder: (context, state) {
                    // Initial loading state
                    if (!isInitialDataLoaded && state is OperationsLoading) {
                      return const Center(child: Loader());
                    }

                    // Error state
                    if (state is OperationsError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    }

                    // Empty state
                    if (isInitialDataLoaded && _model.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد عمليات لعرضها',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Show the list with pagination
                    return _buildOperationsList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperationsList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      itemCount: _model.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _model.length) {
          return isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Loader()),
                )
              : const SizedBox.shrink();
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: width, end: 0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(value, 0),
              child: child,
            );
          },
          child: Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _model[index].type == 'visit'
                        ? Icons.work_history_outlined
                        : _model[index].type == 'call'
                            ? Icons.call
                            : Icons.error,
                  ),
                  Text(_model[index].id.toString()),
                ],
              ),
              subtitle: Column(
                children: [
                  Text(_model[index].customer_name ?? ""),
                  Text(_model[index].shop_name ?? ""),
                ],
              ),
              title: Center(
                child: Text(_model[index].date!),
              ),
              trailing: Text("${_model[index].duration}"),
              onTap: () {
                if (_model[index].type == 'visit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NewVisitPage(
                          operationsModel: _model[index],
                        );
                      },
                    ),
                  );
                }
                if (_model[index].type == 'call') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NewCallPage(
                          operationsModel: _model[index],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
