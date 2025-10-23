import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/Pages/view_image_page.dart';
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
import 'package:gmcappclean/features/production_management/production/models/brief_production_model.dart';
import 'package:gmcappclean/features/purchases/Bloc/purchase_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/brief_purchase_model.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
import 'package:gmcappclean/features/purchases/UI/general purchases/full_purchase_details.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  BriefPurchaseModel? _selectedPurchase;
  MaintenanceModel? maintenanceModel;
  final _iDController = TextEditingController();
  final _applicantController = TextEditingController();
  final _insertDateController = TextEditingController();
  final _departmentController = TextEditingController();
  final _reasonController = TextEditingController();
  final _problemController = TextEditingController();
  final _recommendedFixController = TextEditingController();
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
  final _causeOfIssueController = TextEditingController();
  final _maintenanceRequiredDateController = TextEditingController();
  bool _isReceived = false;
  bool _isArchived = false;
  bool _isMaintenanceReceiveChecked = false;
  bool _purchaseOrderStatus = false;

  int? _purchase_order;
  String? _selectedHandler;
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  // We use this flag to distinguish the purchase link update from other updates
  bool _isPurchaseLinkUpdate = false;

  // The BuildContext is passed explicitly to this method to ensure it's the one
  // from the widget tree that includes the MaintenanceBloc provider.
  void _savePurchaseLink(
      BuildContext context, BriefPurchaseModel selectedPurchase) {
    setState(() {
      _isPurchaseLinkUpdate = true;
      _selectedPurchase = selectedPurchase;
      _purchase_order = selectedPurchase.id;
      maintenanceModel!.purchase_order = _purchase_order;
    });

    // Dispatch the update event using the provided context
    context.read<MaintenanceBloc>().add(
          UpdateMaintenance(
            id: widget.maintenanceModel.id,
            maintenanceModel: maintenanceModel!,
          ),
        );
  }

  // The BuildContext is passed explicitly to this method to ensure it's the one
  // from the widget tree that includes the MaintenanceBloc provider.
  void _unlinkPurchase(BuildContext context) {
    setState(() {
      _selectedPurchase = null;
      _purchase_order = null;
      maintenanceModel!.purchase_order = null;
      _isPurchaseLinkUpdate = true;
    });

    // Dispatch the update event using the provided context
    context.read<MaintenanceBloc>().add(
          UpdateMaintenance(
            id: widget.maintenanceModel.id,
            maintenanceModel: maintenanceModel!,
          ),
        );
  }

  // Updated to accept BuildContext
  Future<void> _showPurcahsesSearchDialog(BuildContext parentContext) async {
    final selectedPurchase = await showDialog<BriefPurchaseModel>(
      context: parentContext, // Use the context that has the providers
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('بحث عن طلب شراء'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                body: BlocProvider(
                  create: (context) => PurchaseBloc(
                    PurchaseService(
                      apiClient: getIt<ApiClient>(),
                      authInteractor: getIt<AuthInteractor>(),
                    ),
                  )..add(SearchPurchases(page: 1, search: '')),
                  child: const _ProductionSearchDialogContent(),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (selectedPurchase != null) {
      // Use the parentContext (which contains the MaintenanceBloc) for saving.
      if (!mounted) return;
      _savePurchaseLink(parentContext, selectedPurchase);
    }
  }

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

  String name = '';
  List<String>? groups;
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
    _recommendedFixController.text = maintenanceModel?.recommended_fix ?? '';
    _selectedHandler = maintenanceModel?.maintained_by;
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
    _causeOfIssueController.text = maintenanceModel?.cause_of_issue ?? '';
    _maintenanceRequiredDateController.text =
        maintenanceModel?.maintenance_required_date ?? '';
    _selectedApproved = maintenanceModel?.manager_check;
    _recievedNotesController.text = maintenanceModel?.received_notes ?? '';
    _purchase_order = maintenanceModel?.purchase_order;
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
    if (maintenanceModel?.purchase_order_status == true) {
      _purchaseOrderStatus = true;
    } else {
      _purchaseOrderStatus = false;
    }

    if (maintenanceModel?.maintenance_receive_check == true) {
      _isMaintenanceReceiveChecked = true;
    } else {
      _isMaintenanceReceiveChecked = false;
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
    _recommendedFixController.dispose();
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
    _causeOfIssueController.dispose();
    _maintenanceRequiredDateController.dispose();
    _workDoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppUserState state = context.read<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }

    if (state is AppUserLoggedIn) {
      name = state.userEntity.firstName ?? '';
    }

    // --- START: BlocProvider setup ---
    // The MultiBlocProvider is placed here to make sure its context (and thus the BLoCs)
    // is available to the rest of the widget tree below it.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MaintenanceBloc(
            MaintenanceServices(
              apiClient: getIt<ApiClient>(),
              authInteractor: getIt<AuthInteractor>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => PurchaseBloc(PurchaseService(
            apiClient: getIt<ApiClient>(),
            authInteractor: getIt<AuthInteractor>(),
          )),
        ),
      ],
      // The Builder is necessary to get a new context that is *under* the providers
      child: Builder(
        builder: (context) {
          return BlocConsumer<MaintenanceBloc, MaintenanceState>(
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

                if (_isPurchaseLinkUpdate) {
                  _isPurchaseLinkUpdate = false;

                  maintenanceModel = state.result;
                } else {
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
              } else if (state is MaintenanceSuccess<Uint8List>) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewImagePage(imageData: state.result),
                    ),
                  );
                });
              } else if (state is MaintenanceSuccess<bool>) {
                showSnackBar(
                  context: context,
                  content: 'تم حذف الفاتورة',
                  failure: false,
                );
              } else if (state is ImageSavedSuccess) {
                showSnackBar(
                  context: context,
                  content: 'تم حفظ الفاتورة',
                  failure: false,
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
                return BlocListener<PurchaseBloc, PurchaseState>(
                  listener: (context, state) {
                    if (state is PurchaseSuccess<PurchasesModel>) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FullPurchaseDetails(
                              purchasesModel: state.result,
                              status: 6,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: isDark
                            ? AppColors.gradient2
                            : AppColors.lightGradient2,
                        title: Row(
                          // Removed spacing: 10 as Row doesn't have it
                          children: [
                            Text(
                              'طلب الصيانة رقم / ${maintenanceModel?.id ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Added SizedBox for spacing
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
                          _buildRequestSection(context),
                          _buildManagerAndPurchaseSection(context),
                          _buildMaintenanceSection(context),
                          _buildReceiveSection(context),
                          _buildBillSection(context),
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
                        selectedItemColor: Colors.teal,
                        unselectedItemColor: Colors.grey,
                        backgroundColor: Colors.white,
                        items: const [
                          BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.circleInfo),
                            label: 'معلومات',
                          ),
                          BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.userCheck),
                            label: 'المدير',
                          ),
                          BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.screwdriverWrench),
                            label: 'الصيانة',
                          ),
                          BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.checkToSlot),
                            label: 'الاستلام',
                          ),
                          BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.receipt),
                            label: 'الفاتورة',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  // Extracted request section into a method for cleaner code
  Widget _buildRequestSection(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        spacing: 5,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
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
                        const SizedBox(width: 10), // Added SizedBox for spacing
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
                      // Removed spacing: 5 as Row doesn't have it
                      children: [
                        Expanded(
                          flex: 7,
                          child: MyTextField(
                              readOnly: true,
                              controller: _machineNameController,
                              labelText: 'اسم المكنة'),
                        ),
                        const SizedBox(width: 5), // Added SizedBox for spacing
                        Expanded(
                          flex: 2,
                          child: MyTextField(
                              readOnly: true,
                              controller: _machineCodeController,
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
                    MyTextField(
                      maxLines: 10,
                      controller: _recommendedFixController,
                      labelText: 'الحل المقترح من القسم',
                    ),
                    if (widget.status != 100)
                      if (widget.log != true &&
                              groups != null &&
                              groups!.contains('admins') ||
                          (_applicantController.text == name &&
                              _selectedApproved != true &&
                              _isArchived != true))
                        Mybutton(
                          text: 'تعديل طلب الصيانة',
                          onPressed: () {
                            _fillRequestModelfromForm();
                            context.read<MaintenanceBloc>().add(
                                  UpdateMaintenance(
                                      id: widget.maintenanceModel.id,
                                      maintenanceModel: maintenanceModel!),
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
    );
  }

  // Extracted manager and purchase section into a method for cleaner code
  Widget _buildManagerAndPurchaseSection(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
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
                              DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()); // Update date
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
                              DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()); // Update date
                        });
                      },
                      title: const Text('مرفوض'),
                    ),
                    MyTextField(
                      controller: _managerCheckDateController,
                      labelText: 'تاريخ الموافقة',
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                        maxLines: 10,
                        controller: _managerNotesController,
                        labelText: 'ملاحظة المدير'),
                    const SizedBox(height: 10),
                    if (widget.status != 100)
                      if (widget.log != true &&
                              groups != null &&
                              groups!.contains('managers') ||
                          groups!.contains('admins'))
                        Center(
                          child: Mybutton(
                            onPressed: () {
                              _fillManagerModelfromForm();
                              context.read<MaintenanceBloc>().add(
                                    UpdateMaintenance(
                                        id: widget.maintenanceModel.id,
                                        maintenanceModel: maintenanceModel!),
                                  );
                            },
                            text: 'حفظ توقيع المدير',
                          ),
                        )
                  ],
                ),
              ),
            ),
            Card(
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
                      'قسم المشتريات',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _purchase_order == null
                        ? IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              // ignore: curly_braces_in_flow_control_structures
                              if (groups != null &&
                                  (groups!.contains('maintenance_managers') ||
                                      groups!.contains('admins'))) {
                                _showPurcahsesSearchDialog(context);
                              } else {
                                showSnackBar(
                                    context: context,
                                    content: 'ليس لديك صلاحية مناسبة',
                                    failure: true);
                              }
                            },
                          )
                        : BlocBuilder<PurchaseBloc, PurchaseState>(
                            builder: (context, productionState) {
                              if (productionState is PurchaseLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Loader(),
                                  ),
                                );
                              }
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Mybutton(
                                        onPressed: () {
                                          context.read<PurchaseBloc>().add(
                                                GetOnePurchase(
                                                  id: _purchase_order!,
                                                ),
                                              );
                                        },
                                        text:
                                            'طلب شراء #${_purchase_order!.toString()} - حالة طلب الشراء: ${_purchaseOrderStatus ? 'موافق' : 'غير موافق'}'),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.errorColor,
                                    ),
                                    onPressed: () {
                                      if (groups != null &&
                                          (groups!.contains(
                                                  'maintenance_managers') ||
                                              groups!.contains('admins'))) {
                                        _unlinkPurchase(context);
                                      } else {
                                        showSnackBar(
                                            context: context,
                                            content: 'ليس لديك صلاحية مناسبة',
                                            failure: true);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted maintenance section into a method for cleaner code
  Widget _buildMaintenanceSection(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'قسم الصيانة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  '      من يتولى الإصلاح:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                RadioListTile<String>(
                  title: const Text('رئيس القسم'),
                  value: 'رئيس القسم',
                  groupValue: _selectedHandler,
                  onChanged: (value) {
                    setState(() {
                      _selectedHandler = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('قسم الصيانة'),
                  value: 'قسم الصيانة',
                  groupValue: _selectedHandler,
                  onChanged: (value) {
                    setState(() {
                      _selectedHandler = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('ورشة خارجية'),
                  value: 'ورشة خارجية',
                  groupValue: _selectedHandler,
                  onChanged: (value) {
                    setState(() {
                      _selectedHandler = value;
                    });
                  },
                ),
                MyTextField(
                  readOnly: true,
                  controller: _maintenanceRequiredDateController,
                  labelText: 'التاريخ المحدد للتنفيذ',
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _maintenanceRequiredDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
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
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _startDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 5), // Added SizedBox for spacing
                    Expanded(
                      child: MyTextField(
                        readOnly: true,
                        controller: _endDateController,
                        labelText: 'تاريخ الانتهاء',
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _endDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
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
                MyTextField(
                    maxLines: 10,
                    controller: _causeOfIssueController,
                    labelText: 'الحالة التي أدى إليها العطل'),
                MyTextField(
                    maxLines: 10,
                    controller: _workerController,
                    labelText: 'الموظف'),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: CheckboxListTile(
                        value: _isMaintenanceReceiveChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isMaintenanceReceiveChecked = value ?? false;
                          });
                        },
                        title: const Text(
                          'استلام الصيانة',
                          style: TextStyle(fontSize: 12),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
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
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    )
                  ],
                ),
                if (widget.status != 100)
                  if (widget.log != true &&
                      groups != null &&
                      (groups!.contains('maintenance_managers') ||
                          groups!.contains('admins')))
                    Center(
                      child: Mybutton(
                          onPressed: () {
                            _fillMaintenanceModelfromForm();
                            context.read<MaintenanceBloc>().add(
                                  UpdateMaintenance(
                                      id: widget.maintenanceModel.id,
                                      maintenanceModel: maintenanceModel!),
                                );
                          },
                          text: 'حفظ ملاحظات الصيانة'),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Extracted receive section into a method for cleaner code
  Widget _buildReceiveSection(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                CheckboxListTile(
                  value: _isReceived,
                  onChanged: (bool? value) {
                    setState(() {
                      _isReceived = value ?? false;
                      if (_isReceived) {
                        _recievedDateController.text =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                      } else {
                        _recievedDateController.text = "";
                      }
                    });
                  },
                  title: const Text('استلام'),
                  controlAffinity: ListTileControlAffinity.leading,
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
                          (groups != null && groups!.contains('admins'))) &&
                      (widget.log == null || widget.log == false))
                    Center(
                      child: Mybutton(
                        onPressed: () {
                          _fillRecieveModelfromForm();
                          context.read<MaintenanceBloc>().add(
                                UpdateMaintenance(
                                  id: widget.maintenanceModel.id,
                                  maintenanceModel: maintenanceModel!,
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
    );
  }

  Widget _buildBillSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.maintenanceModel.maintenance_bill != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                    tooltip: 'عرض الفاتورة',
                    onPressed: () {
                      context.read<MaintenanceBloc>().add(
                            GetBillImage(id: widget.maintenanceModel.id),
                          );
                    },
                  ),
                  const Text('عرض الفاتورة', style: TextStyle(fontSize: 12)),
                  const SizedBox(
                      width: 20), // Add spacing between the two actions
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'حذف الفاتورة',
                    onPressed: () {
                      _confirmDelete(context, () {
                        context.read<MaintenanceBloc>().add(
                              DeleteBillImage(id: widget.maintenanceModel.id),
                            );
                      });
                    },
                  ),
                  const Text('حذف الفاتورة', style: TextStyle(fontSize: 12)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (Platform.isAndroid)
                    Column(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.green),
                          tooltip: 'تصوير الفاتورة',
                          onPressed: () async {
                            await _pickBillImage(ImageSource.camera);
                            if (_billImage != null) {
                              context.read<MaintenanceBloc>().add(AddBillImage(
                                  image: _billImage!,
                                  id: widget.maintenanceModel.id));
                            }
                          },
                        ),
                        const Text('تصوير الفاتورة',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library,
                            color: Colors.orange),
                        tooltip: 'اختيار الفاتورة',
                        onPressed: () async {
                          await _pickBillImage(ImageSource.gallery);
                          if (_billImage != null) {
                            context.read<MaintenanceBloc>().add(AddBillImage(
                                image: _billImage!,
                                id: widget.maintenanceModel.id));
                          }
                        },
                      ),
                      const Text('اختيار الفاتورة',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
      ],
    );
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
                  Text('هل أنت متأكد من رغبتك في حذف الفاتورة'),
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

  void _fillMaintenanceModelfromForm() {
    maintenanceModel!.start_date =
        _startDateController.text.isEmpty ? null : _startDateController.text;
    maintenanceModel!.end_date =
        _endDateController.text.isEmpty ? null : _endDateController.text;
    maintenanceModel!.work_done = _workDoneController.text;
    maintenanceModel!.worker = _workerController.text;
    maintenanceModel!.archived = _isArchived;
    maintenanceModel!.maintenance_receive_check = _isMaintenanceReceiveChecked;
    maintenanceModel!.maintenance_required_date =
        _maintenanceRequiredDateController.text.isEmpty
            ? null
            : _maintenanceRequiredDateController.text;
    maintenanceModel!.cause_of_issue = _causeOfIssueController.text;
    maintenanceModel!.maintained_by = _selectedHandler;
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
    maintenanceModel!.recommended_fix = _recommendedFixController.text;
    maintenanceModel!.maintained_by = _selectedHandler;
    maintenanceModel!.machine_name = _machineNameController.text;
    maintenanceModel!.machine_code = _machineCodeController.text;
  }
}

class _ProductionSearchDialogContent extends StatefulWidget {
  const _ProductionSearchDialogContent();

  @override
  State<_ProductionSearchDialogContent> createState() =>
      _ProductionSearchDialogContentState();
}

class _ProductionSearchDialogContentState
    extends State<_ProductionSearchDialogContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;
  List<BriefPurchaseModel> resultList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _nextPage();
    }
  }

  void _nextPage() {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;
    context.read<PurchaseBloc>().add(
          SearchPurchases(page: currentPage, search: _searchController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'بحث',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    resultList.clear();
                    currentPage = 1;
                  });
                  context.read<PurchaseBloc>().add(
                        SearchPurchases(
                          page: 1,
                          search: _searchController.text,
                        ),
                      );
                },
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                resultList.clear();
                currentPage = 1;
              });
              context.read<PurchaseBloc>().add(
                    SearchPurchases(
                      page: 1,
                      search: value,
                    ),
                  );
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<PurchaseBloc, PurchaseState>(
            listener: (context, state) {
              if (state is PurchaseSuccess<List<BriefPurchaseModel>>) {
                if (currentPage == 1) {
                  resultList = state.result;
                } else {
                  resultList.addAll(state.result);
                }
                isLoadingMore = false;
              }
            },
            builder: (context, state) {
              if (state is PurchaseLoading && currentPage == 1) {
                return const Center(child: Loader());
              }

              if (resultList.isEmpty && state is! PurchaseLoading) {
                return const Center(
                  child: Text('لا يوجد نتائج'),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: resultList.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == resultList.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Loader()),
                    );
                  }

                  final item = resultList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 12,
                        child: Text(
                          item.id?.toString() ?? '0',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      title: Row(
                        // Removed spacing: 5 as Row doesn't have it
                        children: [
                          Text(
                            item.department ?? 'غير محدد',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Text(
                            ' - ', // Spacing added manually
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            item.insert_date ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.type ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            item.details ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
