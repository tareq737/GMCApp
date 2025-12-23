import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class GenrateLabelPdfPage extends StatefulWidget {
  const GenrateLabelPdfPage({super.key});

  @override
  State<GenrateLabelPdfPage> createState() => _GenrateLabelPdfPageState();
}

class _GenrateLabelPdfPageState extends State<GenrateLabelPdfPage> {
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final contentController = TextEditingController();
  final paperSizeController = TextEditingController();
  late List<String> paper_size;

  List<DropdownMenuItem<String>> dropdownDepartmentItems() {
    return paper_size.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    paper_size = [
      'A4',
      'A5',
    ];
  }

  @override
  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _saveFile(Uint8List bytes, BuildContext context) async {
    try {
      final directory = await getTemporaryDirectory();

      const fileName = 'label.pdf';
      final path = '${directory.path}\\$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      await _showDialog(context, 'نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

      // Open the file
      final result = await OpenFilex.open(path);

      if (result.type != ResultType.done) {
        await _showDialog(
            context, 'Error', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      await _showDialog(context, 'Error', 'Failed to save/open file:\n$e');
    }
  }

  Future<void> _showDialog(BuildContext context, String title, String message) {
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => ProductionBloc(ProductionServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>())),
      child: Builder(builder: (context) {
        return BlocListener<ProductionBloc, ProductionState>(
          listener: (context, state) async {
            if (state is GenrateSuccess) {
              await _saveFile(state.result, context);
            } else if (state is ProductionError) {
              showSnackBar(
                context: context,
                content: 'حدث خطأ ما',
                failure: true,
              );
            }
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    isDark ? AppColors.gradient2 : AppColors.lightGradient2,
                title: const Text(
                  'طباعة لصاقات',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: 200,
                        child: MyDropdownButton(
                          value: paperSizeController.text,
                          items: dropdownDepartmentItems(),
                          onChanged: (String? newValue) {
                            setState(() {
                              paperSizeController.text = newValue ?? '';
                            });
                          },
                          labelText: 'قياس الورقة',
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: MyTextField(
                          controller: lengthController,
                          labelText: 'طول اللصاقة / cm',
                          // Allow decimal numbers with optional decimal point
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            // Allow digits, decimal point, and optionally negative sign
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: MyTextField(
                          controller: widthController,
                          labelText: 'عرض اللصاقة / cm',
                          // Allow decimal numbers with optional decimal point
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            // Allow digits, decimal point, and optionally negative sign
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: MyTextField(
                            controller: contentController, labelText: 'النص'),
                      ),
                      Mybutton(
                        text: 'Pdf',
                        onPressed: () {
                          if (_validateForm(context)) {
                            context.read<ProductionBloc>().add(
                                  GenrateLabelPdf(
                                      length: double.tryParse(
                                          lengthController.text)!,
                                      width: double.tryParse(
                                          widthController.text)!,
                                      content: contentController.text,
                                      paper_size: paperSizeController.text),
                                );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  bool _validateForm(BuildContext context) {
    if (paperSizeController.text.isEmpty ||
        contentController.text.isEmpty ||
        lengthController.text.isEmpty ||
        widthController.text.isEmpty) {
      showSnackBar(
        context: context,
        content: 'يرجى تعبئة جميع الحقول قبل الإدراج',
        failure: true,
      );
      return false;
    }
    return true;
  }
}
