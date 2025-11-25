import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/overtime_model.dart';

import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/features/HR/ui/overtime/overtime_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

import 'package:intl/intl.dart';

class OvertimePage extends StatelessWidget {
  final OvertimeModel? overtimeModel;
  const OvertimePage({super.key, this.overtimeModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HrBloc(
        HrServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetDepartmentEmployees()),
      child: Builder(
        builder: (context) {
          return OvertimePageChild(overtimeModel: overtimeModel);
        },
      ),
    );
  }
}

class OvertimePageChild extends StatefulWidget {
  final OvertimeModel? overtimeModel;
  const OvertimePageChild({super.key, this.overtimeModel});

  @override
  State<OvertimePageChild> createState() => _OvertimePageChildState();
}

class _OvertimePageChildState extends State<OvertimePageChild> {
  final _employeeFullNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  final _hrNotesController = TextEditingController();
  final _hrApproveDateController = TextEditingController();
  bool? _approve;
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _employeeList = [];
  int? _selectedEmployeeId;
  String _durationText = '';

  @override
  void initState() {
    super.initState();
    if (widget.overtimeModel != null) {
      _employeeFullNameController.text =
          widget.overtimeModel!.employee_full_name ?? '';
      _selectedEmployeeId = widget.overtimeModel!.employee;
      _dateController.text = widget.overtimeModel!.date ?? '';
      _startTimeController.text = widget.overtimeModel!.start_time ?? '';
      _endTimeController.text = widget.overtimeModel!.end_time ?? '';
      _reasonController.text = widget.overtimeModel!.reason ?? '';
      _notesController.text = widget.overtimeModel!.notes ?? '';
      _hrNotesController.text = widget.overtimeModel!.hr_notes ?? '';
      _approve = widget.overtimeModel!.hr_approve;
      _hrApproveDateController.text =
          widget.overtimeModel!.hr_approve_date ?? '';
      _calculateDuration();
    }
    _startTimeController.addListener(_calculateDuration);
    _endTimeController.addListener(_calculateDuration);
  }

  @override
  void dispose() {
    _employeeFullNameController.dispose();
    _dateController.dispose();
    _startTimeController.removeListener(_calculateDuration);
    _endTimeController.removeListener(_calculateDuration);
    _startTimeController.dispose();
    _endTimeController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    _hrNotesController.dispose();
    super.dispose();
  }

  void _calculateDuration() {
    if (_startTimeController.text.isEmpty || _endTimeController.text.isEmpty) {
      setState(() {
        _durationText = '';
      });
      return;
    }

    try {
      final startTime = DateFormat('HH:mm:ss').parse(_startTimeController.text);
      final endTime = DateFormat('HH:mm:ss').parse(_endTimeController.text);

      Duration duration = endTime.difference(startTime);
      if (duration.isNegative) {
        duration = duration + const Duration(hours: 24);
      }

      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      setState(() {
        _durationText = 'المدة: ${hours} ساعة و ${minutes} دقيقة';
      });
    } catch (e) {
      setState(() {
        _durationText = 'خطأ في حساب المدة';
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    DateTime initialDate = now;
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
      } catch (_) {
        initialDate = now;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      setState(() {
        controller.text = formattedTime;
      });
      _calculateDuration();
    }
  }

  Widget _buildEmployeeDropdown({
    required TextEditingController controller,
    required List<Map<String, dynamic>> employeeList,
    required String label,
  }) {
    final options = employeeList.map((e) => e['full_name'] as String).toList();
    final isInOptions =
        options.contains(controller.text) || controller.text.isEmpty;

    if (widget.overtimeModel != null && !isInOptions) {
      return MyTextField(
        controller: controller,
        labelText: label,
        readOnly: true,
      );
    } else {
      return MyDropdownButton(
        value: controller.text.isEmpty ? null : controller.text,
        items: options
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            controller.text = newValue ?? '';
            if (newValue != null) {
              final selectedEmployee = employeeList.firstWhere(
                (e) => e['full_name'] == newValue,
                orElse: () => {'id': null},
              );
              _selectedEmployeeId = selectedEmployee['id'];
            } else {
              _selectedEmployeeId = null;
            }
          });
        },
        labelText: label,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء اختيار الموظف';
          }
          return null;
        },
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final model = _fillModelFromForm();

