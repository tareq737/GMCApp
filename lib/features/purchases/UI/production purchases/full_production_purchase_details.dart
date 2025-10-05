// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gmcappclean/core/common/api/api.dart';
// import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
// import 'package:gmcappclean/core/common/widgets/loader.dart';
// import 'package:gmcappclean/core/common/widgets/mybutton.dart';
// import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
// import 'package:gmcappclean/core/services/auth_interactor.dart';
// import 'package:gmcappclean/core/theme/app_colors.dart';
// import 'package:gmcappclean/core/utils/show_snackbar.dart';
// import 'package:gmcappclean/features/purchases/Bloc/purchase_bloc.dart';
// import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
// import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
// import 'package:gmcappclean/features/purchases/UI/general%20purchases/view_image_page.dart';
// import 'package:gmcappclean/features/purchases/UI/production%20purchases/production_purchases_list.dart';
// import 'package:gmcappclean/init_dependencies.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart';
// import 'dart:ui' as ui;

// import 'package:path_provider/path_provider.dart';

// class FullProductionPurchaseDetails extends StatefulWidget {
//   final PurchasesModel purchasesModel;
//   final int status;
//   const FullProductionPurchaseDetails({
//     super.key,
//     required this.purchasesModel,
//     required this.status,
//   });

//   @override
//   State<FullProductionPurchaseDetails> createState() =>
//       _FullProductionPurchaseDetailsState();
// }

// class _FullProductionPurchaseDetailsState
//     extends State<FullProductionPurchaseDetails> {
//   PurchasesModel? purchasesModel;
//   final _iDController = TextEditingController();
//   final _sectionController = TextEditingController();
//   final _applicantController = TextEditingController();
//   final _insertDateController = TextEditingController();
//   final _typeController = TextEditingController();
//   final _detailsController = TextEditingController();
//   final _heightController = TextEditingController();
//   final _widthController = TextEditingController();
//   final _lengthController = TextEditingController();
//   final _colorController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _usageController = TextEditingController();
//   final _warehouseBalanceController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _unitController = TextEditingController();
//   final _requiredDateController = TextEditingController();
//   final _supplierController = TextEditingController();
//   final _lastPurchaseController = TextEditingController();
//   final _purchaseNotesController = TextEditingController();
//   final _managerCheckDateController = TextEditingController();
//   final _managerNotesController = TextEditingController();
//   final _realSupplierController = TextEditingController();
//   final _buyerController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _purchaseDateController = TextEditingController();
//   final _receivedCheckDateController = TextEditingController();
//   final _recreceivedCheckNotesController = TextEditingController();
//   bool? _selectedApproved;
//   bool _isReceived = false;
//   bool _isArchived = false;
//   int? _purchaseHandler;

//   int _currentPageIndex = 0;
//   final PageController _pageController = PageController();
//   final TransformationController _transformationController =
//       TransformationController();
//   @override
//   void initState() {
//     purchasesModel = widget.purchasesModel;

