import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart'; // Assuming MyDropdownButton is here
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Services/maintenance_services.dart';
import 'package:gmcappclean/features/maintenance/UI/maintenance_list_page.dart';
import 'package:gmcappclean/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class AddMaintenancePage extends StatefulWidget {
  const AddMaintenancePage({super.key});

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  Map<String, List<Map<String, dynamic>>> departmentToMachinesMap = {};
  List<String> departmentList = [];
  List<Map<String, dynamic>> machinesList = [];

  final _applicantController = TextEditingController();
  final _departmentController = TextEditingController();
  Map<String, dynamic>? _selectedMachine; // store selected machine object
  final _reasonController = TextEditingController();
  final _problemController = TextEditingController();
  final _insertDateController = TextEditingController();
  final _recommendedFixController = TextEditingController();

  // FIX: Add a key to force rebuild the machine dropdown when department changes
  Key _machineDropdownKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _applicantController.text = userState.userEntity.firstName ?? '';
    }
    _insertDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _departmentController.dispose();
    _applicantController.dispose();
    _insertDateController.dispose();
    _reasonController.dispose();
    _problemController.dispose();
    _recommendedFixController.dispose();
    super.dispose();
  }

  bool _validateForm(BuildContext context) {
    if (_departmentController.text.trim().isEmpty) {
      _showError(context, 'الرجاء اختيار القسم');
      return false;
    }
    if (_selectedMachine == null) {
      _showError(context, 'الرجاء اختيار الآلة');
      return false;
    }
    if (_applicantController.text.trim().isEmpty) {
      _showError(context, 'الرجاء إدخال اسم مقدم الطلب');
      return false;
    }
    if (_insertDateController.text.trim().isEmpty) {
      _showError(context, 'الرجاء إدخال تاريخ الطلب');
      return false;
    }
    if (_reasonController.text.trim().isEmpty) {
      _showError(context, 'الرجاء إدخال سبب العطل');
      return false;
    }
    if (_problemController.text.trim().isEmpty) {
      _showError(context, 'الرجاء إدخال تفاصيل المشكلة');
      return false;
    }
    if (_recommendedFixController.text.trim().isEmpty) {
      _showError(context, 'الرجاء إدخال التوصية المقترحة للإصلاح');
      return false;
    }
    return true;
  }

  void _showError(BuildContext context, String message) {
    showSnackBar(context: context, content: message, failure: true);
  }

  MaintenanceModel _fillRequestModelfromForm() {
    return MaintenanceModel(
      department: _departmentController.text,
      machine: _selectedMachine?['id'],
      applicant: _applicantController.text,
      insert_date: _insertDateController.text,
      reason: _reasonController.text,
      problem: _problemController.text,
      recommended_fix: _recommendedFixController.text,
      id: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserLoggedIn) {
          _applicantController.text = state.userEntity.firstName ?? '';
        }
      },
      child: BlocProvider(
        create: (context) => MaintenanceBloc(
          MaintenanceServices(
            apiClient: getIt<ApiClient>(),
            authInteractor: getIt<AuthInteractor>(),
          ),
        )..add(GetAllMachines()),
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('طلب صيانة جديد'),
            ),
            body: BlocConsumer<MaintenanceBloc, MaintenanceState>(
              listener: (context, state) {
                if (state is MaintenanceSuccess) {
                  showSnackBar(
                    context: context,
                    content: 'تمت إضافة طلب الصيانة بنجاح',
                    failure: false,
                  );
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MaintenanceListPage(status: 7),
                    ),
                  );
                } else if (state is MaintenanceError) {
                  showSnackBar(
                    context: context,
                    content: state.errorMessage,
                    failure: true,
                  );
                }
              },
              builder: (context, state) {
                if (state is MaintenanceLoading) {
                  return const Center(child: Loader());
                }

                if (state is MachinesLoaded) {
                  departmentToMachinesMap = state.machines?.machines ??
                      <String, List<Map<String, dynamic>>>{};
                  departmentList = departmentToMachinesMap.keys.toList();
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'معلومات الطلب',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _applicantController,
                                labelText: 'مقدم الطلب',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _insertDateController,
                                labelText: 'تاريخ الإدراج',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        MyDropdownButton(
                          value: _departmentController.text.isEmpty
                              ? null
                              : _departmentController.text,
                          items: departmentList
                              .map((dep) => DropdownMenuItem(
                                    value: dep,
                                    child: Text(dep),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _departmentController.text = newValue ?? '';
                              machinesList = List<Map<String, dynamic>>.from(
                                  departmentToMachinesMap[newValue] ?? []);
                              _selectedMachine = null;
                              // FIX: Reset the key to force MyDropdownButton to rebuild for machines
                              _machineDropdownKey = UniqueKey();
                            });
                          },
                          labelText: 'القسم',
                        ),
                        const SizedBox(height: 16),
                        MyDropdownButton(
                          key: _machineDropdownKey, // FIX: Apply the key here
                          value: _selectedMachine == null
                              ? null
                              : _selectedMachine!['name'] as String?,
                          items: machinesList
                              .map<DropdownMenuItem<String>>(
                                  (mac) => DropdownMenuItem<String>(
                                        value: mac['name'] as String,
                                        child: Text(mac['name'] as String),
                                      ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedMachine = machinesList.firstWhere(
                                (m) => m['name'] == newValue,
                                orElse: () => {},
                              );
                            });
                          },
                          labelText: 'المكنة',
                        ),
                        const SizedBox(height: 16),
                        MyTextField(
                          controller: _reasonController,
                          labelText: 'سبب العطل',
                        ),
                        const SizedBox(height: 16),
                        MyTextField(
                          controller: _problemController,
                          labelText: 'العطل',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        MyTextField(
                          controller: _recommendedFixController,
                          labelText: 'الحل المقترح من القسم',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
                            builder: (context, state) {
                              if (state is MaintenanceLoading) {
                                return const Loader();
                              }
                              return Mybutton(
                                text: 'إدراج',
                                onPressed: () {
                                  if (_validateForm(context)) {
                                    final model = _fillRequestModelfromForm();
                                    context.read<MaintenanceBloc>().add(
                                          AddMaintenance(
                                            maintenanceModel: model,
                                          ),
                                        );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
