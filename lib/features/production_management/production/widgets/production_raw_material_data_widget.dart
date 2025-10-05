// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/raw_materials_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ProductionRawMaterialDataWidget extends StatefulWidget {
  final String type;
  final FullProductionModel fullProductionModel;
  const ProductionRawMaterialDataWidget(
      {super.key, required this.fullProductionModel, required this.type});

  @override
  State<ProductionRawMaterialDataWidget> createState() =>
      _ProductionRawMaterialDataWidgetState();
}

class _ProductionRawMaterialDataWidgetState
    extends State<ProductionRawMaterialDataWidget> {
  List<String>? groups;
  final _startTimeController = TextEditingController();
  final _finishTimeController = TextEditingController();
  String _durationText = '';
  final _completionDateController = TextEditingController();
  final _handoverDateController = TextEditingController();
  bool? rawMaterialCheck_1 = false;
  bool? rawMaterialCheck_2 = false;
  bool? rawMaterialCheck_3 = false;
  bool? rawMaterialCheck_4 = false;
  final _receiptNumberController = TextEditingController();
  final _weightController = TextEditingController();
  final _employeeController = TextEditingController();
  final _problemsController = TextEditingController();
  final _notesController = TextEditingController();

  final RawMaterialsModel _rawMaterialsModel = RawMaterialsModel();
  void _fillRawMaterialModelFromFomr() {
    _rawMaterialsModel.id = widget.fullProductionModel.rawMaterials.id;
    _rawMaterialsModel.raw_material_check_1 = rawMaterialCheck_1 ?? false;
    _rawMaterialsModel.raw_material_check_2 = rawMaterialCheck_2 ?? false;
    _rawMaterialsModel.raw_material_check_3 = rawMaterialCheck_3 ?? false;
    _rawMaterialsModel.raw_material_check_4 = rawMaterialCheck_4 ?? false;
    _rawMaterialsModel.employee = _employeeController.text;
    _rawMaterialsModel.receipt_number =
        int.tryParse(_receiptNumberController.text);
    _rawMaterialsModel.raw_material_weight =
        double.tryParse(_weightController.text);
    _rawMaterialsModel.notes = _notesController.text;
    _rawMaterialsModel.problems = _problemsController.text;
    _rawMaterialsModel.start_time =
        _startTimeController.text.isEmpty ? null : _startTimeController.text;
    _rawMaterialsModel.finish_time =
        _finishTimeController.text.isEmpty ? null : _finishTimeController.text;
    _rawMaterialsModel.completion_date = _completionDateController.text.isEmpty
        ? null
        : _completionDateController.text;
    _rawMaterialsModel.handover_date = _handoverDateController.text.isEmpty
        ? null
        : _handoverDateController.text;
  }

  @override
  void initState() {
    super.initState();
    rawMaterialCheck_1 =
        widget.fullProductionModel.rawMaterials.raw_material_check_1 ?? false;
    rawMaterialCheck_2 =
        widget.fullProductionModel.rawMaterials.raw_material_check_2 ?? false;
    rawMaterialCheck_3 =
        widget.fullProductionModel.rawMaterials.raw_material_check_3 ?? false;
    rawMaterialCheck_4 =
        widget.fullProductionModel.rawMaterials.raw_material_check_4 ?? false;
    _employeeController.text =
        widget.fullProductionModel.rawMaterials.employee ?? '';
    _receiptNumberController.text =
        widget.fullProductionModel.rawMaterials.receipt_number?.toString() ??
            '';
    _weightController.text = widget
            .fullProductionModel.rawMaterials.raw_material_weight
            ?.toStringAsFixed(2) ??
        '';
    _notesController.text = widget.fullProductionModel.rawMaterials.notes ?? '';
    _problemsController.text =
        widget.fullProductionModel.rawMaterials.problems ?? '';
    _startTimeController.text =
        widget.fullProductionModel.rawMaterials.start_time ?? '';
    _finishTimeController.text =
        widget.fullProductionModel.rawMaterials.finish_time ?? '';
    _completionDateController.text =
        widget.fullProductionModel.rawMaterials.completion_date ?? '';
    _handoverDateController.text =
        widget.fullProductionModel.rawMaterials.handover_date ?? '';

    _calculateDuration();
  }

  final List<String> _employeeList = const [
    'علي هلال',
    'اسماعيل الاحمد',
    'احمد البزال',
  ];
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
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'معلومات قسم الأولية',
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
              'استلمت التركيبة من المخبر',
              style: TextStyle(fontSize: 12),
            ),
            value: rawMaterialCheck_1,
            onChanged: (bool? value) {
              setState(() {
                rawMaterialCheck_1 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'جردت المواد',
              style: TextStyle(fontSize: 12),
            ),
            value: rawMaterialCheck_2,
            onChanged: (bool? value) {
              setState(() {
                rawMaterialCheck_2 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'جهزت للتسليم',
              style: TextStyle(fontSize: 12),
            ),
            value: rawMaterialCheck_3,
            onChanged: (bool? value) {
              setState(() {
                rawMaterialCheck_3 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text(
              'المعلومات جاهزة للأرشفة',
              style: TextStyle(fontSize: 12),
            ),
            value: rawMaterialCheck_4,
            onChanged: (bool? value) {
              if (value == true) {
                if (_employeeController.text.trim().isEmpty) {
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

                if (_receiptNumberController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد رقم الوصل قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (_weightController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد الوزن قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (_completionDateController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد تاريخ التجهيز قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
                if (_handoverDateController.text.trim().isEmpty) {
                  showSnackBar(
                    context: context,
                    content: 'يرجى تحديد تاريخ التسليم قبل الأرشفة',
                    failure: true,
                  );
                  return;
                }
              }
              setState(() {
                rawMaterialCheck_4 = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
        EmployeeInputField(
          controller: _employeeController,
          employeeList: _employeeList,
          labelText: 'موظف الأولية',
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: _startTimeController,
                labelText: 'وقت بدء الأولية',
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
                labelText: 'وقت انتهاء الأولية',
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
        const SizedBox(
          height: 10,
        ),
        Text(
          'مدة العمل: $_durationText',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: MyTextField(
                readOnly: true,
                controller: _completionDateController,
                labelText: 'تاريخ انتهاء تجهيز المواد',
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
            Expanded(
              child: MyTextField(
                readOnly: true,
                controller: _handoverDateController,
                labelText: 'تاريخ تسليم المواد للتصنيع',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _handoverDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: _receiptNumberController,
                labelText: 'رقم وصل الأولية',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: MyTextField(
                controller: _weightController,
                labelText: 'وزن المواد الأولية',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
            maxLines: 10,
            controller: _notesController,
            labelText: 'ملاحظات الأولية'),
        const SizedBox(
          height: 10,
        ),
        MyTextField(
            maxLines: 10,
            controller: _problemsController,
            labelText: 'مشاكل الأولية'),
        const SizedBox(
          height: 10,
        ),
        if ((groups!.contains('admins') ||
                groups!.contains('raw_material_dep')) &&
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
              _fillRawMaterialModelFromFomr();
              context
                  .read<ProductionBloc>()
                  .add(SaveRawMaterial(rawMaterialsModel: _rawMaterialsModel));
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
                        'استلمت التركيبة من المخبر',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: rawMaterialCheck_1,
                      onChanged: (bool? value) {
                        setState(() {
                          rawMaterialCheck_1 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'جردت المواد',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: rawMaterialCheck_2,
                      onChanged: (bool? value) {
                        setState(() {
                          rawMaterialCheck_2 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'جهزت للتسليم',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: rawMaterialCheck_3,
                      onChanged: (bool? value) {
                        setState(() {
                          rawMaterialCheck_3 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'المعلومات جاهزة للأرشفة',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: rawMaterialCheck_4,
                      onChanged: (bool? value) {
                        if (value == true) {
                          if (_employeeController.text.trim().isEmpty) {
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

                          if (_receiptNumberController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد رقم الوصل قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (_weightController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد الوزن قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (_completionDateController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد تاريخ التجهيز قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                          if (_handoverDateController.text.trim().isEmpty) {
                            showSnackBar(
                              context: context,
                              content: 'يرجى تحديد تاريخ التسليم قبل الأرشفة',
                              failure: true,
                            );
                            return;
                          }
                        }
                        setState(() {
                          rawMaterialCheck_4 = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                  const SizedBox(height: 10),
                  EmployeeInputField(
                    controller: _employeeController,
                    employeeList: _employeeList,
                    labelText: 'موظف الأولية',
                  ),
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
                    'مدة العمل: $_durationText',
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
                    spacing: 10,
                    children: [
                      Expanded(
                        child: MyTextField(
                          readOnly: true,
                          controller: _completionDateController,
                          labelText: 'تاريخ انتهاء تجهيز المواد',
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
                      Expanded(
                        child: MyTextField(
                          readOnly: true,
                          controller: _handoverDateController,
                          labelText: 'تاريخ تسليم المواد للتصنيع',
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _handoverDateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _receiptNumberController,
                          labelText: 'رقم وصل الأولية',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: _weightController,
                          labelText: 'وزن المواد الأولية',
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
                  MyTextField(
                      maxLines: 5,
                      controller: _notesController,
                      labelText: 'ملاحظات'),
                  const SizedBox(height: 10),
                  MyTextField(
                      maxLines: 5,
                      controller: _problemsController,
                      labelText: 'مشاكل'),
                  const SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
        if ((groups!.contains('admins') ||
                groups!.contains('raw_material_dep')) &&
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
              _fillRawMaterialModelFromFomr();
              context
                  .read<ProductionBloc>()
                  .add(SaveRawMaterial(rawMaterialsModel: _rawMaterialsModel));
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
          _durationText = _formatDuration(nextDayDuration);
        });
      } else {
        setState(() {
          _durationText = _formatDuration(duration);
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

class EmployeeInputField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> employeeList;
  final String labelText;

  const EmployeeInputField({
    super.key,
    required this.controller,
    required this.employeeList,
    required this.labelText,
  });

  @override
  State<EmployeeInputField> createState() => _EmployeeInputFieldState();
}

class _EmployeeInputFieldState extends State<EmployeeInputField> {
  bool _showTextField = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    final initialValue = widget.controller.text;

    // Check if the controller has a value and if that value is NOT in our list
    if (initialValue.isNotEmpty &&
        !widget.employeeList.contains(initialValue)) {
      // If yes, we need to show the TextField to display this custom value
      setState(() {
        _showTextField = true;
      });
    } else {
      // Otherwise, show the Dropdown.
      // If the initial value is valid, set it as the selected item.
      setState(() {
        _showTextField = false;
        _selectedValue = initialValue.isNotEmpty ? initialValue : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showTextField) {
      // Fallback to the original TextField if the employee name is not in the list
      return MyTextField(
        controller: widget.controller,
        labelText: widget.labelText,
        // It's good practice to make it read-only to show historical data
        // You can set this to `false` if you want to allow editing the custom name
        readOnly: true,
      );
    } else {
      // Show the Dropdown if the employee name is in the list or is empty
      return MyDropdownButton(
        labelText: widget.labelText,
        value: _selectedValue,
        items:
            widget.employeeList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
            // IMPORTANT: Update the controller so the rest of your form logic works correctly
            widget.controller.text = newValue ?? '';
          });
        },
      );
    }
  }
}