//     _sectionController.text = purchasesModel?.department ?? '';
//     _iDController.text = purchasesModel?.id?.toString() ?? '';
//     _applicantController.text = purchasesModel?.applicant ?? '';
//     _insertDateController.text = purchasesModel?.insert_date ?? '';
//     _typeController.text = purchasesModel?.type ?? '';
//     _detailsController.text = purchasesModel?.details ?? '';
//     _heightController.text = purchasesModel?.height ?? '';
//     _widthController.text = purchasesModel?.width ?? '';
//     _lengthController.text = purchasesModel?.length ?? '';
//     _colorController.text = purchasesModel?.color ?? '';
//     _countryController.text = purchasesModel?.country ?? '';
//     _usageController.text = purchasesModel?.usage ?? '';
//     _warehouseBalanceController.text = purchasesModel?.warehouse_balance ?? '';
//     _quantityController.text = (purchasesModel?.quantity ?? 0.0).toString();
//     _unitController.text = purchasesModel?.unit ?? '';
//     _requiredDateController.text = purchasesModel?.required_date ?? '';
//     _supplierController.text = purchasesModel?.supplier ?? '';
//     _lastPurchaseController.text = purchasesModel?.last_purchased ?? '';
//     _purchaseNotesController.text = purchasesModel?.purchase_notes ?? '';
//     _managerCheckDateController.text = purchasesModel?.manager_check_date ?? '';
//     _managerNotesController.text = purchasesModel?.manager_notes ?? '';
//     _realSupplierController.text = purchasesModel?.real_supplier ?? '';
//     _buyerController.text = purchasesModel?.buyer ?? '';
//     _purchaseDateController.text = purchasesModel?.purchase_date ?? '';
//     _receivedCheckDateController.text =
//         purchasesModel?.received_check_date ?? '';
//     _selectedApproved = purchasesModel?.manager_check;
//     _recreceivedCheckNotesController.text =
//         purchasesModel?.received_check_notes ?? '';
//     if (purchasesModel?.received_check == true) {
//       _isReceived = true;
//     } else {
//       _isReceived = false;
//     }
//     if (purchasesModel?.archived == true) {
//       _isArchived = true;
//     } else {
//       _isArchived = false;
//     }
//     _purchaseHandler = purchasesModel?.purchase_handler;
//     _priceController.text = purchasesModel?.price ?? '';

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _iDController.dispose();
//     _sectionController.dispose();
//     _applicantController.dispose();
//     _insertDateController.dispose();
//     _typeController.dispose();
//     _detailsController.dispose();
//     _heightController.dispose();
//     _widthController.dispose();
//     _lengthController.dispose();
//     _colorController.dispose();
//     _countryController.dispose();
//     _usageController.dispose();
//     _warehouseBalanceController.dispose();
//     _quantityController.dispose();
//     _unitController.dispose();
//     _requiredDateController.dispose();
//     _supplierController.dispose();
//     _lastPurchaseController.dispose();
//     _purchaseNotesController.dispose();
//     _managerCheckDateController.dispose();
//     _managerNotesController.dispose();
//     _realSupplierController.dispose();
//     _buyerController.dispose();
//     _purchaseDateController.dispose();
//     _receivedCheckDateController.dispose();
//     _recreceivedCheckNotesController.dispose();
//     _pageController.dispose();
//     _transformationController.dispose();
//     _priceController.dispose();
//     super.dispose();
//   }

//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       File? compressedImage = await _compressImage(File(pickedFile.path));
//       setState(() {
//         _image = compressedImage;
//       });
//     }
//   }

//   Future<File?> _compressImage(File file) async {
//     // Skip compression on Windows
//     if (Platform.isWindows) {
//       return file; // Return the original file without compression
//     }

//     // Proceed with compression for other platforms (Android, iOS, etc.)
//     final directory = await getTemporaryDirectory();
//     final targetPath =
//         '${directory.path}/${basename(file.path)}_compressed.jpg';

//     var result = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       targetPath,
//       quality: 50,
//     );

//     return result != null ? File(result.path) : null;
//   }

//   List<String>? groups;
//   bool imageLoaded = false;
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = Theme.of(context).brightness == Brightness.dark;
//     AppUserState state = context.read<AppUserCubit>().state;

