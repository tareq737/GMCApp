import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gmcappclean/core/Pages/view_image_page.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/workleaves_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/features/HR/ui/work%20leaves/work_leaves_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class WorkLeavesPage extends StatelessWidget {
  final WorkleavesModel? workleavesModel;

  const WorkLeavesPage({super.key, this.workleavesModel});

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
          return WorkLeavesPageChild(workleavesModel: workleavesModel);
        },
      ),
    );
  }
}

class WorkLeavesPageChild extends StatefulWidget {
  final WorkleavesModel? workleavesModel;

  const WorkLeavesPageChild({super.key, this.workleavesModel});

  @override
  State<WorkLeavesPageChild> createState() => _WorkLeavesPageChildState();
}

class _WorkLeavesPageChildState extends State<WorkLeavesPageChild> {
  File? _billImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickBillImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File? compressedImage = await _compressImage(File(pickedFile.path));
      setState(() {
        _billImage = compressedImage;
      });
    }
  }

  Future<File?> _compressImage(File file) async {
    // Skip compression on Windows
    if (Platform.isWindows) {
      return file; // Return the original file without compression
    }

    // Proceed with compression for other platforms (Android, iOS, etc.)
    final directory = await getTemporaryDirectory();
    final targetPath =
        '${directory.path}/${p.basename(file.path)}_compressed.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    return result != null ? File(result.path) : null;
  }

  Future<void> _confirmDelete(BuildContext context, Function onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button!
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد الحذف'), // Confirmation
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('هل أنت متأكد من رغبتك في حذف التقرير'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child:
                    const Text('إلغاء', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: const Text('حذف',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onConfirm();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final _employeeFullNameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _durationController = TextEditingController();
  final _depHeadNotesController = TextEditingController();
  final _hrNotesController = TextEditingController();
  final _managerNotesController = TextEditingController();
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _employeeList = [];
  int? _selectedEmployeeId;
  String? _selectedKind;
  String? _selectedDurationUnit;

  final List<String> _leaveKinds = [
    'إدارية',
    'بدون راتب',
    'مرضية',
    'حج',
    'زواج',
  ];
  final List<String> _durationUnits = ['أيام', 'ساعات'];

  @override
  void initState() {
    super.initState();
    if (widget.workleavesModel != null) {
      _employeeFullNameController.text =
          widget.workleavesModel!.employee_full_name ?? '';
      _selectedEmployeeId = widget.workleavesModel!.employee;
      _selectedKind = widget.workleavesModel!.kind;
      _startDateController.text = widget.workleavesModel!.start_date ?? '';
      _startTimeController.text = widget.workleavesModel!.start_time ?? '';
      _durationController.text = widget.workleavesModel!.duration ?? '';
      _selectedDurationUnit = widget.workleavesModel!.duration_unit;
      _depHeadNotesController.text =
          widget.workleavesModel!.dep_head_notes ?? '';
      _hrNotesController.text = widget.workleavesModel!.hr_notes ?? '';
      _managerNotesController.text =
          widget.workleavesModel!.manager_notes ?? '';
      _reasonController.text = widget.workleavesModel!.reason ?? '';
    }
  }

  @override
  void dispose() {
    _employeeFullNameController.dispose();
    _startDateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Widget _buildEmployeeDropdown({
    required TextEditingController controller,
    required List<Map<String, dynamic>> employeeList,
    required String label,
  }) {
    final options = employeeList.map((e) => e['full_name'] as String).toList();
    final isInOptions =
        options.contains(controller.text) || controller.text.isEmpty;

    if (widget.workleavesModel != null && !isInOptions) {
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

      if (widget.workleavesModel == null) {
        context.read<HrBloc>().add(AddWorkLeave(workleavesModel: model));
      } else {
        context.read<HrBloc>().add(UpdateWorkLeave(
              workleavesModel: model,
              id: widget.workleavesModel!.id,
            ));
      }
    }
  }

  void _showApprovalDialog(String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedValue;
        final notesController = TextEditingController();

        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return AlertDialog(
                title: const Text("الموافقة على الإجازة"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text("مع الموافقة"),
                        value: "approved",
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("مع عدم الموافقة"),
                        value: "rejected",
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("غير محدد"),
                        value: "pending",
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: notesController,
                        labelText: 'ملاحظات',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("إلغاء"),
                  ),
                  TextButton(
                    onPressed: selectedValue == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            _handleApprovalSelection(
                              selectedValue!,
                              notesController.text,
                              buttonText,
                            );
                          },
                    child: const Text("حفظ"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _handleApprovalSelection(String value, String notes, String buttonText) {
    // Determine role based on button text
    String role = '';
    switch (buttonText) {
      case 'توقيع رئيس القسم':
        role = "رئيس قسم";
        break;
      case 'توقيع الموارد البشرية':
        role = "مسؤول موارد بشرية";
        break;
      case 'توقيع المدير':
        role = "مدير";
        break;
    }

    switch (value) {
      case "approved":
        context.read<HrBloc>().add(
              WorkLeaveApprove(
                id: widget.workleavesModel!.id,
                approve: 'true',
                role: role,
                notes: notes,
              ),
            );
        break;
      case "rejected":
        context.read<HrBloc>().add(
              WorkLeaveApprove(
                id: widget.workleavesModel!.id,
                approve: 'false',
                role: role,
                notes: notes,
              ),
            );
        break;
      case "pending":
        context.read<HrBloc>().add(
              WorkLeaveApprove(
                id: widget.workleavesModel!.id,
                approve: 'null',
                role: role,
                notes: notes,
              ),
            );
        break;
    }
  }

  WorkleavesModel _fillModelFromForm() {
    return WorkleavesModel(
        id: widget.workleavesModel?.id ?? 0,
        employee: _selectedEmployeeId,
        kind: _selectedKind,
        start_date: _startDateController.text,
        start_time:
            _selectedDurationUnit == 'ساعات' ? _startTimeController.text : null,
        duration: _durationController.text,
        duration_unit: _selectedDurationUnit,
        reason: _reasonController.text);
  }

  @override
  Widget build(BuildContext context) {
    List<String>? groups;
    AppUserState state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.workleavesModel == null ? 'إضافة إجازة' : 'تعديل إجازة'),
        ),
        body: BlocConsumer<HrBloc, HrState>(
          listener: (context, state) {
            if (state is GetDepartmentEmployeesSuccess) {
              _employeeList = (state.result as List<dynamic>)
                  .map<Map<String, dynamic>>((e) {
                return {'id': e['id'], 'full_name': e['full_name']};
              }).toList();

              if (widget.workleavesModel != null &&
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
            } else if (state is HRSuccess<Uint8List>) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewImagePage(imageData: state.result),
                  ),
                );
              });
            } else if (state is HRSuccess<bool>) {
              showSnackBar(
                context: context,
                content: 'تم حذف التقرير',
                failure: false,
              );
              Navigator.pop(context);

              int? selectedProgress;
              if (groups?.contains('managers') ?? false) {
                selectedProgress = 2;
              } else if (groups?.contains('HR_manager') ?? false) {
                selectedProgress = 1;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkLeavesListPage(
                    selectedProgress: selectedProgress,
                  ),
                ),
              );
            } else if (state is ImageSavedSuccess) {
              showSnackBar(
                context: context,
                content: 'تم حفظ التقرير',
                failure: false,
              );
              Navigator.pop(context);

              int? selectedProgress;
              if (groups?.contains('managers') ?? false) {
                selectedProgress = 2;
              } else if (groups?.contains('HR_manager') ?? false) {
                selectedProgress = 1;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkLeavesListPage(
                    selectedProgress: selectedProgress,
                  ),
                ),
              );
            } else if (state is HRSuccess) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.workleavesModel == null ? 'إضافة' : 'تعديل'} إجازة: ${_employeeFullNameController.text}',
                failure: false,
              );

              Navigator.pop(context);

              int? selectedProgress;
              if (groups?.contains('managers') ?? false) {
                selectedProgress = 2;
              } else if (groups?.contains('HR_manager') ?? false) {
                selectedProgress = 1;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkLeavesListPage(
                    selectedProgress: selectedProgress,
                  ),
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
                  children: [
                    const SizedBox(height: 10),
                    _buildEmployeeDropdown(
                      controller: _employeeFullNameController,
                      employeeList: _employeeList,
                      label: 'اسم الموظف',
                    ),
                    const SizedBox(height: 10),
                    MyDropdownButton(
                      value: _selectedKind,
                      items: _leaveKinds
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedKind = newValue;
                        });
                      },
                      labelText: 'نوع الإجازة',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء اختيار نوع الإجازة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            readOnly: true,
                            controller: _startDateController,
                            validator: (value) =>
                                value!.isEmpty ? 'يجب إدخال التاريخ' : null,
                            labelText: 'تاريخ البدء',
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _startDateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (_selectedDurationUnit == 'ساعات')
                          Expanded(
                            child: MyTextField(
                              controller: _startTimeController,
                              labelText: 'وقت البدء',
                              readOnly: true,
                              validator: (value) {
                                if (_selectedDurationUnit == 'ساعات') {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال وقت البدء';
                                  }
                                }
                                return null;
                              },
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
                                  setState(() {
                                    _startTimeController.text = formattedTime;
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
                        // Duration Text Field
                        Expanded(
                          child: MyTextField(
                            controller: _durationController,
                            labelText: 'المدة',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال المدة';
                              }
                              if (double.tryParse(value) == null) {
                                return 'يجب أن تكون المدة رقمًا';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Duration Unit Dropdown
                        Expanded(
                          child: MyDropdownButton(
                            value: _selectedDurationUnit,
                            items: _durationUnits
                                .map((option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDurationUnit = newValue;
                              });
                            },
                            labelText: 'الوحدة',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء اختيار الوحدة';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _reasonController,
                      labelText: 'سبب الإجازة',
                      maxLines: 10,
                    ),
                    if (widget.workleavesModel != null)
                      if (widget.workleavesModel!.kind == 'مرضية')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.workleavesModel!.medical_report != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_red_eye,
                                            color: Colors.blue),
                                        tooltip: 'عرض التقرير الطبي',
                                        onPressed: () {
                                          context.read<HrBloc>().add(
                                                GetWorkLeavesReportImage(
                                                    id: widget
                                                        .workleavesModel!.id),
                                              );
                                        },
                                      ),
                                      const Text('عرض التقرير الطبي',
                                          style: TextStyle(fontSize: 12)),
                                      const SizedBox(
                                          width:
                                              20), // Add spacing between the two actions
                                      if (widget.workleavesModel!.progress ==
                                              1 ||
                                          widget.workleavesModel!.progress == 0)
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          tooltip: 'حذف التقرير الطبي',
                                          onPressed: () {
                                            _confirmDelete(context, () {
                                              context.read<HrBloc>().add(
                                                    DeleteWorkLeavesReportImage(
                                                        id: widget
                                                            .workleavesModel!
                                                            .id),
                                                  );
                                            });
                                          },
                                        ),
                                      if (widget.workleavesModel!.progress ==
                                              1 ||
                                          widget.workleavesModel!.progress == 0)
                                        const Text('حذف التقرير الطبي',
                                            style: TextStyle(fontSize: 12)),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (Platform.isAndroid)
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.camera_alt,
                                                  color: Colors.green),
                                              tooltip: 'تصوير التقرير الطبي',
                                              onPressed: () async {
                                                await _pickBillImage(
                                                    ImageSource.camera);
                                                if (_billImage != null) {
                                                  context.read<HrBloc>().add(
                                                      AddWorkLeavesReportImage(
                                                          image: _billImage!,
                                                          id: widget
                                                              .workleavesModel!
                                                              .id));
                                                }
                                              },
                                            ),
                                            const Text('تصوير تقرير طبي',
                                                style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.photo_library,
                                                color: Colors.orange),
                                            tooltip: 'اختيار التقرير الطبي',
                                            onPressed: () async {
                                              await _pickBillImage(
                                                  ImageSource.gallery);
                                              if (_billImage != null) {
                                                context.read<HrBloc>().add(
                                                    AddWorkLeavesReportImage(
                                                        image: _billImage!,
                                                        id: widget
                                                            .workleavesModel!
                                                            .id));
                                              }
                                            },
                                          ),
                                          const Text('اختيار تقرير طبي',
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      controller: _depHeadNotesController,
                      labelText: 'ملاحظات رئيس القسم',
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _hrNotesController,
                      labelText: 'ملاحظات الموارد البشرية',
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _managerNotesController,
                      labelText: 'ملاحظات المدير',
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    if (widget.workleavesModel != null)
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildApprovalChip(context, "رئيس القسم",
                              widget.workleavesModel!.dep_head_approve),
                          _buildApprovalChip(context, "الموارد البشرية",
                              widget.workleavesModel!.hr_approve),
                          _buildApprovalChip(context, "المدير",
                              widget.workleavesModel!.manager_approve),
                        ],
                      ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.workleavesModel == null)
                          Mybutton(
                            text: 'إضافة',
                            onPressed: _submitForm,
                          ),
                        if (widget.workleavesModel != null)
                          if (widget.workleavesModel!.progress == 0)
                            Mybutton(
                              text: 'تعديل',
                              onPressed: _submitForm,
                            ),
                        if (groups != null &&
                            (!groups.contains('HR_manager') ||
                                groups.contains('admins')))
                          if (widget.workleavesModel != null)
                            if (widget.workleavesModel!.progress == 0 ||
                                widget.workleavesModel!.progress == 1)
                              Mybutton(
                                text: 'توقيع رئيس القسم',
                                onPressed: () {
                                  _showApprovalDialog('توقيع رئيس القسم');
                                },
                              ),
                        if (groups != null &&
                            (groups.contains('HR_manager') ||
                                groups.contains('admins')))
                          if (widget.workleavesModel != null)
                            if (widget.workleavesModel!.progress == 1 ||
                                widget.workleavesModel!.progress == 2)
                              Mybutton(
                                text: 'توقيع الموارد البشرية',
                                onPressed: () {
                                  _showApprovalDialog('توقيع الموارد البشرية');
                                },
                              ),
                        if (groups != null &&
                            (groups.contains('managers') ||
                                groups.contains('admins')))
                          if (widget.workleavesModel != null)
                            if (widget.workleavesModel!.progress == 2 ||
                                widget.workleavesModel!.progress == 3)
                              Mybutton(
                                text: 'توقيع المدير',
                                onPressed: () {
                                  _showApprovalDialog('توقيع المدير');
                                },
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

  Widget _buildApprovalChip(
      BuildContext context, String label, bool? approved) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    late Color color;
    late String text;

    if (approved == true) {
      color = Colors.green.shade600;
      text = "✔ $label";
    } else if (approved == false) {
      color = Colors.red.shade600;
      text = "✖ $label";
    } else {
      color = isDark ? Colors.grey.shade700 : Colors.grey.shade400;
      text = "- $label";
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }
}
