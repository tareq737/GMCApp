import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/additional_operations/bloc/additional_operations_bloc.dart';
import 'package:gmcappclean/features/production_management/additional_operations/models/additional_operations_model.dart';
import 'package:gmcappclean/features/production_management/additional_operations/services/additional_operations_services.dart';
import 'package:gmcappclean/features/production_management/additional_operations/ui/list_additional_operations_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class AddAdditionalOperationPage extends StatefulWidget {
  final AdditionalOperationsModel? additionalOperationsModel;
  const AddAdditionalOperationPage({super.key, this.additionalOperationsModel});

  @override
  State<AddAdditionalOperationPage> createState() =>
      _AddAdditionalOperationPageState();
}

class _AddAdditionalOperationPageState
    extends State<AddAdditionalOperationPage> {
  final List<String> departments = [
    'قسم الأولية',
    'قسم التصنيع',
    'قسم المخبر',
    'قسم الفوارغ',
    'قسم التعبئة',
    'قسم الجاهزة',
  ];

  final departmentMapping = {
    'قسم التصنيع': 'Manufacturing',
    'قسم المخبر': 'Lab',
    'قسم الأولية': 'RawMaterials',
    'قسم الفوارغ': 'EmptyPackaging',
    'قسم التعبئة': 'Packaging',
    'قسم الجاهزة': 'FinishedGoods',
  };
  final reverseDepartmentMapping = {
    'Manufacturing': 'قسم التصنيع',
    'Lab': 'قسم المخبر',
    'RawMaterials': 'قسم الأولية',
    'EmptyPackaging': 'قسم الفوارغ',
    'Packaging': 'قسم التعبئة',
    'FinishedGoods': 'قسم الجاهزة',
  };

  List<DropdownMenuItem<String>> dropdownDepartmentItems() {
    return departments.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  String? selectedDepartment;
  String durationText = '';

  final _operationController = TextEditingController();
  final _notesController = TextEditingController();
  final _insertDateController = TextEditingController();
  final _workerController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _finishTimeController = TextEditingController();
  bool? doneCheck = false;

  @override
  void initState() {
    super.initState();
    if (widget.additionalOperationsModel != null) {
      selectedDepartment = reverseDepartmentMapping[
          widget.additionalOperationsModel!.department];

      _operationController.text =
          widget.additionalOperationsModel!.operation ?? '';
      _notesController.text = widget.additionalOperationsModel!.notes ?? '';
      _insertDateController.text =
          widget.additionalOperationsModel!.completion_date ?? '';
      _workerController.text = widget.additionalOperationsModel!.worker ?? '';
      _startTimeController.text =
          widget.additionalOperationsModel!.start_time ?? '';
      _finishTimeController.text =
          widget.additionalOperationsModel!.finish_time ?? '';
      doneCheck = widget.additionalOperationsModel!.done;

      if (_startTimeController.text.isNotEmpty &&
          _finishTimeController.text.isNotEmpty) {
        _calculateDuration();
      }
    }
  }

  @override
  void dispose() {
    _operationController.dispose();
    _notesController.dispose();
    _insertDateController.dispose();
    _workerController.dispose();
    _startTimeController.dispose();
    _finishTimeController.dispose();
    super.dispose();
  }

  void _calculateDuration() {
    if (_startTimeController.text.isNotEmpty &&
        _finishTimeController.text.isNotEmpty) {
      final format = DateFormat('hh:mm a');

      try {
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
      } catch (e) {
        print('Error parsing time: $e');
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    AppUserState appUserState = context.read<AppUserCubit>().state;
    List<String>? userGroups;
    if (appUserState is AppUserLoggedIn) {
      userGroups = appUserState.userEntity.groups;
    }

    final bool isAdmin = userGroups != null && userGroups.contains('admins');

    String? currentItemDepartmentCode =
        widget.additionalOperationsModel?.department;
    String? requiredGroupForEdit;
    if (currentItemDepartmentCode != null) {
      switch (currentItemDepartmentCode) {
        case 'RawMaterials':
          requiredGroupForEdit = 'raw_material_dep';
          break;
        case 'Manufacturing':
          requiredGroupForEdit = 'manufacturing_dep';
          break;
        case 'Lab':
          requiredGroupForEdit = 'lab_dep';
          break;
        case 'EmptyPackaging':
          requiredGroupForEdit = 'emptyPackaging_dep';
          break;
        case 'Packaging':
          requiredGroupForEdit = 'packaging_dep';
          break;
        case 'FinishedGoods':
          requiredGroupForEdit = 'finishedGoods_dep';
          break;
      }
    }

    // A user can edit/save if they are an admin OR belong to the specific department's group
    final bool canEditCurrentItem = isAdmin ||
        (userGroups != null && userGroups.contains(requiredGroupForEdit));

    // Only admins or production_managers can add new operations
    final bool canAddOperation = isAdmin ||
        (userGroups != null && userGroups.contains('production_managers'));

    return BlocProvider(
      create: (context) => AdditionalOperationsBloc(
        AdditionalOperationsServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: Builder(builder: (context) {
        return BlocConsumer<AdditionalOperationsBloc,
            AdditionalOperationsState>(
          listener: (context, state) {
            if (state
                is AdditionalOperationsSuccess<AdditionalOperationsModel>) {
              showSnackBar(
                context: context,
                content: widget.additionalOperationsModel == null
                    ? 'تم الإضافة بنجاح'
                    : 'تم الحفظ بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListAdditionalOperationsPage(),
                ),
              );
            } else if (state is AdditionalOperationsError) {
              showSnackBar(
                context: context,
                content: 'حدث خطأ ما',
                failure: true,
              );
            }
          },
          builder: (context, state) {
            if (state is AdditionalOperationsLoading) {
              return const Loader();
            }

            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.additionalOperationsModel == null
                      ? 'إضافة عمل إضافي'
                      : 'معلومات العمل الإضافي'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyDropdownButton(
                            value: selectedDepartment,
                            items: dropdownDepartmentItems(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDepartment = newValue ?? '';
                              });
                            },
                            labelText: 'القسم',
                            // Department dropdown is disabled if editing an existing item
                            // but the user CANNOT edit based on permissions.
                            // It will be enabled if it's a new item (widget.additionalOperationsModel == null)

                            isEnabled:
                                widget.additionalOperationsModel == null),
                        MyTextField(
                          readOnly:
                              true, // Date field remains read-only and set by picker
                          controller: _insertDateController,
                          labelText: 'تاريخ العمل',
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _insertDateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                        MyTextField(
                          controller: _operationController,
                          labelText: 'العمل الإضافي',
                          maxLines: 10,
                          // readOnly: !canEditCurrentItem, // REMOVED: Keep editable for viewing
                        ),
                        MyTextField(
                          controller: _notesController,
                          labelText: 'ملاحظات',
                          maxLines: 10,
                          // readOnly: !canEditCurrentItem, // REMOVED: Keep editable for viewing
                        ),
                        MyTextField(
                          controller: _workerController,
                          labelText: 'الموظف',
                          // readOnly: !canEditCurrentItem, // REMOVED: Keep editable for viewing
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                controller: _startTimeController,
                                labelText: 'من الساعة',
                                // readOnly: !canEditCurrentItem, // REMOVED: Keep editable for viewing
                                onTap: () async {
                                  // Always allow tapping for viewing time
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    final now = DateTime.now();
                                    final formattedTime =
                                        DateFormat('hh:mm a').format(
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
                                labelText: 'إلى الساعة',
                                // readOnly: !canEditCurrentItem, // REMOVED: Keep editable for viewing
                                onTap: () async {
                                  // Always allow tapping for viewing time
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    final now = DateTime.now();
                                    final formattedTime =
                                        DateFormat('hh:mm a').format(
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
                        Text(
                          'مدة العمل: $durationText',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        if (widget.additionalOperationsModel != null)
                          CheckboxListTile(
                            title: const Text(
                              'أنجزت المهمة',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: doneCheck,
                            onChanged: (bool? value) {
                              // Always allow changing checkbox
                              setState(() {
                                doneCheck = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // "إضافة" button (for new operations)
                            if (widget.additionalOperationsModel == null &&
                                canAddOperation)
                              Mybutton(
                                text: 'إضافة',
                                onPressed: () {
                                  _fillModelfromFormAdd();
                                  context.read<AdditionalOperationsBloc>().add(
                                        AddAdditionalOperation(
                                          additionalOperationsModel:
                                              additionalOperationsModel!,
                                        ),
                                      );
                                },
                              ),
                            // "حفظ" button (for editing existing operations)
                            // Only show if the user has permission to save
                            if (widget.additionalOperationsModel != null &&
                                canEditCurrentItem)
                              Mybutton(
                                text: 'حفظ',
                                onPressed: () {
                                  // Always enable onPressed if button is visible
                                  _fillModelfromFormSave();
                                  context.read<AdditionalOperationsBloc>().add(
                                        UpdateAdditionalOperation(
                                          additionalOperationsModel:
                                              additionalOperationsModel!,
                                          id: widget
                                              .additionalOperationsModel!.id!,
                                        ),
                                      );
                                },
                              ),
                            // "تعديل" button - assuming this is for specific, possibly non-saving, edits
                            // or a redundant button. Keeping it only for admins as per previous logic.
                            if (widget.additionalOperationsModel != null &&
                                canAddOperation)
                              Mybutton(
                                text: 'تعديل',
                                onPressed: () {
                                  _fillModelfromFormEdit();
                                  context.read<AdditionalOperationsBloc>().add(
                                        UpdateAdditionalOperation(
                                          additionalOperationsModel:
                                              additionalOperationsModel!,
                                          id: widget
                                              .additionalOperationsModel!.id!,
                                        ),
                                      );
                                },
                              ),
                          ],
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

  AdditionalOperationsModel? additionalOperationsModel;

  void _fillModelfromFormAdd() {
    additionalOperationsModel ??= AdditionalOperationsModel();
    additionalOperationsModel!.completion_date = _insertDateController.text;
    additionalOperationsModel!.operation = _operationController.text;
    additionalOperationsModel!.notes = _notesController.text;
    additionalOperationsModel!.done = false;
    additionalOperationsModel!.department =
        departmentMapping[selectedDepartment];
  }

  void _fillModelfromFormSave() {
    additionalOperationsModel ??= widget.additionalOperationsModel;
    // Update all fields from controllers, as they are now always editable.
    additionalOperationsModel!.completion_date = _insertDateController.text;
    additionalOperationsModel!.operation = _operationController.text;
    additionalOperationsModel!.notes = _notesController.text;
    additionalOperationsModel!.worker = _workerController.text;
    additionalOperationsModel!.start_time =
        _startTimeController.text.isEmpty ? null : _startTimeController.text;
    additionalOperationsModel!.finish_time =
        _finishTimeController.text.isEmpty ? null : _finishTimeController.text;
    additionalOperationsModel!.done = doneCheck;

    // Update department from selectedDepartment if it's not null.
    // The dropdown's `isEnabled` handles whether it can be changed.
    additionalOperationsModel!.department =
        departmentMapping[selectedDepartment];
  }

  void _fillModelfromFormEdit() {
    additionalOperationsModel ??= widget.additionalOperationsModel;
    additionalOperationsModel!.completion_date = _insertDateController.text;
    additionalOperationsModel!.operation = _operationController.text;
    additionalOperationsModel!.notes = _notesController.text;
    additionalOperationsModel!.done = false;
    // Assuming 'تعديل' (Modify/Edit) button updates only these specific fields
    // If it should update others, add them here.
  }
}
