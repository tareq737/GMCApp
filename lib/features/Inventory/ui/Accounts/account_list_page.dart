import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/accounts_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/Accounts/account_page.dart';
import 'package:gmcappclean/features/Inventory/ui/Accounts/account_statement_page.dart';
import 'package:gmcappclean/features/Inventory/ui/bills/customer_bills_list.dart';
import 'package:gmcappclean/features/Inventory/ui/payments/customer_payment_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          SearchAccounts(page: 1, search: ''),
        ),
      child: Builder(builder: (context) {
        return const AccountListPageChild();
      }),
    );
  }
}

class AccountListPageChild extends StatefulWidget {
  const AccountListPageChild({super.key});

  @override
  State<AccountListPageChild> createState() => _AccountListPageChildState();
}

class _AccountListPageChildState extends State<AccountListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  bool isSearching = false;
  bool isLoadingMore = false;
  List<AccountsModel> _model = [];
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

    runBlocSearch();
  }

  void runBlocSearch() {
    context.read<InventoryBloc>().add(
          SearchAccounts(page: currentPage, search: _searchController.text),
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
                      return const AccountPage();
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
                'الحسابات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              children: [
                SearchRow(
                  textEditingController: _searchController,
                  onSearch: () {
                    currentPage = 1;
                    _model.clear();
                    runBlocSearch();
                  },
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
                          is InventorySuccess<List<AccountsModel>>) {
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
                      } else if (state is InventorySuccess<AccountsModel>) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AccountPage(
                                accountsModel: state.result,
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
    final netValue =
        double.tryParse(_model[index].balance?.net?.toString() ?? '') ?? 0.0;
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return InkWell(
      onTap: () {
        context.read<InventoryBloc>().add(
              GetOneAccountByID(id: _model[index].id!),
            );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                  _model[index].id.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  flex: 7,
                  child: AutoSizeText(
                    "${_model[index].code ?? ""} - ${_model[index].name ?? ""}",
                    minFontSize: 8,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  netValue == 0
                      ? "0.00"
                      : "${formatter.format(netValue.abs())} ${netValue > 0 ? "دائن" : "مدين"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: netValue == 0
                        ? Colors.grey
                        : netValue > 0
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.circleInfo,
                  size: 18,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  // Show the selection dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Directionality(
                        textDirection: ui.TextDirection
                            .rtl, // Ensure RTL for Arabic text in the dialog
                        child: SimpleDialog(
                          title: const Text('اختر الإجراء'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CustomerPaymentListPage(
                                        customer: _model[index].id!,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text('سندات'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CustomerBillsList(
                                        customer: _model[index].id!,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text('فواتير'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AccountStatementPage(
                                        customer: _model[index].id!,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text('كشف حساب'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
