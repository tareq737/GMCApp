// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:gmcappclean/core/common/api/api.dart';
// import 'package:gmcappclean/core/common/widgets/counter_row_widget.dart';
// import 'package:gmcappclean/core/common/widgets/loader.dart';
// import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
// import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
// import 'package:gmcappclean/core/common/widgets/search_row.dart';
// import 'package:gmcappclean/core/utils/show_snackbar.dart';
// import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
// import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
// import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
// import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
// import 'package:gmcappclean/features/sales_management/operations/models/call_model.dart';
// import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
// import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
// import 'package:gmcappclean/init_dependencies.dart';

// class NewCallPage extends StatefulWidget {
//   final OperationsModel? operationsModel;

//   const NewCallPage({
//     super.key,
//     this.operationsModel,
//   });

//   @override
//   State<NewCallPage> createState() => _NewCallPageState();
// }

// class _NewCallPageState extends State<NewCallPage> {
//   final _searchController = TextEditingController();
//   final _callDateController = TextEditingController();
//   final _summaryController = TextEditingController();
//   CustomerBriefViewModel? _selectedCustomer;

//   bool _isReset = false; // <--- NEW FLAG

//   int callDuration = 0;
//   String? processKind = "";
//   String? connectionType = "";
//   String? discussion = "";
//   String? salesRep = "";
//   bool? socialTalk = false;
//   bool? bill = false;
//   bool? complaints = false;

//   List responsible = [
//     'محمد العمر',
//     'أحمد الناصري',
//     'عبد الله عويد',
//     'هادي السهلي',
//     'عبد الله دياب',
//   ];
//   List processKindList = [
//     'دورية',
//     'طارئة',
//     'ودية',
//     'أول اتصال',
//   ];
//   List connectionTypeList = ['صادر', 'وارد'];
//   List discussionList = [
//     'حوار',
//     'حادة',
//     'ودية',
//     'عملية',
//     'مغلق',
//     'لا يرد',
//   ];

//   @override
//   void dispose() {
//     super.dispose();
//     _searchController.dispose();
//     _callDateController.dispose();
//     _summaryController.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.operationsModel != null) {
//       _callDateController.text = widget.operationsModel?.date ?? '';
//       callDuration = widget.operationsModel?.duration != null
//           ? int.tryParse(widget.operationsModel!.duration!) ?? 0
//           : 0;
//       connectionType = widget.operationsModel?.connection_type ?? '';
//       salesRep = widget.operationsModel?.sales_rep ?? '';
//       processKind = widget.operationsModel?.process_kind ?? '';
//       discussion = widget.operationsModel?.discussion ?? '';
//       socialTalk = widget.operationsModel?.social_talk ?? false;
//       bill = widget.operationsModel?.bill ?? false;
//       complaints = widget.operationsModel?.complaints ?? false;
//       _summaryController.text = widget.operationsModel?.summary ?? '';
//     }
//     if (widget.operationsModel == null) {
//       _callDateController.text =
//           DateFormat('yyyy-MM-dd').format(DateTime.now());
//     }
//   }

//   final CallModel _callModel = CallModel(
//     id: 0,
//     customer: 0,
//     duration: 0,
//     date: '',
//     process_kind: '',
//     connection_type: '',
//     discussion: '',
//     social_talk: false,
//     bill: false,
//     complaints: false,
//     summary: '',
//     sales_rep: '',
//   );

