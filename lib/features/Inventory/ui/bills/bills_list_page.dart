import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/bill_model.dart';
import 'package:gmcappclean/features/Inventory/models/brief_bills_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/bills/bills_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class BillsListPage extends StatelessWidget {
  final String bill_type;
  final int transfer_type;
  const BillsListPage(
      {super.key, required this.bill_type, required this.transfer_type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetListBills(page: 1, bill_type: bill_type),
        ),
      child: Builder(builder: (context) {
        return _BillsListPageChildState(
          bill_type: bill_type,
          transfer_type: transfer_type,
        );
      }),
    );
  }
}

class _BillsListPageChildState extends StatefulWidget {
  final String bill_type;
  final int transfer_type;
  const _BillsListPageChildState({
    required this.bill_type,
    required this.transfer_type,
  });

  @override
  State<_BillsListPageChildState> createState() =>
      __BillsListPageChildStateState();
}

class __BillsListPageChildStateState extends State<_BillsListPageChildState> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<BriefBillsModel> _model = [];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BillsPage(
                        transfer_type: widget.transfer_type,
                        bill_type: widget.bill_type,
                      );
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            _getTitleForTransferType(widget.bill_type),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventoryError) {
              showSnackBar(
                  context: context, content: 'حدث خطأ ما', failure: true);
            } else if (state is InventorySuccess<List<BriefBillsModel>>) {
              setState(() {
                if (currentPage == 1) {
                  _model = state.result;
                } else {
                  _model.addAll(state.result);
                }
                isLoadingMore = false;
              });
            } else if (state is InventorySuccess<BillModel>) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BillsPage(
                      billModel: state.result,
                      transfer_type: widget.transfer_type,
                      bill_type: widget.bill_type,
                    );
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is InventoryLoading && currentPage == 1) {
              return const Center(
                child: Loader(),
              );
            }

            if (_model.isEmpty) {
              if (state is InventoryLoading) {
                return const Center(child: Loader());
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد بيانات لعرضها',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            // --- RESPONSIVE LAYOUT IMPLEMENTATION ---
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  // --- LANDSCAPE UI: GridView ---
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns for landscape
                      childAspectRatio: 4, // Adjust aspect ratio for your items
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _model.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _model.length) {
                        return isLoadingMore
                            ? const Center(child: Loader())
                            : const SizedBox.shrink();
                      }
                      return _buildTransferCard(index);
                    },
                  );
                } else {
                  // --- PORTRAIT UI: ListView (Original) ---
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _model.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _model.length) {
                        return isLoadingMore
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: Loader()),
                              )
                            : const SizedBox.shrink();
                      }
                      return _buildTransferCard(index);
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  /// Helper widget to build the transfer item card.
  /// This avoids code duplication between ListView and GridView.
  Widget _buildTransferCard(int index) {
    return InkWell(
      onTap: () {
        context.read<InventoryBloc>().add(
              GetOneBillByID(id: _model[index].id!),
            );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 4, horizontal: 8), // Adjusted margin for grid/list
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 11,
                child: Text(
                  _model[index].serial.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.bill_type == 'sales')
                      Text(
                        'من: ${_model[index].from_warehouse_name ?? ""}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (widget.bill_type == 'purchase')
                      Text(
                        'إلى: ${_model[index].to_warehouse_name ?? ""}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      'الحساب: ${_model[index].customer_name ?? ""}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _model[index].date ?? "",
                    style: const TextStyle(
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    _model[index].total_amount != null
                        ? "\$${NumberFormat("#,##0.###").format(double.parse(_model[index].total_amount!))}"
                        : "",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore) {
      _nextPage();
    }
  }

  void _nextPage() {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;
    runBloc();
  }

  void runBloc() {
    context.read<InventoryBloc>().add(
          GetListBills(
            page: currentPage,
            bill_type: widget.bill_type,
          ),
        );
  }

  String _getTitleForTransferType(String bill_type) {
    switch (bill_type) {
      case 'sales':
        return 'فواتير المبيعات';
      case 'purchase':
        return 'فواتير المشتريات';

      default:
        return 'فواتير';
    }
  }
}
