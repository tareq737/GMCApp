// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_full_data_page.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

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

    // if (startTimeController.text.isNotEmpty) {
    //   DateTime parsedTime = DateFormat('HH:mm').parse(startTimeController.text);
    //   String formattedTime = DateFormat('hh:mm').format(parsedTime);
    //   startTimeController.text = formattedTime;
    // }
    // if (finishTimeController.text.isNotEmpty) {
    //   DateTime parsedTime =
    //       DateFormat('HH:mm').parse(finishTimeController.text);
    //   String formattedTime = DateFormat('hh:mm').format(parsedTime);
    //   finishTimeController.text = formattedTime;
    // }

    _calculateDuration();
    _calculateDensity();
  }

  void _calculateDensity() {
    double space = 3.14 * 57 * 57;

    String emptyText = containerEmptyController.text.trim();
    String weightText = packagingWeightController.text.trim();

    if (emptyText.isEmpty || weightText.isEmpty) {
      // Handle the error (show a message, set default, etc.)
      print('Please fill in all fields');
      return;
    }

    double? empty = double.tryParse(emptyText);
    double? weight = double.tryParse(weightText);

    if (empty == null || weight == null) {
      // Handle the error (show a message, set default, etc.)
      print('Invalid input. Please enter valid numbers.');
      return;
    }

    countDensityController.text =
        (weight / ((space * (100 - empty)) / 1000)).toStringAsFixed(3);
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
        return BlocListener<ProductionBloc, ProductionState>(
          listener: (context, state) {
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
          },
          child: Padding(
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'معلومات قسم التعبئة',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                          setState(() {
                            packagingCheck_6 = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyTextField(
                              controller: printingController,
                              labelText: 'طباعة'),
                        ),
                        Expanded(
                          child: MyTextField(
                              controller: fillingController,
                              labelText: 'تعبئة'),
                        ),
                        Expanded(
                          child: MyTextField(
                              controller: shrinkageController,
                              labelText: 'شرنكة'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyTextField(
                              controller: baggingController,
                              labelText: 'تكييس'),
                        ),
                        Expanded(
                          child: MyTextField(
                              controller: strappingController,
                              labelText: 'تربيط'),
                        ),
                        Expanded(
                          child: MyTextField(
                              controller: pressingController,
                              labelText: 'تكبيس'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyTextField(
                              controller: stickersController,
                              labelText: 'لصاقات'),
                        ),
                        Expanded(
                          child: MyTextField(
                              controller: wrappingController, labelText: 'لف'),
                        ),
                        Expanded(
                          child: MyTextField(
                              controller: cartonsController,
                              labelText: 'كرتنة'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: employeeController,
                        labelText: 'المسلم لقسم الجاهزة'),
                    const SizedBox(
                      height: 10,
                    ),
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
                                final formattedTime =
                                    DateFormat('HH:mm').format(
                                  DateTime(now.year, now.month, now.day,
                                      pickedTime.hour, pickedTime.minute),
                                );
                                startTimeController.text = formattedTime;
                                _calculateDuration();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
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
                                final formattedTime =
                                    DateFormat('HH:mm').format(
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
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Expanded(
                          child: MyTextField(
                              controller: batchLeftoverController,
                              labelText: 'متبقي الطبخة'),
                        ),
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
                      spacing: 10,
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
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        maxLines: 10,
                        controller: notesController,
                        labelText: 'ملاحظات التعبئة'),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        maxLines: 10,
                        controller: problemsController,
                        labelText: 'مشاكل التعبئة'),
                    const SizedBox(
                      height: 10,
                    ),
                    if ((groups!.contains('admins') ||
                            groups!.contains('packaging_dep')) &&
                        widget.type == 'Production')
                      Mybutton(
                        text: 'حفظ',
                        onPressed: () {
                          _fillPackagingModelFromFomr();
                          print(_packagingModel);
                          context.read<ProductionBloc>().add(
                              SavePackaging(packagingModel: _packagingModel));
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