//   void _fillCallModelfromForm() {
//     _callModel.id = 0;
//     if (_selectedCustomer != null) {
//       _callModel.customer = _selectedCustomer!.id;
//     } else if (widget.operationsModel != null) {
//       _callModel.customer = widget.operationsModel!.customer;
//     }
//     _callModel.duration = callDuration;
//     _callModel.date = _callDateController.text;
//     _callModel.process_kind = processKind;
//     _callModel.connection_type = connectionType;
//     _callModel.discussion = discussion;
//     _callModel.social_talk = socialTalk;
//     _callModel.bill = bill;
//     _callModel.complaints = complaints;
//     _callModel.summary = _summaryController.text;
//     _callModel.sales_rep = salesRep;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => getIt<SalesBloc>()),
//         BlocProvider(
//           create: (context) => OperationsBloc(OperationsServices(
//               apiClient: getIt<ApiClient>(),
//               checkUserSessionStatus: getIt<CheckUserSessionStatus>())),
//         ),
//       ],
//       child: Builder(
//         builder: (context) {
//           return Directionality(
//             textDirection: ui.TextDirection.rtl,
//             child: Scaffold(
//               appBar: AppBar(
//                 title: Row(
//                   children: [
//                     Text(
//                       widget.operationsModel == null
//                           ? 'اتصال جديد'
//                           : 'معلومات الاتصال ${widget.operationsModel?.id ?? ''}',
//                     ),
//                     const SizedBox(width: 10),
//                     Icon(
//                       widget.operationsModel == null
//                           ? Icons.add_call
//                           : Icons.call,
//                     ),
//                   ],
//                 ),
//               ),
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: BlocConsumer<OperationsBloc, OperationsState>(
//                     listener: (context, state) {
//                       if (state is OperationsSuccess) {
//                         showSnackBar(
//                           context: context,
//                           content: widget.operationsModel == null
//                               ? 'تمت الإضافة بنجاح'
//                               : 'تم التعديل بنجاح',
//                           failure: false,
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const NewCallPage(),
//                           ),
//                         );
//                       } else if (state is OperationsError) {
//                         showSnackBar(
//                           context: context,
//                           content: 'حدث خطأ ما',
//                           failure: true,
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       if (state is OperationsLoading) {
//                         return const Center(child: Loader());
//                       } else {
//                         return Column(
//                           children: [
//                             // ---- FIXED LOGIC ----
//                             (_selectedCustomer == null &&
//                                     (widget.operationsModel == null ||
//                                         _isReset))
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text('يرجى اختيار زبون'),
//                                       SearchRow(
//                                         textEditingController:
//                                             _searchController,
//                                         onSearch: () {
//                                           _searchCustomer(context);
//                                         },
//                                       ),
//                                     ],
//                                   )
//                                 : Column(
//                                     children: [
//                                       Container(
//                                         width: double.infinity,
//                                         padding: const EdgeInsets.all(8.0),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                             color: Colors.grey.shade500,
//                                             width: 2.0,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(8.0),
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             const Text('اسم الزبون:'),
//                                             const SizedBox(height: 10),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 CircleAvatar(
//                                                   radius: 12,
//                                                   child: Text(
//                                                     _selectedCustomer == null
//                                                         ? widget
//                                                             .operationsModel!
//                                                             .customer
//                                                             .toString()
//                                                         : _selectedCustomer!.id
//                                                             .toString(),
//                                                     textAlign: TextAlign.center,
//                                                     style: const TextStyle(
//                                                         fontSize: 8),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 10),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       _selectedCustomer == null
//                                                           ? widget.operationsModel!
//                                                                   .customer_name ??
//                                                               ''
//                                                           : _selectedCustomer
//                                                                   ?.customerName ??
//                                                               '',
//                                                       style: const TextStyle(
//                                                           fontSize: 16),
//                                                     ),
//                                                     Text(
//                                                       _selectedCustomer == null
//                                                           ? widget.operationsModel!
//                                                                   .shop_name ??
//                                                               ''
//                                                           : _selectedCustomer
//                                                                   ?.shopName ??
//                                                               '',
//                                                       style: const TextStyle(
//                                                           fontSize: 16),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const SizedBox(width: 20),
//                                                 IconButton(
//                                                   icon: const Icon(
//                                                       Icons.change_circle,
//                                                       color: Colors.orange),
//                                                   tooltip: 'تغيير الزبون',
//                                                   onPressed: () {
//                                                     setState(() {
//                                                       _selectedCustomer = null;
//                                                       _searchController.clear();
//                                                       _isReset = true;
//                                                     });
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 10),
//                                       Row(
//                                         spacing: 5,
//                                         children: [
//                                           Expanded(
//                                             child: MyTextField(
//                                               readOnly: true,
//                                               controller: _callDateController,
//                                               labelText: 'تاريخ الاتصال',
//                                               onTap: () async {
//                                                 DateTime? pickedDate =
//                                                     await showDatePicker(
//                                                   context: context,
//                                                   initialDate: DateTime.now(),
//                                                   firstDate: DateTime(2000),
//                                                   lastDate: DateTime(2100),
//                                                 );
//                                                 if (pickedDate != null) {
//                                                   setState(() {
//                                                     _callDateController.text =
//                                                         DateFormat('yyyy-MM-dd')
//                                                             .format(pickedDate);
//                                                   });
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: CounterRow(
//                                               label: 'مدة الاتصال بالدقائق',
//                                               value: callDuration,
//                                               onIncrement: () {
//                                                 setState(() {
//                                                   callDuration += 1;
//                                                 });
//                                               },
//                                               onDecrement: () {
//                                                 if (callDuration > 0) {
//                                                   setState(() {
//                                                     callDuration -= 1;
//                                                   });
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 10),
//                                       MyDropdownButton(
//                                         value: connectionType,
//                                         items: connectionTypeList.map((type) {
//                                           return DropdownMenuItem<String>(
//                                             value: type,
//                                             child: Text(type),
//                                           );
//                                         }).toList(),
//                                         onChanged: (String? newValue) {
//                                           setState(() {
//                                             connectionType = newValue;
//                                           });
//                                         },
//                                         labelText: 'نوع بالاتصال',
//                                       ),
//                                       const SizedBox(height: 10),
//                                       MyDropdownButton(
//                                         value: salesRep,
//                                         items: responsible.map((type) {
//                                           return DropdownMenuItem<String>(
//                                             value: type,
//                                             child: Text(type),
//                                           );
//                                         }).toList(),
//                                         onChanged: (String? newValue) {
//                                           setState(() {
//                                             salesRep = newValue;
//                                           });
//                                         },
//                                         labelText: 'القائم بالاتصال',
//                                       ),
//                                       const SizedBox(height: 10),
//                                       Row(
//                                         spacing: 5,
//                                         children: [
//                                           Expanded(
//                                             child: MyDropdownButton(
//                                               value: processKind,
//                                               items:
//                                                   processKindList.map((type) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: type,
//                                                   child: Text(type),
//                                                 );
//                                               }).toList(),
//                                               onChanged: (String? newValue) {
//                                                 setState(() {
//                                                   processKind = newValue;
//                                                 });
//                                               },
//                                               labelText: 'طبيعة الاتصال',
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: MyDropdownButton(
//                                               value: discussion,
//                                               items: discussionList.map((type) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: type,
//                                                   child: Text(type),
//                                                 );
//                                               }).toList(),
//                                               onChanged: (String? newValue) {
//                                                 setState(() {
//                                                   discussion = newValue;
//                                                 });
//                                               },
//                                               labelText: 'طريقة النقاش',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 10),
//                                       if (discussion != 'مغلق' &&
//                                           discussion != 'لا يرد')
//                                         Container(
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: Colors.grey.shade500,
//                                               width: 2.0,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                           ),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               CheckboxListTile(
//                                                 title: const Text(
//                                                     'حديث اجتماعي',
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                         fontSize: 12)),
//                                                 value: socialTalk,
//                                                 onChanged: (bool? value) {
//                                                   setState(() {
//                                                     socialTalk = value ?? false;
//                                                   });
//                                                 },
//                                                 controlAffinity:
//                                                     ListTileControlAffinity
//                                                         .leading,
//                                               ),
//                                               CheckboxListTile(
//                                                 title: const Text(
//                                                     'تسجيل فاتورة',
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                         fontSize: 12)),
//                                                 value: bill,
//                                                 onChanged: (bool? value) {
//                                                   setState(() {
//                                                     bill = value ?? false;
//                                                   });
//                                                 },
//                                                 controlAffinity:
//                                                     ListTileControlAffinity
//                                                         .leading,
//                                               ),
//                                               CheckboxListTile(
//                                                 title: const Text('تسجيل شكوى',
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                         fontSize: 12)),
//                                                 value: complaints,
//                                                 onChanged: (bool? value) {
//                                                   setState(() {
//                                                     complaints = value ?? false;
//                                                   });
//                                                 },
//                                                 controlAffinity:
//                                                     ListTileControlAffinity
//                                                         .leading,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       const SizedBox(height: 10),
//                                       if (discussion != 'مغلق' &&
//                                           discussion != 'لا يرد')
//                                         MyTextField(
//                                             maxLines: 100,
//                                             controller: _summaryController,
//                                             labelText: 'الملخص'),
//                                       const SizedBox(height: 10),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: [
//                                           IconButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             icon: const Icon(Icons.arrow_back,
//                                                 color: Colors.white),
//                                             style: IconButton.styleFrom(
//                                               backgroundColor: Colors.red,
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                             ),
//                                           ),
//                                           IconButton(
//                                             onPressed: () {
//                                               _fillCallModelfromForm();
//                                               if (widget.operationsModel ==
//                                                   null) {
//                                                 context
//                                                     .read<OperationsBloc>()
//                                                     .add(AddNewCall(
//                                                         callModel: _callModel));
//                                               } else {
//                                                 context
//                                                     .read<OperationsBloc>()
//                                                     .add(EditCall(
//                                                         callModel: _callModel,
//                                                         id: widget
//                                                             .operationsModel!
//                                                             .id!));
//                                               }
//                                             },
//                                             icon: Icon(
//                                               widget.operationsModel == null
//                                                   ? Icons.add
//                                                   : Icons.edit,
//                                               color: Colors.white,
//                                             ),
//                                             style: IconButton.styleFrom(
//                                               backgroundColor:
//                                                   widget.operationsModel == null
//                                                       ? Colors.green
//                                                       : Colors.blue,
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                             BlocConsumer<SalesBloc, SalesState>(
//                               listener: (context, state) {
//                                 if (state is SalesOpFailure) {
//                                   showSnackBar(
//                                       context: context,
//                                       content: 'حدث خطأ ما',
//                                       failure: true);
//                                 } else if (state is SalesOpSuccess<
//                                     List<CustomerBriefViewModel>>) {
//                                   _showCustomerDialog(context, state.opResult);
//                                 }
//                               },
//                               builder: (context, state) {
//                                 if (state is SalesOpLoading) {
//                                   return const Center(child: Loader());
//                                 } else {
//                                   return Container();
//                                 }
//                               },
//                             ),
//                           ],
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _searchCustomer(BuildContext context) {
//     context.read<SalesBloc>().add(
//         SalesSearch<CustomerBriefViewModel>(lexum: _searchController.text));
//   }

//   void _showCustomerDialog(
//       BuildContext context, List<CustomerBriefViewModel> customers) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: AlertDialog(
//             title: Text(
//               'يرجى اختيار زبون',
//               style: TextStyle(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? Colors.white
//                     : Colors.black,
//               ),
//             ),
//             content: SizedBox(
//               width: double.maxFinite,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: customers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       radius: 10,
//                       child: Text(
//                         customers[index].id.toString(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     title: Column(
//                       children: [
//                         Text(customers[index].customerName ?? ''),
//                         Text(customers[index].shopName ?? ''),
//                       ],
//                     ),
//                     subtitle: Text(
//                       '${customers[index].governate ?? ''} - ${customers[index].region ?? ''}',
//                       textAlign: TextAlign.center,
//                     ),
//                     onTap: () {
//                       setState(() {
//                         _selectedCustomer = customers[index];
//                         _isReset = false; // hide search again
//                       });
//                       Navigator.of(context).pop();
//                     },
//                   );
//                 },
//               ),
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('إغلاق'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/counter_row_widget.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/pages/full_customer_data_page.dart'; // ADDED
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart'; // ADDED
import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/call_model.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:gmcappclean/init_dependencies.dart';

class NewCallPage extends StatefulWidget {
  final OperationsModel? operationsModel;

  const NewCallPage({
    super.key,
    this.operationsModel,
  });

  @override
  State<NewCallPage> createState() => _NewCallPageState();
}

class _NewCallPageState extends State<NewCallPage> {
  final _searchController = TextEditingController();
  final _callDateController = TextEditingController();
  final _summaryController = TextEditingController();
  CustomerBriefViewModel? _selectedCustomer;

  bool _isReset = false; // <--- NEW FLAG

  int callDuration = 0;
  String? processKind = "";
  String? connectionType = "";
  String? discussion = "";
  String? salesRep = "";
  bool? socialTalk = false;
  bool? bill = false;
  bool? complaints = false;

  List responsible = [
    'محمد العمر',
    'أحمد الناصري',
    'عبد الله عويد',
    'هادي السهلي',
    'عبد الله دياب',
  ];
  List processKindList = [
    'دورية',
    'طارئة',
    'ودية',
    'أول اتصال',
  ];
  List connectionTypeList = ['صادر', 'وارد'];
  List discussionList = [
    'حوار',
    'حادة',
    'ودية',
    'عملية',
    'مغلق',
    'لا يرد',
  ];

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _callDateController.dispose();
    _summaryController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.operationsModel != null) {
      _callDateController.text = widget.operationsModel?.date ?? '';
      callDuration = widget.operationsModel?.duration != null
          ? int.tryParse(widget.operationsModel!.duration!) ?? 0
          : 0;
      connectionType = widget.operationsModel?.connection_type ?? '';
      salesRep = widget.operationsModel?.sales_rep ?? '';
      processKind = widget.operationsModel?.process_kind ?? '';
      discussion = widget.operationsModel?.discussion ?? '';
      socialTalk = widget.operationsModel?.social_talk ?? false;
      bill = widget.operationsModel?.bill ?? false;
      complaints = widget.operationsModel?.complaints ?? false;
      _summaryController.text = widget.operationsModel?.summary ?? '';
    }
    if (widget.operationsModel == null) {
      _callDateController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  final CallModel _callModel = CallModel(
    id: 0,
    customer: 0,
    duration: 0,
    date: '',
    process_kind: '',
    connection_type: '',
    discussion: '',
    social_talk: false,
    bill: false,
    complaints: false,
    summary: '',
    sales_rep: '',
  );

  void _fillCallModelfromForm() {
    _callModel.id = 0;
    if (_selectedCustomer != null) {
      _callModel.customer = _selectedCustomer!.id;
    } else if (widget.operationsModel != null) {
      _callModel.customer = widget.operationsModel!.customer;
    }
    _callModel.duration = callDuration;
    _callModel.date = _callDateController.text;
    _callModel.process_kind = processKind;
    _callModel.connection_type = connectionType;
    _callModel.discussion = discussion;
    _callModel.social_talk = socialTalk;
    _callModel.bill = bill;
    _callModel.complaints = complaints;
    _callModel.summary = _summaryController.text;
    _callModel.sales_rep = salesRep;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SalesBloc>()),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
              apiClient: getIt<ApiClient>(),
              checkUserSessionStatus: getIt<CheckUserSessionStatus>())),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Text(
                      widget.operationsModel == null
                          ? 'اتصال جديد'
                          : 'معلومات الاتصال ${widget.operationsModel?.id ?? ''}',
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      widget.operationsModel == null
                          ? Icons.add_call
                          : Icons.call,
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocConsumer<OperationsBloc, OperationsState>(
                    listener: (context, state) {
                      if (state is OperationsSuccess) {
                        showSnackBar(
                          context: context,
                          content: widget.operationsModel == null
                              ? 'تمت الإضافة بنجاح'
                              : 'تم التعديل بنجاح',
                          failure: false,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewCallPage(),
                          ),
                        );
                      } else if (state is OperationsError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is OperationsLoading) {
                        return const Center(child: Loader());
                      } else {
                        return Column(
                          children: [
                            // ---- FIXED LOGIC ----
                            (_selectedCustomer == null &&
                                    (widget.operationsModel == null ||
                                        _isReset))
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('يرجى اختيار زبون'),
                                      SearchRow(
                                        textEditingController:
                                            _searchController,
                                        onSearch: () {
                                          _searchCustomer(context);
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      // START: Customer Info Widget wrapped with InkWell
                                      InkWell(
                                        onTap: () {
                                          int? customerId =
                                              _selectedCustomer != null
                                                  ? _selectedCustomer?.id
                                                  : widget.operationsModel
                                                      ?.customer;

                                          if (customerId != null &&
                                              customerId != 0) {
                                            context.read<SalesBloc>().add(
                                                  SalesGetById<
                                                          CustomerViewModel>(
                                                      id: customerId),
                                                );
                                          } else {
                                            showSnackBar(
                                              context: context,
                                              content:
                                                  'لم يتم تحديد زبون لعرض تفاصيله',
                                              failure: true,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('اسم الزبون:'),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 12,
                                                    child: Text(
                                                      _selectedCustomer == null
                                                          ? widget
                                                              .operationsModel!
                                                              .customer
                                                              .toString()
                                                          : _selectedCustomer!
                                                              .id
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 8),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        _selectedCustomer ==
                                                                null
                                                            ? widget.operationsModel!
                                                                    .customer_name ??
                                                                ''
                                                            : _selectedCustomer
                                                                    ?.customerName ??
                                                                '',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        _selectedCustomer ==
                                                                null
                                                            ? widget.operationsModel!
                                                                    .shop_name ??
                                                                ''
                                                            : _selectedCustomer
                                                                    ?.shopName ??
                                                                '',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 20),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.change_circle,
                                                        color: Colors.orange),
                                                    tooltip: 'تغيير الزبون',
                                                    onPressed: () {
                                                      setState(() {
                                                        _selectedCustomer =
                                                            null;
                                                        _searchController
                                                            .clear();
                                                        _isReset = true;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // END: Customer Info Widget with InkWell
                                      const SizedBox(height: 10),
                                      Row(
                                        spacing: 5,
                                        children: [
                                          Expanded(
                                            child: MyTextField(
                                              readOnly: true,
                                              controller: _callDateController,
                                              labelText: 'تاريخ الاتصال',
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
                                                    _callDateController.text =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: CounterRow(
                                              label: 'مدة الاتصال بالدقائق',
                                              value: callDuration,
                                              onIncrement: () {
                                                setState(() {
                                                  callDuration += 1;
                                                });
                                              },
                                              onDecrement: () {
                                                if (callDuration > 0) {
                                                  setState(() {
                                                    callDuration -= 1;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      MyDropdownButton(
                                        value: connectionType,
                                        items: connectionTypeList.map((type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            connectionType = newValue;
                                          });
                                        },
                                        labelText: 'نوع بالاتصال',
                                      ),
                                      const SizedBox(height: 10),
                                      MyDropdownButton(
                                        value: salesRep,
                                        items: responsible.map((type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            salesRep = newValue;
                                          });
                                        },
                                        labelText: 'القائم بالاتصال',
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        spacing: 5,
                                        children: [
                                          Expanded(
                                            child: MyDropdownButton(
                                              value: processKind,
                                              items:
                                                  processKindList.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  processKind = newValue;
                                                });
                                              },
                                              labelText: 'طبيعة الاتصال',
                                            ),
                                          ),
                                          Expanded(
                                            child: MyDropdownButton(
                                              value: discussion,
                                              items: discussionList.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  discussion = newValue;
                                                });
                                              },
                                              labelText: 'طريقة النقاش',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      if (discussion != 'مغلق' &&
                                          discussion != 'لا يرد')
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CheckboxListTile(
                                                title: const Text(
                                                    'حديث اجتماعي',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                value: socialTalk,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    socialTalk = value ?? false;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                    'تسجيل فاتورة',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                value: bill,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    bill = value ?? false;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              ),
                                              CheckboxListTile(
                                                title: const Text('تسجيل شكوى',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                value: complaints,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    complaints = value ?? false;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              ),
                                            ],
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      if (discussion != 'مغلق' &&
                                          discussion != 'لا يرد')
                                        MyTextField(
                                            maxLines: 100,
                                            controller: _summaryController,
                                            labelText: 'الملخص'),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.arrow_back,
                                                color: Colors.white),
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _fillCallModelfromForm();
                                              if (widget.operationsModel ==
                                                  null) {
                                                context
                                                    .read<OperationsBloc>()
                                                    .add(AddNewCall(
                                                        callModel: _callModel));
                                              } else {
                                                context
                                                    .read<OperationsBloc>()
                                                    .add(EditCall(
                                                        callModel: _callModel,
                                                        id: widget
                                                            .operationsModel!
                                                            .id!));
                                              }
                                            },
                                            icon: Icon(
                                              widget.operationsModel == null
                                                  ? Icons.add
                                                  : Icons.edit,
                                              color: Colors.white,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  widget.operationsModel == null
                                                      ? Colors.green
                                                      : Colors.blue,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                            BlocConsumer<SalesBloc, SalesState>(
                              listener: (context, state) {
                                if (state is SalesOpFailure) {
                                  showSnackBar(
                                      context: context,
                                      content: 'حدث خطأ ما',
                                      failure: true);
                                } else if (state is SalesOpSuccess<
                                    List<CustomerBriefViewModel>>) {
                                  _showCustomerDialog(context, state.opResult);
                                } else if (state
                                    is SalesOpSuccess< // NEW: Handle navigation to details
                                        CustomerViewModel>) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return FullCustomerDataPage(
                                          customerViewModel: state.opResult,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is SalesOpLoading) {
                                  return const Center(child: Loader());
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _searchCustomer(BuildContext context) {
    context.read<SalesBloc>().add(
        SalesSearch<CustomerBriefViewModel>(lexum: _searchController.text));
  }

  void _showCustomerDialog(
      BuildContext context, List<CustomerBriefViewModel> customers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'يرجى اختيار زبون',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 10,
                      child: Text(
                        customers[index].id.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(customers[index].customerName ?? ''),
                        Text(customers[index].shopName ?? ''),
                      ],
                    ),
                    subtitle: Text(
                      '${customers[index].governate ?? ''} - ${customers[index].region ?? ''}',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCustomer = customers[index];
                        _isReset = false; // hide search again
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('إغلاق'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
