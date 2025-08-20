import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'dart:ui' as ui;

import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Services/maintenance_services.dart';
import 'package:gmcappclean/features/maintenance/UI/maintenance_list_page.dart';
import 'package:gmcappclean/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class FullMaintanceDetailsPage extends StatefulWidget {
  final int status;
  final MaintenanceModel maintenanceModel;
  final bool? log;
  const FullMaintanceDetailsPage(
      {super.key,
      required this.maintenanceModel,
      required this.status,
      this.log});

  @override
  State<FullMaintanceDetailsPage> createState() =>
      _FullMaintanceDetailsPageState();
}

class _FullMaintanceDetailsPageState extends State<FullMaintanceDetailsPage> {
  MaintenanceModel? maintenanceModel;
  final _iDController = TextEditingController();
  final _applicantController = TextEditingController();
  final _insertDateController = TextEditingController();
  final _departmentController = TextEditingController();
  final _reasonController = TextEditingController();
  final _problemController = TextEditingController();
  bool? _selectedApproved;
  final _managerNotesController = TextEditingController();
  final _managerCheckDateController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _workerController = TextEditingController();
  final _workDoneController = TextEditingController();
  final _recievedNotesController = TextEditingController();
  final _recievedDateController = TextEditingController();
  final _machineNameController = TextEditingController();
  final _machineCodeController = TextEditingController();
  bool _isReceived = false;
  bool _isArchived = false;

  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  // final TransformationController _transformationController =
  //     TransformationController();
  @override
  void initState() {
    maintenanceModel = widget.maintenanceModel;

    _departmentController.text = maintenanceModel?.department ?? '';
    _iDController.text = maintenanceModel?.id.toString() ?? '';
    _applicantController.text = maintenanceModel?.applicant ?? '';
    _insertDateController.text = maintenanceModel?.insert_date ?? '';
    _problemController.text = maintenanceModel?.problem ?? '';
    _departmentController.text = maintenanceModel?.department ?? '';
    _reasonController.text = maintenanceModel?.reason ?? '';
    _startDateController.text = maintenanceModel?.start_date ?? '';
    _endDateController.text = maintenanceModel?.end_date ?? '';
    _workerController.text = maintenanceModel?.worker ?? '';
    _workDoneController.text = maintenanceModel?.work_done ?? '';
    _recievedDateController.text = maintenanceModel?.received_date ?? '';
    _machineNameController.text = maintenanceModel?.machine_name ?? '';
    _machineCodeController.text = maintenanceModel?.machine_code ?? '';
    _managerCheckDateController.text =
        maintenanceModel?.manager_check_date ?? '';
    _managerNotesController.text = maintenanceModel?.manager_notes ?? '';

    _selectedApproved = maintenanceModel?.manager_check;
    _recievedNotesController.text = maintenanceModel?.received_notes ?? '';
    if (maintenanceModel?.received == true) {
      _isReceived = true;
    } else {
      _isReceived = false;
    }
    if (maintenanceModel?.archived == true) {
      _isArchived = true;
    } else {
      _isArchived = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    _iDController.dispose();
    _applicantController.dispose();
    _insertDateController.dispose();
    _departmentController.dispose();
    _reasonController.dispose();
    _problemController.dispose();
    _managerNotesController.dispose();
    _managerCheckDateController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _workerController.dispose();
    _recievedNotesController.dispose();
    _recievedDateController.dispose();
    _machineNameController.dispose();
    _machineCodeController.dispose();
    //_transformationController.dispose();

    super.dispose();
  }

  List<String>? groups;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppUserState state = context.read<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    String name = '';
    if (state is AppUserLoggedIn) {
      name = state.userEntity.firstName ?? '';
    }
    return BlocProvider(
      create: (context) => MaintenanceBloc(
        MaintenanceServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: BlocConsumer<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceError) {
            showSnackBar(
              context: context,
              content: 'حدث خطأ ما',
              failure: true,
            );
          } else if (state is MaintenanceSuccess<MaintenanceModel>) {
            showSnackBar(
              context: context,
              content: 'تم الحفظ',
              failure: false,
            );

            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MaintenanceListPage(
                  status: widget.status,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MaintenanceLoading) {
            return const Scaffold(
              body: Center(
                child: Loader(),
              ),
            );
          } else if (maintenanceModel != null) {
            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor:
                      isDark ? AppColors.gradient2 : AppColors.lightGradient2,
                  title: Row(
                    spacing: 10,
                    children: [
                      Text(
                        'طلب الصيانة رقم ${maintenanceModel?.id ?? ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const FaIcon(
                        FontAwesomeIcons.screwdriverWrench,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 8),
                            child: Card(
                              elevation: 5,
                              color: isDark
                                  ? const Color.fromRGBO(70, 70, 85, 1)
                                  : Colors.green.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'معلومات الطلب',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                        readOnly: true,
                                        controller: _departmentController,
                                        labelText: 'القسم'),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: MyTextField(
                                              readOnly: true,
                                              controller: _applicantController,
                                              labelText: 'مقدم الطلب'),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: MyTextField(
                                              readOnly: true,
                                              controller: _insertDateController,
                                              labelText: 'تاريخ الإدراج'),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: MyTextField(
                                              readOnly: true,
                                              controller:
                                                  _machineNameController,
                                              labelText: 'اسم المكنة'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: MyTextField(
                                              readOnly: true,
                                              controller:
                                                  _machineCodeController,
                                              labelText: 'الرمز'),
                                        ),
                                      ],
                                    ),
                                    MyTextField(
                                        maxLines: 10,
                                        controller: _reasonController,
                                        labelText: 'سبب العطل'),
                                    MyTextField(
                                        maxLines: 10,
                                        controller: _problemController,
                                        labelText: 'العطل'),
                                    if (widget.status != 100)
                                      if (widget.log != true &&
                                          groups != null &&
                                          groups!.contains('admins'))
                                        Mybutton(
                                          text: 'تعديل طلب الصيانة',
                                          onPressed: () {
                                            _fillRequestModelfromForm();
                                            context.read<MaintenanceBloc>().add(
                                                  UpdateMaintenance(
                                                      id: widget
                                                          .maintenanceModel.id,
                                                      maintenanceModel:
                                                          maintenanceModel!),
                                                );
                                          },
                                        )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          color: isDark
                              ? const Color.fromRGBO(70, 70, 85, 1)
                              : Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'قسم المدير',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RadioListTile<bool?>(
                                  value: null,
                                  groupValue: _selectedApproved,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedApproved = value;
                                      _managerCheckDateController.clear();
                                    });
                                  },
                                  title: const Text('التوقيع غير محدد'),
                                ),
                                RadioListTile<bool?>(
                                  value: true,
                                  groupValue: _selectedApproved,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedApproved = value;
                                      _managerCheckDateController.text =
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.now()); // Update date
                                    });
                                  },
                                  title: const Text('موافق'),
                                ),
                                RadioListTile<bool?>(
                                  value: false,
                                  groupValue: _selectedApproved,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedApproved = value;
                                      _managerCheckDateController.text =
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.now()); // Update date
                                    });
                                  },
                                  title: const Text('مرفوض'),
                                ),
                                MyTextField(
                                  controller: _managerCheckDateController,
                                  labelText: 'تاريخ الموافقة',
                                  readOnly: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyTextField(
                                    maxLines: 10,
                                    controller: _managerNotesController,
                                    labelText: 'ملاحظة المدير'),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (widget.status != 100)
                                  if (widget.log != true &&
                                      groups != null &&
                                      groups!.contains('admins'))
                                    Center(
                                      child: Mybutton(
                                        onPressed: () {
                                          _fillManagerModelfromForm();
                                          context.read<MaintenanceBloc>().add(
                                                UpdateMaintenance(
                                                    id: widget
                                                        .maintenanceModel.id,
                                                    maintenanceModel:
                                                        maintenanceModel!),
                                              );
                                        },
                                        text: 'حفظ توقيع المدير',
                                      ),
                                    )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          color: isDark
                              ? const Color.fromRGBO(70, 70, 85, 1)
                              : Colors.green.shade50,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 10,
                              children: [
                                const Text(
                                  'قسم الصيانة',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  spacing: 5,
                                  children: [
                                    Expanded(
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _startDateController,
                                        labelText: 'تاريخ البدء',
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
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
                                    Expanded(
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _endDateController,
                                        labelText: 'تاريخ الانتهاء',
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );

                                          if (pickedDate != null) {
                                            setState(() {
                                              _endDateController.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                MyTextField(
                                    maxLines: 10,
                                    controller: _workDoneController,
                                    labelText: 'العمل المنجز'),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: MyTextField(
                                          maxLines: 10,
                                          controller: _workerController,
                                          labelText: 'الموظف'),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: CheckboxListTile(
                                        value: _isArchived,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isArchived = value ?? false;
                                          });
                                        },
                                        title: const Text(
                                          'أرشفة',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    )
                                  ],
                                ),
                                if (widget.status != 100)
                                  if (widget.log != true &&
                                      groups != null &&
                                      (groups!.contains(
                                              'maintenance_managers') ||
                                          groups!.contains('admins')))
                                    Center(
                                      child: Mybutton(
                                          onPressed: () {
                                            _fillMaintenanceModelfromForm();
                                            context.read<MaintenanceBloc>().add(
                                                  UpdateMaintenance(
                                                      id: widget
                                                          .maintenanceModel.id,
                                                      maintenanceModel:
                                                          maintenanceModel!),
                                                );
                                          },
                                          text: 'حفظ ملاحظات الصيانة'),
                                    )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          color: isDark
                              ? const Color.fromRGBO(70, 70, 85, 1)
                              : Colors.green.shade50,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'قسم الاستلام',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CheckboxListTile(
                                  value: _isReceived,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isReceived = value ?? false;
                                      if (_isReceived) {
                                        _recievedDateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now());
                                      } else {
                                        _recievedDateController.text = "";
                                      }
                                    });
                                  },
                                  title: const Text('استلام'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                MyTextField(
                                    readOnly: true,
                                    controller: _recievedDateController,
                                    labelText: 'تاريخ الاستلام'),
                                MyTextField(
                                    maxLines: 10,
                                    controller: _recievedNotesController,
                                    labelText: 'ملاحظة الاستلام'),
                                if (widget.status != 100)
                                  if (widget.log != true &&
                                      (name == _applicantController.text ||
                                          (groups != null &&
                                              groups!.contains('admins'))) &&
                                      (widget.log == null ||
                                          widget.log == false))
                                    Center(
                                      child: Mybutton(
                                        onPressed: () {
                                          _fillRecieveModelfromForm();
                                          context.read<MaintenanceBloc>().add(
                                                UpdateMaintenance(
                                                  id: widget
                                                      .maintenanceModel.id,
                                                  maintenanceModel:
                                                      maintenanceModel!,
                                                ),
                                              );
                                        },
                                        text: 'حفظ الاستلام',
                                      ),
                                    )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentPageIndex,
                  onTap: (int index) {
                    setState(() {
                      _currentPageIndex = index;
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  selectedItemColor: Colors.teal, // Color for selected item
                  unselectedItemColor:
                      Colors.grey, // Color for unselected items
                  backgroundColor: Colors.white, // Background color for the bar
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.info_outline),
                      label: 'معلومات',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.verified_user),
                      label: 'المدير',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.handyman),
                      label: 'الصيانة',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.recommend_outlined),
                      label: 'الاستلام',
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _fillMaintenanceModelfromForm() {
    maintenanceModel!.start_date = _startDateController.text;
    maintenanceModel!.end_date = _endDateController.text;
    maintenanceModel!.work_done = _workDoneController.text;
    maintenanceModel!.worker = _workerController.text;
    maintenanceModel!.archived = _isArchived;
  }

  void _fillManagerModelfromForm() {
    maintenanceModel!.manager_check = _selectedApproved;
    maintenanceModel!.manager_check_date =
        _managerCheckDateController.text.isEmpty
            ? null
            : _managerCheckDateController.text;

    maintenanceModel!.manager_notes = _managerNotesController.text;
  }

  void _fillRecieveModelfromForm() {
    maintenanceModel!.received = _isReceived;
    maintenanceModel!.received_date = _recievedDateController.text.isEmpty
        ? null
        : _recievedDateController.text;
    maintenanceModel!.received_notes = _recievedNotesController.text;
  }

  void _fillRequestModelfromForm() {
    maintenanceModel!.problem = _problemController.text;
    maintenanceModel!.reason = _reasonController.text;
  }
}