      if (widget.overtimeModel == null) {
        context.read<HrBloc>().add(AddOvertime(overtimeModel: model));
      } else {
        context.read<HrBloc>().add(UpdateOvertime(
              overtimeModel: model,
              id: widget.overtimeModel!.id,
            ));
      }
    }
  }

  OvertimeModel _fillModelFromForm() {
    return OvertimeModel(
      id: widget.overtimeModel?.id ?? 0,
      employee: _selectedEmployeeId,
      employee_full_name: _employeeFullNameController.text,
      date: _dateController.text,
      start_time: _startTimeController.text,
      end_time: _endTimeController.text,
      reason: _reasonController.text,
      notes: _notesController.text,
      hr_notes: _hrNotesController.text,
      hr_approve: _approve,
      hr_approve_date: _hrApproveDateController.text.isEmpty
          ? null
          : _hrApproveDateController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    List<String>? groups;
    AppUserState state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    final bool isHrOrAdmin = groups != null &&
        (groups.contains('HR_manager') ||
            groups.contains('managers') ||
            groups.contains('admins'));

    // Request is editable if it's new OR if it exists but hasn't been approved/rejected yet
    final bool isEditable = widget.overtimeModel == null ||
        widget.overtimeModel!.hr_approve == null;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            widget.overtimeModel == null ? 'إضافة إضافي' : 'تعديل إضافي',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: BlocConsumer<HrBloc, HrState>(
          listener: (context, state) {
            // ... (listener logic)
            if (state is GetDepartmentEmployeesSuccess) {
              _employeeList = (state.result as List<dynamic>)
                  .map<Map<String, dynamic>>((e) {
                return {'id': e['id'], 'full_name': e['full_name']};
              }).toList();

              if (widget.overtimeModel != null &&
                  _selectedEmployeeId == null &&
                  _employeeFullNameController.text.isNotEmpty) {
                final selectedEmployee = _employeeList.firstWhere(
                  (e) => e['full_name'] == _employeeFullNameController.text,
                  orElse: () => {'id': null},
                );
                _selectedEmployeeId = selectedEmployee['id'];
              }

              setState(() {});
            } else if (state is HRError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is HRSuccess) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.overtimeModel == null ? 'إضافة' : 'تعديل'} إضافي: ${_employeeFullNameController.text}',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OvertimeListPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HRLoading) {
              return const Center(child: Loader());
            }
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    _buildEmployeeDropdown(
                      controller: _employeeFullNameController,
                      employeeList: _employeeList,
                      label: 'اسم الموظف',
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: _dateController,
                            labelText: 'التاريخ',
                            readOnly: !isEditable,
                            onTap: isEditable
                                ? () => _selectDate(_dateController)
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء اختيار تاريخ الإضافي';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyTextField(
                            controller: _startTimeController,
                            labelText: 'وقت البدء',
                            readOnly: !isEditable,
                            onTap: isEditable
                                ? () => _selectTime(_startTimeController)
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء اختيار وقت البدء';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyTextField(
                            controller: _endTimeController,
                            labelText: 'وقت الانتهاء',
                            readOnly: !isEditable,
                            onTap: isEditable
                                ? () => _selectTime(_endTimeController)
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء اختيار وقت الانتهاء';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_durationText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          _durationText,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _reasonController,
                      labelText: 'سبب الإضافي',
                      maxLines: 5,
                      readOnly: !isEditable,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال سبب الإضافي';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Applicant Notes Field
                    MyTextField(
                      controller: _notesController,
                      labelText: 'ملاحظات الموظف',
                      maxLines: 5,
                      readOnly: !isEditable,
                    ),
                    const SizedBox(height: 20),

                    if (widget.overtimeModel != null && isHrOrAdmin) ...[
                      const Divider(),
                      const Text(
                        'إجراءات الموارد البشرية',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      RadioListTile<bool?>(
                        value: null,
                        groupValue: _approve,
                        onChanged: (value) {
                          setState(() {
                            _approve = value;
                            _hrApproveDateController.clear();
                          });
                        },
                        title: const Text('التوقيع غير محدد'),
                      ),
                      RadioListTile<bool?>(
                        value: true,
                        groupValue: _approve,
                        onChanged: (value) {
                          setState(() {
                            _approve = value;
                            _hrApproveDateController.text =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                          });
                        },
                        title: const Text('موافق'),
                      ),
                      RadioListTile<bool?>(
                        value: false,
                        groupValue: _approve,
                        onChanged: (value) {
                          setState(() {
                            _approve = value;
                            _hrApproveDateController.text =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                          });
                        },
                        title: const Text('مرفوض'),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              controller: _hrApproveDateController,
                              labelText: 'تاريخ التوقيع',
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: MyTextField(
                              controller: _hrNotesController,
                              labelText: 'ملاحظات',
                              maxLines: 5,
                              readOnly: false,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.overtimeModel == null)
                          Mybutton(
                            text: 'إضافة',
                            onPressed: _submitForm,
                          ),
                        if (widget.overtimeModel != null && isEditable)
                          Mybutton(
                            text: 'تعديل',
                            onPressed: _submitForm,
                          ),
                        if (widget.overtimeModel != null && !isEditable)
                          Mybutton(
                            text: 'حفظ ملاحظات الموارد',
                            onPressed: _submitForm,
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
