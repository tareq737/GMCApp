// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ProductionPackagingDataWidget extends StatefulWidget {
  final String type;
  final FullProductionModel fullProductionModel;
  const ProductionPackagingDataWidget({
    super.key,
    required this.fullProductionModel,
    required this.type,
  });

  @override
  State<ProductionPackagingDataWidget> createState() =>
      _ProductionPackagingDataWidgetState();
}

class _ProductionPackagingDataWidgetState
    extends State<ProductionPackagingDataWidget> {
  List<String>? groups;
  final startTimeController = TextEditingController();
  final finishTimeController = TextEditingController();
  String durationText = '';
  final completionDateController = TextEditingController();
  bool? packagingCheck_1 = false;
  bool? packagingCheck_2 = false;
  bool? packagingCheck_3 = false;
  bool? packagingCheck_4 = false;
  bool? packagingCheck_5 = false;
  bool? packagingCheck_6 = false;
  final employeeController = TextEditingController();
  final notesController = TextEditingController();
  final problemsController = TextEditingController();
  final packagingDensityController = TextEditingController();
  final batchLeftoverController = TextEditingController();
  final receiptNumberController = TextEditingController();
  final containerEmptyController = TextEditingController();
  final packagingWeightController = TextEditingController();
  final printingController = TextEditingController();
  final fillingController = TextEditingController();
  final shrinkageController = TextEditingController();
  final baggingController = TextEditingController();
  final strappingController = TextEditingController();
  final pressingController = TextEditingController();
  final stickersController = TextEditingController();
  final wrappingController = TextEditingController();
  final cartonsController = TextEditingController();
  final countDensityController = TextEditingController();

  final PackagingModel _packagingModel = PackagingModel();
  void _fillPackagingModelFromFomr() {
    _packagingModel.id = widget.fullProductionModel.packaging.id;
    _packagingModel.packaging_check_1 = packagingCheck_1;
    _packagingModel.packaging_check_2 = packagingCheck_2;
    _packagingModel.packaging_check_3 = packagingCheck_3;
    _packagingModel.packaging_check_4 = packagingCheck_4;
    _packagingModel.packaging_check_5 = packagingCheck_5;
    _packagingModel.packaging_check_6 = packagingCheck_6;
    _packagingModel.employee = employeeController.text;
    _packagingModel.notes = notesController.text;
    _packagingModel.problems = problemsController.text;
    _packagingModel.packaging_density = packagingDensityController.text.isEmpty
        ? null
        : double.tryParse(packagingDensityController.text);

    _packagingModel.batch_leftover = batchLeftoverController.text;
    _packagingModel.receipt_number = receiptNumberController.text.isEmpty
        ? null
        : int.tryParse(receiptNumberController.text);

    _packagingModel.container_empty = containerEmptyController.text.isEmpty
        ? null
        : double.tryParse(containerEmptyController.text);

    _packagingModel.packaging_weight = packagingWeightController.text.isEmpty
        ? null
        : double.tryParse(packagingWeightController.text);

    _packagingModel.printing = printingController.text;
    _packagingModel.filling = fillingController.text;
    _packagingModel.shrinkage = shrinkageController.text;
    _packagingModel.bagging = baggingController.text;
    _packagingModel.strapping = strappingController.text;
    _packagingModel.pressing = pressingController.text;
    _packagingModel.stickers = stickersController.text;
    _packagingModel.wrapping = wrappingController.text;
    _packagingModel.cartons = cartonsController.text;
    _packagingModel.start_time =
        startTimeController.text.isEmpty ? null : startTimeController.text;
    _packagingModel.finish_time =
        finishTimeController.text.isEmpty ? null : finishTimeController.text;
    _packagingModel.completion_date = completionDateController.text.isEmpty
        ? null
        : completionDateController.text;
  }

  @override
  void initState() {
    super.initState();
    packagingCheck_1 =
        widget.fullProductionModel.packaging.packaging_check_1 ?? false;
    packagingCheck_2 =
        widget.fullProductionModel.packaging.packaging_check_2 ?? false;
    packagingCheck_3 =
        widget.fullProductionModel.packaging.packaging_check_3 ?? false;
    packagingCheck_4 =
        widget.fullProductionModel.packaging.packaging_check_4 ?? false;
    packagingCheck_5 =
        widget.fullProductionModel.packaging.packaging_check_5 ?? false;
    packagingCheck_6 =
        widget.fullProductionModel.packaging.packaging_check_6 ?? false;
    employeeController.text =
        widget.fullProductionModel.packaging.employee ?? '';
    notesController.text = widget.fullProductionModel.packaging.notes ?? '';
    problemsController.text =
        widget.fullProductionModel.packaging.problems ?? '';
    packagingDensityController.text = widget
            .fullProductionModel.packaging.packaging_density
            ?.toStringAsFixed(3) ??
        '';

    batchLeftoverController.text =
        widget.fullProductionModel.packaging.batch_leftover ?? '';
    receiptNumberController.text =
        widget.fullProductionModel.packaging.receipt_number?.toString() ?? '';

    containerEmptyController.text = widget
            .fullProductionModel.packaging.container_empty
            ?.toStringAsFixed(3) ??
        '';

    packagingWeightController.text = widget
            .fullProductionModel.packaging.packaging_weight
            ?.toStringAsFixed(3) ??
        '';

    printingController.text =
        widget.fullProductionModel.packaging.printing ?? '';
    fillingController.text = widget.fullProductionModel.packaging.filling ?? '';
    shrinkageController.text =
        widget.fullProductionModel.packaging.shrinkage ?? '';
    baggingController.text = widget.fullProductionModel.packaging.bagging ?? '';
    strappingController.text =
        widget.fullProductionModel.packaging.strapping ?? '';
    pressingController.text =
        widget.fullProductionModel.packaging.pressing ?? '';
    stickersController.text =
        widget.fullProductionModel.packaging.stickers ?? '';
    wrappingController.text =
        widget.fullProductionModel.packaging.wrapping ?? '';
    cartonsController.text = widget.fullProductionModel.packaging.cartons ?? '';

    startTimeController.text =
        widget.fullProductionModel.packaging.start_time ?? '';
    finishTimeController.text =
        widget.fullProductionModel.packaging.finish_time ?? '';
    completionDateController.text =
        widget.fullProductionModel.packaging.completion_date ?? '';

    _calculateDuration();
    _calculateDensity();
  }

  void _calculateDensity() {
    double space = 3.14 * 57 * 57;

    String emptyText = containerEmptyController.text.trim();
    String weightText = packagingWeightController.text.trim();

    if (emptyText.isEmpty || weightText.isEmpty) {
      countDensityController.text = '';
      return;
    }

    double? empty = double.tryParse(emptyText);
    double? weight = double.tryParse(weightText);

    if (empty == null || weight == null || empty >= 100) {
      countDensityController.text = 'Error';
      return;
    }

    countDensityController.text =
        (weight / ((space * (100 - empty)) / 1000)).toStringAsFixed(3);
  }

  Future<void> _saveFile(Uint8List bytes, BuildContext context) async {
    try {
      final directory = await getTemporaryDirectory();

      const fileName = 'QR.pdf';
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
    AppUserState state = context.watch<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return BlocProvider(
      create: (context) => ProductionBloc(ProductionServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(builder: (context) {
        return BlocConsumer<ProductionBloc, ProductionState>(
          listener: (context, state) async {
            if (state is ProductionSuccess) {
              showSnackBar(
                context: context,
                content: 'تم الحفظ بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (
                    context,
                  ) {
                    return const ProductionList(
                      type: 'Production',
                    );
                  },
                ),
              );
            }
            if (state is ProductionError) {
              showSnackBar(
                context: context,
                content: 'حدث خطأ ما',
                failure: true,
              );
            }
            if (state is GenrateSuccess<Uint8List>) {
              await _saveFile(state.result, context);
            }
          },
          builder: (context, state) {
            // Show loader when state is ExportLoading
            if (state is ExportLoading) {
              return const Center(
                child: Loader(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          spacing: 10,
                          children: [
                            const Text(
                              'معلومات قسم التعبئة',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  context.read<ProductionBloc>().add(
                                        GenrateQr(
                                          production_id: widget
                                              .fullProductionModel
                                              .packaging
                                              .id!,
                                        ),
                                      );
                                },
                                icon: const Icon(Icons.qr_code),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final orientation =
                                MediaQuery.of(context).orientation;
                            if (orientation == Orientation.landscape) {
                              return _buildLandscapeLayout(context);
                            } else {
                              return _buildPortraitLayout(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  //-- WIDGET FOR PORTRAIT LAYOUT --
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        if (widget.type == 'Production') ...[
          CheckboxListTile(
            title: const Text(
              'استلمت الطبخة من التصنيع',
              style: TextStyle(fontSize: 12),
            ),
            value: packagingCheck_1,
            onChanged: (bool? value) {
              setState(() {
                packagingCheck_1 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'استلمت الفوارغ جاهزة',
              style: TextStyle(fontSize: 12),
            ),
            value: packagingCheck_2,
            onChanged: (bool? value) {
              setState(() {
                packagingCheck_2 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'قيد التعبئة',
              style: TextStyle(fontSize: 12),
            ),
            value: packagingCheck_3,
            onChanged: (bool? value) {
              setState(() {
                packagingCheck_3 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'انتهت التعبئة',
              style: TextStyle(fontSize: 12),
            ),
            value: packagingCheck_4,
            onChanged: (bool? value) {
              setState(() {
                packagingCheck_4 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'كرتنت للتسليم',
              style: TextStyle(fontSize: 12),
            ),
            value: packagingCheck_5,
            onChanged: (bool? value) {
              setState(() {
                packagingCheck_5 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'المعلومات جاهزة للأرشفة',
              style: TextStyle(fontSize: 12),
            ),
            value: packagingCheck_6,
            onChanged: (bool? value) {
              if (value == true) {
                if (employeeController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى إدخال اسم الموظف قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (startTimeController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد وقت البدء قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (finishTimeController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد وقت الإنتهاء قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (packagingDensityController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد كثافة الطبخة قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (receiptNumberController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد رقم الوصل قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (packagingWeightController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد وزن الطبخة قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (completionDateController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد تاريخ الانتهاء قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
              }
              setState(() {
                packagingCheck_6 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
        Row(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MyTextField(
                  controller: printingController, labelText: 'طباعة'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  controller: fillingController, labelText: 'تعبئة'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  controller: shrinkageController, labelText: 'شرنكة'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MyTextField(
                  controller: baggingController, labelText: 'تكييس'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  controller: strappingController, labelText: 'تربيط'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  controller: pressingController, labelText: 'تكبيس'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MyTextField(
                  controller: stickersController, labelText: 'لصاقات'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child:
                  MyTextField(controller: wrappingController, labelText: 'لف'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  controller: cartonsController, labelText: 'كرتنة'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyTextField(
            controller: employeeController, labelText: 'المسلم لقسم الجاهزة'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: startTimeController,
                labelText: 'وقت بدء التعبئة',
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final formattedTime = DateFormat('HH:mm').format(
                      DateTime(now.year, now.month, now.day, pickedTime.hour,
                          pickedTime.minute),
                    );
                    startTimeController.text = formattedTime;
                    _calculateDuration();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                controller: finishTimeController,
                labelText: 'وقت انتهاء التعبئة',
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final formattedTime = DateFormat('HH:mm').format(
                      DateTime(now.year, now.month, now.day, pickedTime.hour,
                          pickedTime.minute),
                    );
                    finishTimeController.text = formattedTime;
                    _calculateDuration();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'مدة العمل: $durationText',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MyTextField(
                controller: packagingDensityController,
                labelText: 'كثافة التعبئة',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  controller: batchLeftoverController,
                  labelText: 'متبقي الطبخة'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                  readOnly: true,
                  controller: countDensityController,
                  labelText: 'الكثافة حسب الفراغ'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MyTextField(
                controller: receiptNumberController,
                labelText: 'رقم الوصل',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                onChanged: (value) => _calculateDensity(),
                controller: containerEmptyController,
                labelText: 'فراغ الحلة',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                onChanged: (value) => _calculateDensity(),
                controller: packagingWeightController,
                labelText: 'وزن التعبئة',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyTextField(
          readOnly: true,
          controller: completionDateController,
          labelText: 'تاريخ انتهاء التعبئة',
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              setState(() {
                completionDateController.text =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
              });
            }
          },
        ),
        const SizedBox(height: 10),
        MyTextField(
            maxLines: 10,
            controller: notesController,
            labelText: 'ملاحظات التعبئة'),
        const SizedBox(height: 10),
        MyTextField(
            maxLines: 10,
            controller: problemsController,
            labelText: 'مشاكل التعبئة'),
        const SizedBox(height: 10),
        if ((groups!.contains('admins') || groups!.contains('packaging_dep')) &&
            widget.type == 'Production')
          Mybutton(
            text: 'حفظ',
            onPressed: () {
              if (!_isDurationValid()) {
                showSnackBar(
                  context: context,
                  content: 'الوقت غير صحيح ⏳',
                  failure: true,
                );
                return;
              }
              _fillPackagingModelFromFomr();
              print(_packagingModel);
              context
                  .read<ProductionBloc>()
                  .add(SavePackaging(packagingModel: _packagingModel));
            },
          ),
      ],
    );
  }

  //-- WIDGET FOR LANDSCAPE LAYOUT --
  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-- COLUMN 1 --
            Expanded(
              child: Column(
                children: [
                  if (widget.type == 'Production') ...[
                    CheckboxListTile(
                      title: const Text(
                        'استلمت الطبخة من التصنيع',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: packagingCheck_1,
                      onChanged: (bool? value) {
                        setState(() {
                          packagingCheck_1 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'استلمت الفوارغ جاهزة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: packagingCheck_2,
                      onChanged: (bool? value) {
                        setState(() {
                          packagingCheck_2 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'قيد التعبئة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: packagingCheck_3,
                      onChanged: (bool? value) {
                        setState(() {
                          packagingCheck_3 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'انتهت التعبئة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: packagingCheck_4,
                      onChanged: (bool? value) {
                        setState(() {
                          packagingCheck_4 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'كرتنت للتسليم',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: packagingCheck_5,
                      onChanged: (bool? value) {
                        setState(() {
                          packagingCheck_5 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'المعلومات جاهزة للأرشفة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: packagingCheck_6,
                      onChanged: (bool? value) {
                        if (value == true) {
                          if (employeeController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى إدخال اسم الموظف قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (startTimeController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد وقت البدء قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (finishTimeController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد وقت الإنتهاء قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (packagingDensityController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد كثافة الطبخة قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (receiptNumberController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد رقم الوصل قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (packagingWeightController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد وزن الطبخة قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (completionDateController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد تاريخ الانتهاء قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                        }
                        setState(() {
                          packagingCheck_6 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                  const SizedBox(height: 29),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: startTimeController,
                          labelText: 'وقت البدء',
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final formattedTime = DateFormat('HH:mm').format(
                                DateTime(now.year, now.month, now.day,
                                    pickedTime.hour, pickedTime.minute),
                              );
                              startTimeController.text = formattedTime;
                              _calculateDuration();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: finishTimeController,
                          labelText: 'وقت الانتهاء',
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final formattedTime = DateFormat('HH:mm').format(
                                DateTime(now.year, now.month, now.day,
                                    pickedTime.hour, pickedTime.minute),
                              );
                              finishTimeController.text = formattedTime;
                              _calculateDuration();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'مدة العمل: $durationText',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    readOnly: true,
                    controller: completionDateController,
                    labelText: 'تاريخ الانتهاء',
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          completionDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(width: 16),
            //-- COLUMN 2 --
            Expanded(
              flex: 2, // Give more space to the second column
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                            controller: printingController, labelText: 'طباعة'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: fillingController, labelText: 'تعبئة'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: shrinkageController,
                            labelText: 'شرنكة'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                            controller: baggingController, labelText: 'تكييس'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: strappingController,
                            labelText: 'تربيط'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: pressingController, labelText: 'تكبيس'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                            controller: stickersController,
                            labelText: 'لصاقات'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: wrappingController, labelText: 'لف'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: cartonsController, labelText: 'كرتنة'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: employeeController,
                      labelText: 'المسلم لقسم الجاهزة'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: packagingDensityController,
                          labelText: 'كثافة التعبئة',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            controller: batchLeftoverController,
                            labelText: 'متبقي الطبخة'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: receiptNumberController,
                          labelText: 'رقم الوصل',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          onChanged: (value) => _calculateDensity(),
                          controller: containerEmptyController,
                          labelText: 'فراغ الحلة',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          onChanged: (value) => _calculateDensity(),
                          controller: packagingWeightController,
                          labelText: 'وزن التعبئة',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                            readOnly: true,
                            controller: countDensityController,
                            labelText: 'الكثافة المحسوبة'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      maxLines: 5,
                      controller: notesController,
                      labelText: 'ملاحظات'),
                  const SizedBox(height: 10),
                  MyTextField(
                      maxLines: 5,
                      controller: problemsController,
                      labelText: 'مشاكل'),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        if ((groups!.contains('admins') || groups!.contains('packaging_dep')) &&
            widget.type == 'Production')
          Mybutton(
            text: 'حفظ',
            onPressed: () {
              if (!_isDurationValid()) {
                showSnackBar(
                  context: context,
                  content: 'الوقت غير صحيح ⏳',
                  failure: true,
                );
                return;
              }
              _fillPackagingModelFromFomr();
              print(_packagingModel);
              context
                  .read<ProductionBloc>()
                  .add(SavePackaging(packagingModel: _packagingModel));
            },
          ),
      ],
    );
  }

  void _calculateDuration() {
    if (startTimeController.text.isNotEmpty &&
        finishTimeController.text.isNotEmpty) {
      final format = DateFormat('HH:mm');

      final DateTime startTime = format.parse(startTimeController.text);
      final DateTime finishTime = format.parse(finishTimeController.text);

      final Duration duration = finishTime.difference(startTime);

      if (duration.isNegative) {
        final nextDayFinishTime = finishTime.add(const Duration(days: 1));
        final Duration nextDayDuration =
            nextDayFinishTime.difference(startTime);
        setState(() {
          durationText = _formatDuration(nextDayDuration);
        });
      } else {
        setState(() {
          durationText = _formatDuration(duration);
        });
      }
    }
  }

  bool _isDurationValid() {
    if (startTimeController.text.isEmpty || finishTimeController.text.isEmpty) {
      return true; // Allow empty values
    }

    final format = DateFormat('HH:mm');
    try {
      final DateTime startTime = format.parse(startTimeController.text);
      final DateTime finishTime = format.parse(finishTimeController.text);

      final Duration duration = finishTime.difference(startTime);

      // If finish time is before start time OR duration > 9 hours => invalid
      if (duration.isNegative || duration > const Duration(hours: 9)) {
        return false;
      }
    } catch (e) {
      return false; // invalid parse means invalid duration
    }
    return true;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
