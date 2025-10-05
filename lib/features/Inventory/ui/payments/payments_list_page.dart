import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/payment_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/payments/payment_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class PaymentsListPage extends StatelessWidget {
  const PaymentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetPayments(page: 1),
        ),
      child: Builder(builder: (context) {
        return const PaymentsListPageChild();
      }),
    );
  }
}

class PaymentsListPageChild extends StatefulWidget {
  const PaymentsListPageChild({super.key});

  @override
  State<PaymentsListPageChild> createState() => _PaymentsListPageChildState();
}

class _PaymentsListPageChildState extends State<PaymentsListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  bool isLoadingMore = false;
  List<PaymentModel> _model = [];

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
          GetPayments(page: currentPage),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PaymentPage();
                    },
                  ),
                );
              },
              mini: true,
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'السندات',
                style: TextStyle(
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
                    context: context,
                    content: 'حدث خطأ ما',
                    failure: true,
                  );
                } else if (state is InventorySuccess<List<PaymentModel>>) {
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
                          'لا توجد سندات لعرضها',
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
                          childAspectRatio: 3, // Adjust for better look
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
        ),
      );
    });
  }

  Widget _buildCard(int index) {
    return InkWell(
      onTap: () {
        context.read<InventoryBloc>().add(
              GetOnePaymentByID(id: _model[index].id!),
            );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 11,
                    child: Text(
                      _model[index].id.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 7,
                    child: Text(
                      _model[index].date ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      _model[index].amount.toString(),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              AutoSizeText(
                _model[index].note ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                minFontSize: 8,
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
