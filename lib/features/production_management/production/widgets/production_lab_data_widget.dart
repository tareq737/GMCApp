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
import 'package:gmcappclean/features/production_management/production/models/lab_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ProductionLabDataWidget extends StatefulWidget {
  final FullProductionModel fullProductionModel;
  final String type;
  const ProductionLabDataWidget({
    super.key,
    required this.fullProductionModel,
    required this.type,
  });

  @override
  State<ProductionLabDataWidget> createState() =>
      _ProductionLabDataWidgetState();
}

class _ProductionLabDataWidgetState extends State<ProductionLabDataWidget> {
  List<String>? groups;
  final _startTimeController = TextEditingController();
  final _finishTimeController = TextEditingController();
  String durationText = '';
  final _completionDateController = TextEditingController();
  bool? labCheck_1 = false;
  bool? labCheck_2 = false;
  bool? labCheck_3 = false;
  bool? labCheck_4 = false;
  bool? labCheck_5 = false;
  bool? labCheck_6 = false;
  final employeeController = TextEditingController();
  final notesController = TextEditingController();
  final problemsController = TextEditingController();
  final concealmentController = TextEditingController();
  final glossController = TextEditingController();
  bool? labColor = false;
  final viscosityController = TextEditingController();
  final densityController = TextEditingController();
  final smoothnessController = TextEditingController();
  final batchTemperatureController = TextEditingController();
  final LabModel _labModel = LabModel();

  void _fillLabModelFromFomr() {
    _labModel.id = widget.fullProductionModel.lab.id;
    _labModel.lab_check_1 = labCheck_1;
    _labModel.lab_check_2 = labCheck_2;
    _labModel.lab_check_3 = labCheck_3;
    _labModel.lab_check_4 = labCheck_4;
    _labModel.lab_check_5 = labCheck_5;
    _labModel.lab_check_6 = labCheck_6;
    _labModel.employee = employeeController.text;
    _labModel.notes = notesController.text;
    _labModel.problems = problemsController.text;
    _labModel.concealment = double.tryParse(concealmentController.text) ?? 0.0;
    _labModel.gloss = double.tryParse(glossController.text) ?? 0.0;
    _labModel.lab_color = labColor;
    _labModel.viscosity = viscosityController.text;
    _labModel.density = double.tryParse(densityController.text);
    _labModel.smoothness = int.tryParse(smoothnessController.text);
    _labModel.batch_temperature =
        double.tryParse(batchTemperatureController.text);
    _labModel.start_time =
        _startTimeController.text.isEmpty ? null : _startTimeController.text;
    _labModel.finish_time =
        _finishTimeController.text.isEmpty ? null : _finishTimeController.text;
    _labModel.completion_date = _completionDateController.text.isEmpty
        ? null
        : _completionDateController.text;
  }