//     if (state is AppUserLoggedIn) {
//       groups = state.userEntity.groups;
//     }
//     String name = '';
//     if (state is AppUserLoggedIn) {
//       name = state.userEntity.firstName ?? '';
//     }
//     return BlocProvider(
//       create: (context) => PurchaseBloc(
//         PurchaseService(
//           apiClient: getIt<ApiClient>(),
//           authInteractor: getIt<AuthInteractor>(),
//         ),
//       ),
//       child: BlocConsumer<PurchaseBloc, PurchaseState>(
//         listener: (context, state) {
//           if (state is PurchaseError) {
//             showSnackBar(
//               context: context,
//               content: 'حدث خطأ ما',
//               failure: true,
//             );
//           } else if (state is PurchaseSuccess<PurchasesModel>) {
//             showSnackBar(
//               context: context,
//               content: 'تم الحفظ',
//               failure: false,
//             );
//             Navigator.pop(context);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProductionPurchasesList(
//                   status: widget.status,
//                 ),
//               ),
//             );
//           } else if (state is PurchaseImageSuccess) {
//             showSnackBar(
//               context: context,
//               content: 'تم حفظ الفاتورة',
//               failure: false,
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is PurchaseLoading) {
//             return const Scaffold(
//               body: Center(
//                 child: Loader(),
//               ),
//             );
//           } else if (purchasesModel != null) {
//             return Directionality(
//               textDirection: ui.TextDirection.rtl,
//               child: Scaffold(
//                 appBar: AppBar(
//                   backgroundColor:
//                       isDark ? AppColors.gradient2 : AppColors.lightGradient2,
//                   title: Row(
//                     spacing: 10,
//                     children: [
//                       Text(
//                         'طلب مشتريات إنتاج رقم ${purchasesModel?.id ?? ''}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                       const FaIcon(
//                         FontAwesomeIcons.shopify,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//                 body: PageView(
//                   controller: _pageController,
//                   onPageChanged: (index) {
//                     setState(() {
//                       _currentPageIndex = index;
//                     });
//                   },
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         spacing: 5,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 8, right: 8, top: 8),
//                             child: Card(
//                               elevation: 5,
//                               color: isDark
//                                   ? const Color.fromRGBO(70, 70, 85, 1)
//                                   : Colors.green.shade50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   spacing: 10,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       'معلومات الطلب',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Row(
//                                       spacing: 5,
//                                       children: [
//                                         Expanded(
//                                           flex: 7,
//                                           child: MyTextField(
//                                               readOnly: true,
//                                               controller: _sectionController,
//                                               labelText: 'القسم'),
//                                         ),
//                                         Expanded(
//                                           flex: 3,
//                                           child: MyTextField(
//                                               readOnly: true,
//                                               controller: _iDController,
//                                               labelText: 'الرقم'),
//                                         ),
//                                       ],
//                                     ),
//                                     MyTextField(
//                                         readOnly: true,
//                                         controller: _applicantController,
//                                         labelText: 'مقدم الطلب'),
//                                     Row(
//                                       spacing: 5,
//                                       children: [
//                                         Expanded(
//                                           child: MyTextField(
//                                               readOnly: true,
//                                               controller: _insertDateController,
//                                               labelText: 'تاريخ الإدراج'),
//                                         ),
//                                         Expanded(
//                                           child: MyTextField(
//                                             readOnly: true,
//                                             controller: _requiredDateController,
//                                             labelText: 'تاريخ التوريد المطلوب',
//                                             onTap: () async {
//                                               DateTime? pickedDate =
//                                                   await showDatePicker(
//                                                 context: context,
//                                                 initialDate: DateTime.now(),
//                                                 firstDate: DateTime(2000),
//                                                 lastDate: DateTime(2100),
//                                               );

