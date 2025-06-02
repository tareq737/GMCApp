// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gmcappclean/core/common/widgets/loader.dart';
// import 'package:gmcappclean/core/common/widgets/search_row.dart';
// import 'package:gmcappclean/core/utils/show_snackbar.dart';
// import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
// import 'package:gmcappclean/features/sales_management/customers/presentation/pages/full_customer_data_page.dart';
// import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
// import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';
// import 'package:gmcappclean/init_dependencies.dart';

// class SearchForCustomerPage extends StatefulWidget {
//   const SearchForCustomerPage({super.key});

//   @override
//   State<SearchForCustomerPage> createState() => _SearchForCustomerPageState();
// }

// class _SearchForCustomerPageState extends State<SearchForCustomerPage> {
//   final _searchController = TextEditingController();
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getIt<SalesBloc>(),
//       child: Builder(
//         builder: (context) {
//           return Directionality(
//             textDirection: TextDirection.rtl,
//             child: Scaffold(
//               appBar: AppBar(
//                 title: Text('الزبائن'),
//                 centerTitle: true,
//               ),
//               floatingActionButton: FloatingActionButton(
//                 mini: true,
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return const FullCustomerDataPage();
//                       },
//                     ),
//                   );
//                 },
//                 child: const Icon(
//                   Icons.add_sharp,
//                   size: 30,
//                 ),
//               ),
//               body: Column(
//                 children: [
//                   SearchRow(
//                     textEditingController: _searchController,
//                     onSearch: () {
//                       _searchCustomer(context);
//                     },
//                   ),
//                   BlocConsumer<SalesBloc, SalesState>(
//                     listener: (context, state) {
//                       _handleState(context, state);
//                     },
//                     builder: (context, state) {
//                       if (state is SalesOpLoading) {
//                         return const Loader();
//                       } else if (state
//                           is SalesOpSuccess<List<CustomerBriefViewModel>>) {
//                         return _buildCustomerList(context, state.opResult);
//                       } else {
//                         return const ListTile();
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _searchCustomer(BuildContext context) {
//     context.read<SalesBloc>().add(
//           SalesSearch<CustomerBriefViewModel>(lexum: _searchController.text),
//         );
//   }

//   void _handleState(BuildContext context, SalesState state) {
//     if (state is SalesOpFailure) {
//       showSnackBar(
//         context: context,
//         content: state.message,
//         failure: true,
//       );
//     }

//     if (state is SalesOpSuccess<CustomerViewModel>) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (
//             context,
//           ) {
//             return FullCustomerDataPage(
//               customerViewModel: state.opResult,
//             );
//           },
//         ),
//       );
//     }
//   }

//   Widget _buildCustomerList(
//       BuildContext context, List<CustomerBriefViewModel> customerList) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: customerList.length,
//         itemBuilder: (context, index) {
//           final screenWidth = MediaQuery.of(context).size.width;

//           return Card(
//             child: ListTile(
//               onTap: () {
//                 context.read<SalesBloc>().add(
//                       SalesGetById<CustomerViewModel>(
//                           id: customerList[index].id),
//                     );
//               },
//               title: AutoSizeText(
//                 customerList[index].customerName ?? '',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 14),
//               ),
//               subtitle: AutoSizeText(
//                 customerList[index].shopName ?? '',
//                 textAlign: TextAlign.center,
//               ),
//               leading: SizedBox(
//                 width: screenWidth * 0.18,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       customerList[index].governate ?? '',
//                       overflow: TextOverflow.clip,
//                       textAlign: TextAlign.end,
//                     ),
//                     if (customerList[index].shopCoordinates?.isNotEmpty ??
//                         false)
//                       const Icon(
//                         Icons.location_on_outlined,
//                         color: Colors.red,
//                         size: 20,
//                       )
//                     else
//                       const SizedBox.shrink(),
//                   ],
//                 ),
//               ),
//               trailing: SizedBox(
//                 width: screenWidth * 0.3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       customerList[index].region ?? '',
//                       overflow: TextOverflow.clip,
//                       textAlign: TextAlign.end,
//                     ),
//                     CircleAvatar(
//                       radius: 10,
//                       child: Text(
//                         customerList[index].id.toString(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
