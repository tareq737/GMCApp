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
import 'package:gmcappclean/features/production_management/production/models/manufacturing_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ProductionManufacturingDataWidget extends StatefulWidget {
  final String type;
  final FullProductionModel fullProductionModel;
  const ProductionManufacturingDataWidget({
    super.key,
    required this.fullProductionModel,
    required this.type,
  });

  @override
  State<ProductionManufacturingDataWidget> createState() =>
      _ProductionManufacturingDataWidgetState();
}

class _ProductionManufacturingDataWidgetState
    extends State<ProductionManufacturingDataWidget> {
  List<String>? groups;
  final startTimeController = TextEditingController();
  final finishTimeController = TextEditingController();
  final problemsController = TextEditingController();
  String durationText = '';
  final completionDateController = TextEditingController();
  bool? manufacturingCheck_1 = false;
  bool? manufacturingCheck_2 = false;
  bool? manufacturingCheck_3 = false;
  bool? manufacturingCheck_4 = false;
  bool? manufacturingCheck_5 = false;
  bool? manufacturingCheck_6 = false;
  final employeeController = TextEditingController();
  final notesController = TextEditingController();
  final batchWeightController = TextEditingController();
  final additionsController = TextEditingController();
  final ManufacturingModel _manufacturingModel = ManufacturingModel();

  void _fillManufacturingModelFromFomr() {
    _manufacturingModel.id = widget.fullProductionModel.manufacturing.id;

    _manufacturingModel.start_time =
        startTimeController.text.isEmpty ? null : startTimeController.text;
    _manufacturingModel.finish_time =
        finishTimeController.text.isEmpty ? null : finishTimeController.text;
    _manufacturingModel.completion_date = completionDateController.text.isEmpty
        ? null
        : completionDateController.text;

    _manufacturingModel.problems = problemsController.text;
    _manufacturingModel.manufacturing_check_1 = manufacturingCheck_1;
    _manufacturingModel.manufacturing_check_2 = manufacturingCheck_2;
    _manufacturingModel.manufacturing_check_3 = manufacturingCheck_3;
    _manufacturingModel.manufacturing_check_4 = manufacturingCheck_4;
    _manufacturingModel.manufacturing_check_5 = manufacturingCheck_5;
    _manufacturingModel.manufacturing_check_6 = manufacturingCheck_6;
    _manufacturingModel.employee = employeeController.text;
    _manufacturingModel.notes = notesController.text;
    _manufacturingModel.batch_weight =
        double.tryParse(batchWeightController.text);
    _manufacturingModel.additions = additionsController.text;
  }

  @override
  void initState() {
    super.initState();
    startTimeController.text =
        widget.fullProductionModel.manufacturing.start_time ?? '';
    finishTimeController.text =
        widget.fullProductionModel.manufacturing.finish_time ?? '';
    problemsController.text =
        widget.fullProductionModel.manufacturing.problems ?? '';
    completionDateController.text =
        widget.fullProductionModel.manufacturing.completion_date ?? '';
    manufacturingCheck_1 =
        widget.fullProductionModel.manufacturing.manufacturing_check_1 ?? false;
    manufacturingCheck_2 =
        widget.fullProductionModel.manufacturing.manufacturing_check_2 ?? false;
    manufacturingCheck_3 =
        widget.fullProductionModel.manufacturing.manufacturing_check_3 ?? false;
    manufacturingCheck_4 =
        widget.fullProductionModel.manufacturing.manufacturing_check_4 ?? false;
    manufacturingCheck_5 =
        widget.fullProductionModel.manufacturing.manufacturing_check_5 ?? false;
    manufacturingCheck_6 =
        widget.fullProductionModel.manufacturing.manufacturing_check_6 ?? false;
    employeeController.text =
        widget.fullProductionModel.manufacturing.employee ?? '';
    notesController.text = widget.fullProductionModel.manufacturing.notes ?? '';
    batchWeightController.text =
        widget.fullProductionModel.manufacturing.batch_weight != null
            ? widget.fullProductionModel.manufacturing.batch_weight!
                .toStringAsFixed(2)
            : '';
    additionsController.text =
        widget.fullProductionModel.manufacturing.additions ?? '';

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
                  // Added to prevent overflow
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'معلومات قسم التصنيع',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),

                      //-- Using LayoutBuilder to get context that rebuilds on size change --
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
              'استلمت من الأولية',
              style: TextStyle(fontSize: 12),
            ),
            value: manufacturingCheck_1,
            onChanged: (bool? value) {
              setState(() {
                manufacturingCheck_1 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'ركبت في المكنة',
              style: TextStyle(fontSize: 12),
            ),
            value: manufacturingCheck_2,
            onChanged: (bool? value) {
              setState(() {
                manufacturingCheck_2 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'قيد التصنيع',
              style: TextStyle(fontSize: 12),
            ),
            value: manufacturingCheck_3,
            onChanged: (bool? value) {
              setState(() {
                manufacturingCheck_3 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'انتهت من التصنيع',
              style: TextStyle(fontSize: 12),
            ),
            value: manufacturingCheck_4,
            onChanged: (bool? value) {
              setState(() {
                manufacturingCheck_4 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'فلترت',
              style: TextStyle(fontSize: 12),
            ),
            value: manufacturingCheck_5,
            onChanged: (bool? value) {
              setState(() {
                manufacturingCheck_5 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'المعلومات جاهزة للأرشفة',
              style: TextStyle(fontSize: 12),
            ),
            value: manufacturingCheck_6,
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
                if (batchWeightController.text.trim().isEmpty) {
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
                manufacturingCheck_6 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
        MyTextField(controller: employeeController, labelText: 'موظف التصنيع'),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: startTimeController,
                labelText: 'وقت بدء التصنيع',
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: MyTextField(
                controller: finishTimeController,
                labelText: 'وقت انتهاء التصنيع',
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
          children: [
            Expanded(
              child: MyTextField(
                controller: batchWeightController,
                labelText: 'وزن التصنيع',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: MyTextField(
                readOnly: true,
                controller: completionDateController,
                labelText: 'تاريخ انتهاء التصنيع',
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
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyTextField(
            maxLines: 10,
            controller: additionsController,
            labelText: 'إضافات التصنيع'),
        const SizedBox(height: 10),
        MyTextField(
            maxLines: 10,
            controller: notesController,
            labelText: 'ملاحظات التصنيع'),
        const SizedBox(height: 10),
        MyTextField(
            maxLines: 10,
            controller: problemsController,
            labelText: 'مشاكل التصنيع'),
        if ((groups!.contains('admins') ||
                groups!.contains('manufacturing_dep')) &&
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
              _fillManufacturingModelFromFomr();
              print(_manufacturingModel);
              context.read<ProductionBloc>().add(
                  SaveManufacturing(manufacturingModel: _manufacturingModel));
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
                        'استلمت من الأولية',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: manufacturingCheck_1,
                      onChanged: (bool? value) {
                        setState(() {
                          manufacturingCheck_1 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'ركبت في المكنة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: manufacturingCheck_2,
                      onChanged: (bool? value) {
                        setState(() {
                          manufacturingCheck_2 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'قيد التصنيع',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: manufacturingCheck_3,
                      onChanged: (bool? value) {
                        setState(() {
                          manufacturingCheck_3 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'انتهت من التصنيع',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: manufacturingCheck_4,
                      onChanged: (bool? value) {
                        setState(() {
                          manufacturingCheck_4 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'فلترت',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: manufacturingCheck_5,
                      onChanged: (bool? value) {
                        setState(() {
                          manufacturingCheck_5 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'المعلومات جاهزة للأرشفة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: manufacturingCheck_6,
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
                          if (batchWeightController.text.trim().isEmpty) {
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
                          manufacturingCheck_6 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: employeeController,
                      labelText: 'موظف التصنيع'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: startTimeController,
                          labelText: 'وقت بدء التصنيع',
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
                          labelText: 'وقت انتهاء التصنيع',
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
                ],
              ),
            ),
            const SizedBox(width: 16), // Spacer between columns
            //-- COLUMN 2 --
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: batchWeightController,
                          labelText: 'وزن التصنيع',
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
                          controller: completionDateController,
                          labelText: 'تاريخ انتهاء التصنيع',
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      maxLines: 5, // Reduced maxLines for landscape
                      controller: additionsController,
                      labelText: 'إضافات التصنيع'),
                  const SizedBox(height: 10),
                  MyTextField(
                      maxLines: 5, // Reduced maxLines for landscape
                      controller: notesController,
                      labelText: 'ملاحظات التصنيع'),
                  const SizedBox(height: 10),
                  MyTextField(
                      maxLines: 5, // Reduced maxLines for landscape
                      controller: problemsController,
                      labelText: 'مشاكل التصنيع'),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if ((groups!.contains('admins') ||
                groups!.contains('manufacturing_dep')) &&
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
              _fillManufacturingModelFromFomr();
              print(_manufacturingModel);
              context.read<ProductionBloc>().add(
                  SaveManufacturing(manufacturingModel: _manufacturingModel));
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
