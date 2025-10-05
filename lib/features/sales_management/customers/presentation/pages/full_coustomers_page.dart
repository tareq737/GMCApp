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
        ..add(SalesGetAllPaginated<CustomerBriefViewModel>(
            page: 1, search: '', pageSize: 30)),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (Platform.isWindows)
              IconButton(
                onPressed: () {
                  setState(() {
                    isExporting = true;
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
                _searchCustomer(context);
              },
            ),
            // The main change is wrapping the results in an OrientationBuilder
            Expanded(
              child: BlocConsumer<SalesBloc, SalesState>(
                listener: (context, state) async {
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
                      isExporting = false;
                    });
                    await _saveFile(state.opResult);
                  } else if (state is SalesOpFailure) {
                    showSnackBar(
                      context: context,
                      content: 'حدث خطأ: ${state.message}',
                      failure: true,
                    );
                    setState(() {
                      isSearching = false;
                      isLoadingMore = false;
                      isExporting = false;
                    });
                  }
                  _handleState(context, state);
                },
                builder: (context, state) {
                  if (isSearching ||
                      (state is SalesOpLoading && currentPage == 1)) {
                    return const Loader();
                  } else if (customers.isEmpty && state is! SalesOpLoading) {
                    return const Center(child: Text("لا يوجد بيانات"));
                  } else {
                    // Use OrientationBuilder to switch between list and grid
                    return OrientationBuilder(
                      builder: (context, orientation) {
                        if (orientation == Orientation.landscape) {
                          return _buildCustomerGridView(customers);
                        } else {
                          return _buildCustomerListView(customers);
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Renamed from _buildCustomerFullDetailsList for clarity
  Widget _buildCustomerListView(List<CustomerBriefViewModel> customerList) {
    // This is your original ListView code, unchanged.
    return ListView.builder(
      controller: _scrollController,
      itemCount: customerList.length + (isLoadingMore ? 1 : 0),
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
        final customer = customerList[index];
        return Card(
          child: ListTile(
            onTap: () {
              context
                  .read<SalesBloc>()
                  .add(SalesGetById<CustomerViewModel>(id: customer.id));
            },
            title: Text(customer.customerName ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
            subtitle:
                Text(customer.shopName ?? '', textAlign: TextAlign.center),
            leading: SizedBox(
              width: screenWidth * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    customer.governate ?? '',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.end,
                  ),
                  if (customer.shopCoordinates?.isNotEmpty ?? false)
                    const Icon(Icons.location_on_outlined,
                        color: Colors.red, size: 20)
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
                    customer.region ?? '',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9),
                  ),
                  CircleAvatar(
                    radius: 10,
                    child: Text(
                      customer.id.toString(),
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

  // NEW: Widget builder for the GridView in landscape mode
  Widget _buildCustomerGridView(List<CustomerBriefViewModel> customerList) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, // Max width for each item
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 4 / 3, // Aspect ratio of items
      ),
      itemCount: customerList.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == customerList.length) {
          return isLoadingMore
              ? const Center(child: Loader())
              : const SizedBox.shrink();
        }
        final customer = customerList[index];
        return _CustomerGridItem(
          customer: customer,
          onTap: () {
            context
                .read<SalesBloc>()
                .add(SalesGetById<CustomerViewModel>(id: customer.id));
          },
        );
      },
    );
  }

  // --- Other methods remain the same ---
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore) {
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
              page: currentPage, search: _searchController.text, pageSize: 20),
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

  void _searchCustomer(BuildContext context) {
    setState(() {
      isSearching = true;
      currentPage = 1;
      customers.clear();
    });
    context.read<SalesBloc>().add(
          SalesGetAllPaginated<CustomerBriefViewModel>(
              page: 1, search: _searchController.text, pageSize: 30),
        );
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'تقرير العملاء.xlsx'; // More relevant name
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(bytes);
      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');
      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        await _showDialog('خطأ', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      await _showDialog('خطأ', 'فشل حفظ/فتح الملف:\n${e.toString()}');
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

// A dedicated widget for a single item in the grid
class _CustomerGridItem extends StatelessWidget {
  final CustomerBriefViewModel customer;
  final VoidCallback onTap;

  const _CustomerGridItem({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias, // Prevents the icon from bleeding out
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Conditional Background Icon
            // This now appears as a large, semi-transparent watermark.
            if (customer.shopCoordinates?.isNotEmpty ?? false)
              Icon(
                Icons.location_on,
                color: Colors.red.withOpacity(0.10),
                size: 90,
              ),

            // 2. Foreground Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // The small, solid icon is removed from here.
                      CircleAvatar(
                        radius: 12,
                        child: Text(
                          customer.id.toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          customer.customerName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer.shopName ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${customer.governate ?? ''} - ${customer.region ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
