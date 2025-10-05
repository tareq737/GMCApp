// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/bill_model.dart';
import 'package:gmcappclean/features/Inventory/models/payment_model.dart';
import 'package:gmcappclean/features/Inventory/ui/bills/bills_page.dart';
import 'package:gmcappclean/features/Inventory/ui/payments/payment_page.dart';
import 'package:intl/intl.dart';

import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/account_statement_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/Accounts/account_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class AccountStatementPage extends StatelessWidget {
  int customer;
  AccountStatementPage({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetAccountStatement(page: 1, customer: customer),
        ),
      child: Builder(builder: (context) {
        return AccountStatementChild(
          customer: customer,
        );
      }),
    );
  }
}

class AccountStatementChild extends StatefulWidget {
  int customer;
  AccountStatementChild({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<AccountStatementChild> createState() => _AccountStatementChildState();
}

class _AccountStatementChildState extends State<AccountStatementChild> {
  DateTime? date1;
  DateTime? date2;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          date1 = picked;
        } else {
          date2 = picked;
        }
      });
    }
  }

  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<AccountStatementModel> _model = [];
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

  void _onScroll() {
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;
    if (_scrollController.position.pixels >= halfwayPoint && !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;

    runBloc();
  }

  void runBloc() {
    context.read<InventoryBloc>().add(
          GetAccountStatement(
            page: currentPage,
            customer: widget.customer,
            date_1:
                date1 == null ? null : DateFormat('yyyy-MM-dd').format(date1!),
            date_2:
                date2 == null ? null : DateFormat('yyyy-MM-dd').format(date2!),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Builder(builder: (context) {
      return BlocListener<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventoryError) {
            showSnackBar(
                context: context, content: 'حدث خطأ ما', failure: true);
          }
        },
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'كشف حساب',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              date1 == null
                                  ? 'من تاريخ'
                                  : DateFormat('yyyy-MM-dd').format(date1!),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              date2 == null
                                  ? 'إلى تاريخ'
                                  : DateFormat('yyyy-MM-dd').format(date2!),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentPage = 1;
                              _model.clear();
                            });
                            context.read<InventoryBloc>().add(
                                  GetAccountStatement(
                                    page: 1,
                                    customer: widget.customer,
                                    date_1: date1 == null
                                        ? null
                                        : DateFormat('yyyy-MM-dd')
                                            .format(date1!),
                                    date_2: date2 == null
                                        ? null
                                        : DateFormat('yyyy-MM-dd')
                                            .format(date2!),
                                  ),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocConsumer<InventoryBloc, InventoryState>(
                    listener: (context, state) {
                      if (state is InventoryError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      } else if (state
                          is InventorySuccess<List<AccountStatementModel>>) {
                        setState(
                          () {
                            if (currentPage == 1) {
                              _model = state.result;
                            } else {
                              _model.addAll(state.result);
                            }
                            isLoadingMore = false;
                          },
                        );
                      } else if (state is InventorySuccess<BillModel>) {
                        final bill = state.result;

                        // Find the type of the current bill from the loaded models
                        final item = _model.firstWhere(
                          (e) => e.bill_id == bill.id,
                          orElse: () =>
                              AccountStatementModel(type: 'فاتورة مبيعات'),
                        );

                        String billType = '';
                        int transferType = 0;

                        if (item.type == 'فاتورة مبيعات') {
                          billType = 'sales';
                          transferType = 102;
                        } else if (item.type == 'فاتورة مشتريات') {
                          billType = 'purchase';
                          transferType = 101;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillsPage(
                              billModel: bill,
                              transfer_type: transferType,
                              bill_type: billType,
                            ),
                          ),
                        );
                      } else if (state is InventorySuccess<PaymentModel>) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PaymentPage(
                                paymentModel: state.result,
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
                                'لا توجد عمليات لعرضها',
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
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // Set to 3 columns
                                childAspectRatio: 4, // Adjust for better look
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
                                return _buildCard(index);
                              },
                            );
                          } else {
                            // --- PORTRAIT UI: ListView ---
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
                                return _buildCard(index);
                              },
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
        ),
      );
    });
  }

  Widget _buildCard(int index) {
    final item = _model[index];
    final String serialOrPayment =
        item.serial?.toString() ?? item.payment_id?.toString() ?? '';

    return InkWell(
      onTap: () {
        if (item.type == 'سند دفعة') {
          context.read<InventoryBloc>().add(
                GetOnePaymentByID(id: _model[index].payment_id!),
              );
        } else {
          context.read<InventoryBloc>().add(
                GetOneBillByID(id: _model[index].bill_id!),
              );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Type Badge ---
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: getTypeColor(item.type),
                ),
                child: AutoSizeText(
                  item.type ?? '',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // --- Details (Date + Amount) ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.date ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.amount != null
                          ? NumberFormat('#,##0.00').format(item.amount)
                          : '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              if (serialOrPayment.isNotEmpty)
                CircleAvatar(
                  radius: 16,
                  child: Text(
                    serialOrPayment,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Color getTypeColor(String? type) {
  switch (type) {
    case 'فاتورة مشتريات':
      return Colors.red.shade600; // purchase → red
    case 'فاتورة مبيعات':
      return Colors.green.shade600; // sales → green
    case 'سند دفعة':
      return Colors.orange.shade700; // payment → orange
    default:
      return Colors.grey.shade600; // fallback color
  }
}