  @override
  void initState() {
    super.initState();
    labCheck_1 = widget.fullProductionModel.lab.lab_check_1 ?? false;
    labCheck_2 = widget.fullProductionModel.lab.lab_check_2 ?? false;
    labCheck_3 = widget.fullProductionModel.lab.lab_check_3 ?? false;
    labCheck_4 = widget.fullProductionModel.lab.lab_check_4 ?? false;
    labCheck_5 = widget.fullProductionModel.lab.lab_check_5 ?? false;
    labCheck_6 = widget.fullProductionModel.lab.lab_check_6 ?? false;
    employeeController.text = widget.fullProductionModel.lab.employee ?? '';
    notesController.text = widget.fullProductionModel.lab.notes ?? '';
    problemsController.text = widget.fullProductionModel.lab.problems ?? '';
    concealmentController.text =
        widget.fullProductionModel.lab.concealment != null
            ? widget.fullProductionModel.lab.concealment!.toStringAsFixed(2)
            : '';
    glossController.text = widget.fullProductionModel.lab.gloss != null
        ? widget.fullProductionModel.lab.gloss!.toStringAsFixed(2)
        : '';
    labColor = widget.fullProductionModel.lab.lab_color ?? false;
    viscosityController.text = widget.fullProductionModel.lab.viscosity != null
        ? widget.fullProductionModel.lab.viscosity!
        : '';
    densityController.text = widget.fullProductionModel.lab.density != null
        ? widget.fullProductionModel.lab.density!.toStringAsFixed(3)
        : '';
    smoothnessController.text =
        widget.fullProductionModel.lab.smoothness != null
            ? widget.fullProductionModel.lab.smoothness!.toString()
            : '';
    batchTemperatureController.text =
        widget.fullProductionModel.lab.batch_temperature != null
            ? widget.fullProductionModel.lab.batch_temperature!
                .toStringAsFixed(2)
            : '';
    _startTimeController.text = widget.fullProductionModel.lab.start_time ?? '';
    _finishTimeController.text =
        widget.fullProductionModel.lab.finish_time ?? '';

    _completionDateController.text =
        widget.fullProductionModel.lab.completion_date ?? '';

    _calculateDuration();
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'معلومات قسم المخبر',
                        style: TextStyle(fontSize: 20),
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
          ),
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
              'أخذت العينة',
              style: TextStyle(fontSize: 12),
            ),
            value: labCheck_1,
            onChanged: (bool? value) {
              setState(() {
                labCheck_1 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'فحصت',
              style: TextStyle(fontSize: 12),
            ),
            value: labCheck_2,
            onChanged: (bool? value) {
              setState(() {
                labCheck_2 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'طلب تعديل',
              style: TextStyle(fontSize: 12),
            ),
            value: labCheck_3,
            onChanged: (bool? value) {
              setState(() {
                labCheck_3 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'تعديل في المخبر',
              style: TextStyle(fontSize: 12),
            ),
            value: labCheck_4,
            onChanged: (bool? value) {
              setState(() {
                labCheck_4 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'فحصت بعد التصليح',
              style: TextStyle(fontSize: 12),
            ),
            value: labCheck_5,
            onChanged: (bool? value) {
              setState(() {
                labCheck_5 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'المعلومات جاهزة للأرشفة',
              style: TextStyle(fontSize: 12),
            ),
            value: labCheck_6,
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
                if (_startTimeController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد وقت البدء قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (_finishTimeController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد وقت الإنتهاء قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (_completionDateController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد تاريخ الانتهاء قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (batchTemperatureController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد حرارة الطبخة قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (densityController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد كثافة الطبخة قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
              }
              setState(() {
                labCheck_6 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
        MyTextField(controller: employeeController, labelText: 'موظف المخبر'),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: _startTimeController,
                labelText: 'وقت بدء المخبر',
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
                    _startTimeController.text = formattedTime;
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
                controller: _finishTimeController,
                labelText: 'وقت انتهاء المخبر',
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
                    _finishTimeController.text = formattedTime;
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
          children: [
            Expanded(
              child: MyTextField(
                controller: concealmentController,
                labelText: 'السترية',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: MyTextField(
                controller: smoothnessController,
                labelText: 'النعومة',
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
                controller: viscosityController,
                labelText: 'اللزوجة',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: MyTextField(
                controller: densityController,
                labelText: 'الكثافة',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
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
                controller: glossController,
                labelText: 'اللمعة',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Text(
                    (labColor ?? false) ? 'اللون مطابق' : 'اللون غير مطابق',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Checkbox(
                    value: labColor,
                    onChanged: (bool? value) {
                      setState(() {
                        labColor = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          // spacing: 10,
          children: [
            Expanded(
              child: MyTextField(
                controller: batchTemperatureController,
                labelText: 'حرارة الطبخة',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextField(
                readOnly: true,
                controller: _completionDateController,
                labelText: 'تاريخ انتهاء المخبر',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _completionDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
            maxLines: 10,
            controller: notesController,
            labelText: 'ملاحظات المخبر'),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
            maxLines: 10,
            controller: problemsController,
            labelText: 'مشاكل المخبر'),
        if ((groups!.contains('admins') || groups!.contains('lab_dep')) &&
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
              _fillLabModelFromFomr();
              context.read<ProductionBloc>().add(SaveLab(labModel: _labModel));
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //-- COLUMN 1 --
            Expanded(
              child: Column(
                children: [
                  if (widget.type == 'Production') ...[
                    CheckboxListTile(
                      title: const Text(
                        'أخذت العينة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: labCheck_1,
                      onChanged: (bool? value) {
                        setState(() {
                          labCheck_1 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'فحصت',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: labCheck_2,
                      onChanged: (bool? value) {
                        setState(() {
                          labCheck_2 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'طلب تعديل',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: labCheck_3,
                      onChanged: (bool? value) {
                        setState(() {
                          labCheck_3 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'تعديل في المخبر',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: labCheck_4,
                      onChanged: (bool? value) {
                        setState(() {
                          labCheck_4 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'فحصت بعد التصليح',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: labCheck_5,
                      onChanged: (bool? value) {
                        setState(() {
                          labCheck_5 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'المعلومات جاهزة للأرشفة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: labCheck_6,
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
                          if (_startTimeController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد وقت البدء قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (_finishTimeController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد وقت الإنتهاء قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (_completionDateController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد تاريخ الانتهاء قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (batchTemperatureController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد حرارة الطبخة قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (densityController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد كثافة الطبخة قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                        }
                        setState(() {
                          labCheck_6 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: employeeController, labelText: 'موظف المخبر'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _startTimeController,
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
                              _startTimeController.text = formattedTime;
                              _calculateDuration();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: _finishTimeController,
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
                              _finishTimeController.text = formattedTime;
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
                ],
              ),
            ),
            const SizedBox(width: 16),
            //-- COLUMN 2 --
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: concealmentController,
                          labelText: 'السترية',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: smoothnessController,
                          labelText: 'النعومة',
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
                          controller: viscosityController,
                          labelText: 'اللزوجة',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: densityController,
                          labelText: 'الكثافة',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
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
                          controller: glossController,
                          labelText: 'اللمعة',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              (labColor ?? false)
                                  ? 'اللون مطابق'
                                  : 'اللون غير مطابق',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Checkbox(
                              value: labColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  labColor = value ?? false;
                                });
                              },
                            ),
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
                          controller: batchTemperatureController,
                          labelText: 'حرارة الطبخة',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          readOnly: true,
                          controller: _completionDateController,
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
                                _completionDateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
        if ((groups!.contains('admins') || groups!.contains('lab_dep')) &&
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
              _fillLabModelFromFomr();
              context.read<ProductionBloc>().add(SaveLab(labModel: _labModel));
            },
          ),
      ],
    );
  }

  void _calculateDuration() {
    if (_startTimeController.text.isNotEmpty &&
        _finishTimeController.text.isNotEmpty) {
      final format = DateFormat('HH:mm');

      final DateTime startTime = format.parse(_startTimeController.text);
      final DateTime finishTime = format.parse(_finishTimeController.text);

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
    if (_startTimeController.text.isEmpty ||
        _finishTimeController.text.isEmpty) {
      return true; // Allow empty values
    }

    final format = DateFormat('HH:mm');
    try {
      final DateTime startTime = format.parse(_startTimeController.text);
      final DateTime finishTime = format.parse(_finishTimeController.text);

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
