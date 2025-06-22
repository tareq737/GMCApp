import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/pages/customers_map_page.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/pages/full_customer_data_page.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FullCoustomersPage extends StatelessWidget {
  const FullCoustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SalesBloc>()
        ..add(
            SalesGetAllPaginated<CustomerBriefViewModel>(page: 1, search: '')),
      child: Builder(builder: (context) {
        return const FullCoustomersPageChild();
      }),
    );
  }
}

class FullCoustomersPageChild extends StatefulWidget {
  const FullCoustomersPageChild({super.key});

  @override
  State<FullCoustomersPageChild> createState() =>
      _FullCoustomersPageChildState();
}

class _FullCoustomersPageChildState extends State<FullCoustomersPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  bool isLoadingMore = false;
  late List<CustomerBriefViewModel> customers;
  bool isSearching = false;
  bool isExporting = false;

  @override
  void initState() {
    super.initState();
    customers = [];
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              if (Platform.isWindows)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExporting = true; // Set exporting state to true
                    });
                    context.read<SalesBloc>().add(
                          ExportExcelCustomers(),
                        );
                  },
                  icon: const FaIcon(FontAwesomeIcons.fileExport),
                ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CustomersMapPage();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.map_outlined),
              ),
            ],
            title: const Text('الزبائن'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const FullCustomerDataPage();
                  },
                ),
              );
            },
            child: const Icon(
              Icons.add_sharp,
              size: 30,
            ),
          ),
          body: Column(
            children: [
              SearchRow(
                textEditingController: _searchController,
                onSearch: () {
                  //customers.clear();
                  _searchCustomer(context);
                },
              ),
              BlocConsumer<SalesBloc, SalesState>(
                listener: (context, state) async {
                  // We handle SalesOpFailure here specifically for the snackbar
                  // and loading states. _handleState will handle navigation.
                  if (state is SalesOpSuccess<List<CustomerBriefViewModel>>) {
                    setState(
                      () {
                        customers.addAll(state.opResult);
                        isSearching = false;
                        isLoadingMore = false;
                      },
                    );
                  } else if (state is SalesOpSuccess<Uint8List>) {
                    setState(() {
                      isExporting = false; // Reset exporting state
                    });
                    await _saveFile(state.opResult);
                  } else if (state is SalesOpFailure) {
                    print('Sales Operation Failed: ${state.message}');
                    showSnackBar(
                      context: context,
                      content: 'حدث خطأ: ${state.message}',
                      failure: true,
                    );
                    setState(() {
                      isSearching = false;
                      isLoadingMore = false;
                      isExporting = false; // Reset exporting state on failure
                    });
                  }

                  _handleState(context, state);
                },
                builder: (context, state) {
                  return Expanded(
                    child: Builder(builder: (context) {
                      if (isSearching) {
                        return const Loader(); // Show loader when searching
                      } else if (state is SalesOpLoading && currentPage == 1) {
                        return const Loader();
                      } else if (customers.isEmpty &&
                          state is! SalesOpLoading) {
                        return const Center(
                            child: Text(
                                "لا يوجد بيانات")); // Show empty message if no results
                      } else {
                        return _buildCustomerFullDetailsList(
                            context, customers);
                      }
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onScroll() {
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;
    if (_scrollController.position.pixels >= halfwayPoint && !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    currentPage++;
    context.read<SalesBloc>().add(
          SalesGetAllPaginated<CustomerBriefViewModel>(
            page: currentPage,
            search: _searchController.text,
          ),
        );
  }

  void _handleState(BuildContext context, SalesState state) {
    if (state is SalesOpSuccess<CustomerViewModel>) {
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
  }

  Widget _buildCustomerFullDetailsList(
      BuildContext context, List<CustomerBriefViewModel> customerList) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: customerList.length + 1,
      itemBuilder: (context, index) {
        if (index == customerList.length) {
          return isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Loader()),
                )
              : const SizedBox.shrink();
        }

        final screenWidth = MediaQuery.of(context).size.width;

        return Card(
          child: ListTile(
            onTap: () {
              context.read<SalesBloc>().add(
                    SalesGetById<CustomerViewModel>(id: customerList[index].id),
                  );
            },
            title: Text(
              customerList[index].customerName ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              customerList[index].shopName ?? '',
              textAlign: TextAlign.center,
            ),
            leading: SizedBox(
              width: screenWidth * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    customerList[index].governate ?? '',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.end,
                  ),
                  if (customerList[index].shopCoordinates?.isNotEmpty ?? false)
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.red,
                      size: 20,
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
            trailing: SizedBox(
              width: screenWidth * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    customerList[index].region ?? '',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9),
                  ),
                  CircleAvatar(
                    radius: 10,
                    child: Text(
                      customerList[index].id.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _searchCustomer(BuildContext context) {
    setState(() {
      isSearching = true;
      currentPage = 1;
      customers.clear();
    });
    context.read<SalesBloc>().add(
          SalesGetAllPaginated<CustomerBriefViewModel>(
              page: 1, search: _searchController.text),
        );
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'تقرير زيارات المبيعات.xlsx';
      final path = '${directory.path}/$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      // Show success dialog before attempting to open
      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

      final result = await OpenFilex.open(path);

      if (result.type != ResultType.done) {
        // If OpenFilex fails, show an error dialog
        await _showDialog('خطأ', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      // Catch any exceptions during file saving or opening
      await _showDialog(
          'خطأ', 'فشل حفظ/فتح الملف:\n${e.toString()}'); // More specific error
    }
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