//                                               if (pickedDate != null) {
//                                                 setState(() {
//                                                   _requiredDateController.text =
//                                                       DateFormat('yyyy-MM-dd')
//                                                           .format(pickedDate);
//                                                 });
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     MyTextField(
//                                         maxLines: 10,
//                                         controller: _typeController,
//                                         labelText: 'الصنف'),
//                                     MyTextField(
//                                         maxLines: 10,
//                                         controller: _usageController,
//                                         labelText: 'الاستعمال وتوصيف الحالة'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Card(
//                               elevation: 5,
//                               color: isDark
//                                   ? const Color.fromRGBO(70, 70, 85, 1)
//                                   : Colors.blue.shade50,
//                               margin: const EdgeInsets.only(bottom: 16),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   spacing: 10,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       'الأبعاد والمواصفات',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     MyTextField(
//                                         maxLines: 10,
//                                         controller: _detailsController,
//                                         labelText: 'المواصفات الفنية'),
//                                     Row(
//                                       spacing: 5,
//                                       children: [
//                                         Expanded(
//                                           child: MyTextField(
//                                               controller: _lengthController,
//                                               labelText: 'الطول'),
//                                         ),
//                                         Expanded(
//                                           child: MyTextField(
//                                               controller: _widthController,
//                                               labelText: 'العرض'),
//                                         ),
//                                         Expanded(
//                                           child: MyTextField(
//                                               controller: _heightController,
//                                               labelText: 'الارتفاع'),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       spacing: 5,
//                                       children: [
//                                         Expanded(
//                                           child: MyTextField(
//                                               controller: _colorController,
//                                               labelText: 'اللون'),
//                                         ),
//                                         Expanded(
//                                           child: MyTextField(
//                                               controller: _countryController,
//                                               labelText: 'بلد المنشأ'),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       spacing: 5,
//                                       children: [
//                                         Expanded(
//                                           flex: 3,
//                                           child: MyTextField(
//                                               controller:
//                                                   _warehouseBalanceController,
//                                               labelText: 'رصيد المستودع'),
//                                         ),
//                                         Expanded(
//                                             flex: 2,
//                                             child: MyTextField(
//                                               keyboardType: const TextInputType
//                                                   .numberWithOptions(
//                                                   decimal:
//                                                       true), // Allows decimal input
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .allow(RegExp(
//                                                         r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
//                                               ],
//                                               controller: _quantityController,
//                                               labelText: 'الكمية',
//                                             )),
//                                         Expanded(
//                                           flex: 3,
//                                           child: MyTextField(
//                                               controller: _unitController,
//                                               labelText: 'الوحدة'),
//                                         ),
//                                       ],
//                                     ),
//                                     MyTextField(
//                                         maxLines: 10,
//                                         controller: _supplierController,
//                                         labelText: 'اسم المورد'),
//                                     if ((groups != null &&
//                                             groups!.contains('admins')) ||
//                                         (_applicantController.text == name &&
//                                             (purchasesModel?.manager_check !=
//                                                 true)))
//                                       Mybutton(
//                                         text: 'تعديل طلب المشتريات',
//                                         onPressed: () {
//                                           _fillRequestModelfromForm();
//                                           context.read<PurchaseBloc>().add(
//                                                 UpdatePurchases(
//                                                   id: widget.purchasesModel.id!,
//                                                   purchaseModel:
//                                                       purchasesModel!,
//                                                 ),
//                                               );
//                                         },
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Card(
//                           elevation: 5,
//                           color: isDark
//                               ? const Color.fromRGBO(70, 70, 85, 1)
//                               : Colors.green.shade50,
//                           margin: const EdgeInsets.only(bottom: 16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               spacing: 10,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 BlocBuilder<PurchaseBloc, PurchaseState>(
//                                   builder: (context, state) {
//                                     if (state is PurchaseImageLoading) {
//                                       return const Loader();
//                                     } else if (state
//                                         is PurchaseSuccess<Uint8List>) {
//                                       // Navigate to new page after the current frame
//                                       WidgetsBinding.instance
//                                           .addPostFrameCallback((_) {
//                                         // Navigate first
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ViewImagePage(
//                                                 imageData: state.result),
//                                           ),
//                                         ).then((_) {
//                                           // After navigation completes, reset the state
//                                           context
//                                               .read<PurchaseBloc>()
//                                               .add(ResetPurchaseState());
//                                         });
//                                       });
//                                       return const SizedBox();
//                                     } else if (state is PurchaseError) {
//                                       return Text(
//                                         state.errorMessage,
//                                         style:
//                                             const TextStyle(color: Colors.red),
//                                       );
//                                     } else {
//                                       return const SizedBox();
//                                     }
//                                   },
//                                 ),
//                                 const Text(
//                                   'قسم المشتريات',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 MyTextField(
//                                   readOnly: true,
//                                   controller: _lastPurchaseController,
//                                   labelText: 'تاريخ آخر شراء',
//                                   onTap: () async {
//                                     DateTime? pickedDate = await showDatePicker(
//                                       context: context,
//                                       initialDate: DateTime.now(),
//                                       firstDate: DateTime(2000),
//                                       lastDate: DateTime(2100),
//                                     );

//                                     if (pickedDate != null) {
//                                       setState(() {
//                                         _lastPurchaseController.text =
//                                             DateFormat('yyyy-MM-dd')
//                                                 .format(pickedDate);
//                                       });
//                                     }
//                                   },
//                                 ),
//                                 MyTextField(
//                                     maxLines: 10,
//                                     controller: _purchaseNotesController,
//                                     labelText: 'ملاحظات'),
//                                 MyTextField(
//                                     maxLines: 10,
//                                     controller: _realSupplierController,
//                                     labelText: 'المورد الفعلي'),
//                                 Row(
//                                   spacing: 5,
//                                   children: [
//                                     Expanded(
//                                       child: MyTextField(
//                                         readOnly: true,
//                                         controller: _purchaseDateController,
//                                         labelText: 'تاريخ الشراء',
//                                         onTap: () async {
//                                           DateTime? pickedDate =
//                                               await showDatePicker(
//                                             context: context,
//                                             initialDate: DateTime.now(),
//                                             firstDate: DateTime(2000),
//                                             lastDate: DateTime(2100),
//                                           );

//                                           if (pickedDate != null) {
//                                             setState(() {
//                                               _purchaseDateController.text =
//                                                   DateFormat('yyyy-MM-dd')
//                                                       .format(pickedDate);
//                                             });
//                                           }
//                                         },
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: MyTextField(
//                                           controller: _buyerController,
//                                           labelText: 'القائم بالشراء'),
//                                     ),
//                                   ],
//                                 ),
//                                 if (groups != null &&
//                                     (groups!.contains('purchase_admins') ||
//                                         groups!.contains('managers') ||
//                                         groups!.contains('admins')))
//                                   MyTextField(
//                                       controller: _priceController,
//                                       labelText: 'سعر الشراء'),
//                                 CheckboxListTile(
//                                   value: _isArchived,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       _isArchived = value ?? false;
//                                     });
//                                   },
//                                   title: const Text('أرشفة'),
//                                   controlAffinity:
//                                       ListTileControlAffinity.leading,
//                                 ),
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//                                 if (groups != null &&
//                                         groups!.contains('purchase_admins') ||
//                                     groups!.contains('admins'))
//                                   Mybutton(
//                                     onPressed: () {
//                                       _fillPurchacesModelfromForm();
//                                       context.read<PurchaseBloc>().add(
//                                             UpdatePurchases(
//                                               id: widget.purchasesModel.id!,
//                                               purchaseModel: purchasesModel!,
//                                             ),
//                                           );
//                                     },
//                                     text: 'حفظ ملاحظات المشتريات',
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Card(
//                           elevation: 5,
//                           color: isDark
//                               ? const Color.fromRGBO(70, 70, 85, 1)
//                               : Colors.green.shade50,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   'قسم المدير',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 RadioListTile<bool?>(
//                                   value: null,
//                                   groupValue: _selectedApproved,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedApproved = value;
//                                       _managerCheckDateController.clear();
//                                     });
//                                   },
//                                   title: const Text('التوقيع غير محدد'),
//                                 ),
//                                 RadioListTile<bool?>(
//                                   value: true,
//                                   groupValue: _selectedApproved,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedApproved = value;
//                                       _managerCheckDateController.text =
//                                           DateFormat('yyyy-MM-dd').format(
//                                               DateTime.now()); // Update date
//                                     });
//                                   },
//                                   title: const Text('موافق'),
//                                 ),
//                                 RadioListTile<bool?>(
//                                   value: false,
//                                   groupValue: _selectedApproved,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedApproved = value;
//                                       _managerCheckDateController.text =
//                                           DateFormat('yyyy-MM-dd').format(
//                                               DateTime.now()); // Update date
//                                     });
//                                   },
//                                   title: const Text('مرفوض'),
//                                 ),
//                                 MyTextField(
//                                   controller: _managerCheckDateController,
//                                   labelText: 'تاريخ الموافقة',
//                                   readOnly: true,
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 MyTextField(
//                                     maxLines: 10,
//                                     controller: _managerNotesController,
//                                     labelText: 'ملاحظة المدير'),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 const Text(
//                                   'المسؤول عن الشراء',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 RadioListTile<int?>(
//                                   value: null,
//                                   groupValue: _purchaseHandler,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _purchaseHandler = value;
//                                     });
//                                   },
//                                   title: const Text('غير محدد'),
//                                 ),
//                                 RadioListTile<int?>(
//                                   value: 1,
//                                   groupValue: _purchaseHandler,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _purchaseHandler = value;
//                                     });
//                                   },
//                                   title: const Text('المدير'),
//                                 ),
//                                 RadioListTile<int?>(
//                                   value: 2,
//                                   groupValue: _purchaseHandler,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _purchaseHandler = value;
//                                     });
//                                   },
//                                   title: const Text('مسؤول المشتريات'),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 if (name == 'محمد حسام عبيد' ||
//                                     groups != null &&
//                                         groups!.contains('admins'))
//                                   Center(
//                                     child: Mybutton(
//                                       onPressed: () {
//                                         _fillManagerModelfromForm();
//                                         context.read<PurchaseBloc>().add(
//                                               UpdatePurchases(
//                                                   id: widget.purchasesModel.id!,
//                                                   purchaseModel:
//                                                       purchasesModel!),
//                                             );
//                                       },
//                                       text: 'حفظ توقيع المدير',
//                                     ),
//                                   )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Card(
//                           elevation: 5,
//                           color: isDark
//                               ? const Color.fromRGBO(70, 70, 85, 1)
//                               : Colors.green.shade50,
//                           margin: const EdgeInsets.only(bottom: 16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               spacing: 10,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   'قسم الاستلام',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 CheckboxListTile(
//                                   value: _isReceived,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       _isReceived = value ?? false;
//                                       if (_isReceived) {
//                                         _receivedCheckDateController.text =
//                                             DateFormat('yyyy-MM-dd')
//                                                 .format(DateTime.now());
//                                       } else {
//                                         _receivedCheckDateController.text = "";
//                                       }
//                                     });
//                                   },
//                                   title: const Text('استلام'),
//                                   controlAffinity:
//                                       ListTileControlAffinity.leading,
//                                 ),
//                                 MyTextField(
//                                     readOnly: true,
//                                     controller: _receivedCheckDateController,
//                                     labelText: 'تاريخ الاستلام'),
//                                 MyTextField(
//                                     maxLines: 10,
//                                     controller:
//                                         _recreceivedCheckNotesController,
//                                     labelText: 'ملاحظة الاستلام'),
//                                 if (name == _applicantController.text ||
//                                     groups != null &&
//                                         groups!.contains('admins'))
//                                   Center(
//                                     child: Mybutton(
//                                         onPressed: () {
//                                           _fillRecieveModelfromForm();
//                                           context.read<PurchaseBloc>().add(
//                                                 UpdatePurchases(
//                                                     id: widget
//                                                         .purchasesModel.id!,
//                                                     purchaseModel:
//                                                         purchasesModel!),
//                                               );
//                                         },
//                                         text: 'حفظ الاستلام'),
//                                   )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (groups != null &&
//                         (groups!.contains('purchase_admins') ||
//                             groups!.contains('managers') ||
//                             groups!.contains('admins')))
//                       Center(
//                         child: Column(
//                           spacing: 10,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             BlocBuilder<PurchaseBloc, PurchaseState>(
//                               builder: (context, state) {
//                                 if (state is PurchaseImageLoading) {
//                                   return const Loader();
//                                 } else if (state
//                                     is PurchaseSuccess<Uint8List>) {
//                                   // Navigate to new page after the current frame
//                                   WidgetsBinding.instance
//                                       .addPostFrameCallback((_) {
//                                     // Navigate first
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ViewImagePage(
//                                             imageData: state.result),
//                                       ),
//                                     ).then((_) {
//                                       // After navigation completes, reset the state
//                                       context
//                                           .read<PurchaseBloc>()
//                                           .add(ResetPurchaseState());
//                                     });
//                                   });
//                                   return const SizedBox();
//                                 } else if (state is PurchaseError) {
//                                   return Text(
//                                     state.errorMessage,
//                                     style: const TextStyle(color: Colors.red),
//                                   );
//                                 } else {
//                                   return const SizedBox();
//                                 }
//                               },
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 if (widget.purchasesModel.bill != null &&
//                                     widget.purchasesModel.bill!.isNotEmpty)
//                                   Mybutton(
//                                     text: 'عرض الفاتورة',
//                                     onPressed: () {
//                                       context.read<PurchaseBloc>().add(
//                                             GetPurchaseImage(
//                                                 id: widget.purchasesModel.id!),
//                                           );
//                                     },
//                                   ),
//                                 if (widget.status != 100)
//                                   if (widget.purchasesModel.bill != null &&
//                                       widget.purchasesModel.bill!.isNotEmpty)
//                                     Mybutton(
//                                       text: 'حذف الفاتورة',
//                                       onPressed: () async {
//                                         // Show a confirmation dialog
//                                         bool confirmDelete = await showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               title: const Text('تأكيد الحذف'),
//                                               content: const Text(
//                                                   'هل أنت متأكد أنك تريد حذف هذه الفاتورة؟'),
//                                               actions: [
//                                                 TextButton(
//                                                   child: const Text('إلغاء'),
//                                                   onPressed: () {
//                                                     Navigator.of(context)
//                                                         .pop(false);
//                                                   },
//                                                 ),
//                                                 TextButton(
//                                                   child: const Text('حذف'),
//                                                   onPressed: () {
//                                                     Navigator.of(context)
//                                                         .pop(true);
//                                                   },
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                         if (confirmDelete == true) {
//                                           context.read<PurchaseBloc>().add(
//                                                 DeletePurchaceImage(
//                                                     id: widget
//                                                         .purchasesModel.id!),
//                                               );
//                                         }
//                                       },
//                                     ),
//                                 if (widget.status != 100)
//                                   if ((widget.purchasesModel.bill == null ||
//                                           widget.purchasesModel.bill == "") &&
//                                       Platform.isAndroid)
//                                     Mybutton(
//                                       text: 'تصوير الفاتورة',
//                                       onPressed: () async {
//                                         await _pickImage(ImageSource.camera);
//                                         if (_image != null) {
//                                           context.read<PurchaseBloc>().add(
//                                               AddPurchaseImage(
//                                                   image: _image!,
//                                                   id: widget
//                                                       .purchasesModel.id!));
//                                         }
//                                       },
//                                     ),
//                                 if (widget.status != 100)
//                                   if (widget.purchasesModel.bill == null &&
//                                       widget.purchasesModel.bill != "")
//                                     Mybutton(
//                                       text: 'اختيار الفاتورة',
//                                       onPressed: () async {
//                                         await _pickImage(ImageSource.gallery);
//                                         if (_image != null) {
//                                           context.read<PurchaseBloc>().add(
//                                               AddPurchaseImage(
//                                                   image: _image!,
//                                                   id: widget
//                                                       .purchasesModel.id!));
//                                         }
//                                       },
//                                     ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             )
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//                 bottomNavigationBar: BottomNavigationBar(
//                   currentIndex: _currentPageIndex,
//                   onTap: (int index) {
//                     setState(() {
//                       _currentPageIndex = index;
//                       _pageController.animateToPage(
//                         index,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );
//                     });
//                   },
//                   selectedItemColor: Colors.teal, // Color for selected item
//                   unselectedItemColor:
//                       Colors.grey, // Color for unselected items
//                   backgroundColor: Colors.white, // Background color for the bar
//                   items: [
//                     const BottomNavigationBarItem(
//                       icon: Icon(Icons.info_outline),
//                       label: 'معلومات',
//                     ),
//                     const BottomNavigationBarItem(
//                       icon: Icon(Icons.shopping_cart_checkout),
//                       label: 'المشتريات',
//                     ),
//                     const BottomNavigationBarItem(
//                       icon: Icon(Icons.manage_accounts_outlined),
//                       label: 'المدير',
//                     ),
//                     const BottomNavigationBarItem(
//                       icon: Icon(Icons.recommend_outlined),
//                       label: 'الاستلام',
//                     ),
//                     if (groups != null &&
//                         (groups!.contains('purchase_admins') ||
//                             groups!.contains('managers') ||
//                             groups!.contains('admins')))
//                       const BottomNavigationBarItem(
//                         icon: Icon(Icons.receipt),
//                         label: 'الفاتورة',
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   void _fillPurchacesModelfromForm() {
//     purchasesModel!.last_purchased = _lastPurchaseController.text.isEmpty
//         ? null
//         : _lastPurchaseController.text;
//     purchasesModel!.purchase_notes = _purchaseNotesController.text;
//     purchasesModel!.purchase_date = _purchaseDateController.text.isEmpty
//         ? null
//         : _purchaseDateController.text;
//     purchasesModel!.real_supplier = _realSupplierController.text;
//     purchasesModel!.buyer = _buyerController.text;
//     purchasesModel!.price = _priceController.text;
//     purchasesModel!.archived = _isArchived;
//   }

//   void _fillManagerModelfromForm() {
//     purchasesModel!.manager_check = _selectedApproved;
//     purchasesModel!.manager_check_date =
//         _managerCheckDateController.text.isEmpty
//             ? null
//             : _managerCheckDateController.text;

//     purchasesModel!.manager_notes = _managerNotesController.text;
//     purchasesModel!.purchase_handler = _purchaseHandler;
//   }

//   void _fillRecieveModelfromForm() {
//     purchasesModel!.received_check = _isReceived;
//     purchasesModel!.received_check_date =
//         _receivedCheckDateController.text.isEmpty
//             ? null
//             : _receivedCheckDateController.text;
//     purchasesModel!.received_check_notes =
//         _recreceivedCheckNotesController.text;
//   }

//   void _fillRequestModelfromForm() {
//     purchasesModel!.type = _typeController.text;
//     purchasesModel!.usage = _usageController.text;
//     purchasesModel!.details = _detailsController.text;
//     purchasesModel!.width = _widthController.text;
//     purchasesModel!.length = _lengthController.text;
//     purchasesModel!.height = _heightController.text;
//     purchasesModel!.color = _colorController.text;
//     purchasesModel!.country = _countryController.text;
//     purchasesModel!.warehouse_balance = _warehouseBalanceController.text;
//     purchasesModel!.quantity = double.tryParse(_quantityController.text);
//     purchasesModel!.unit = _unitController.text;
//     purchasesModel!.supplier = _supplierController.text;
//   }
// }
