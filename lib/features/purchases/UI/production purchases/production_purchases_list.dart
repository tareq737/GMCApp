import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/purchases/Bloc/purchase_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/brief_purchase_model.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
import 'package:gmcappclean/features/purchases/UI/add_purchase_page.dart';
import 'package:gmcappclean/features/purchases/UI/general%20purchases/full_purchase_details.dart';
import 'package:gmcappclean/features/purchases/UI/production%20purchases/full_production_purchase_details.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ProductionPurchasesList extends StatelessWidget {
  final int status;
  const ProductionPurchasesList({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseBloc(
        PurchaseService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetAllProductionPurchases(page: 1, status: status)),
      child: Builder(builder: (context) {
        return ProductionPurchasesListChild(
          status: status,
        );
      }),
    );
  }
}

class ProductionPurchasesListChild extends StatefulWidget {
  final int status;
  const ProductionPurchasesListChild({required this.status, super.key});

  @override
  State<ProductionPurchasesListChild> createState() =>
      _ProductionPurchasesListChildState();
}

class _ProductionPurchasesListChildState
    extends State<ProductionPurchasesListChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isLoadingMore = false;
  List<BriefPurchaseModel> _briefPurchases = [];
  final Map<int, String> _itemStatus = {
    1: 'الطلبات الغير موافقة من المدير',
    2: 'الطلبات الموافقة من المدير وغير منفذة',
    3: 'الطلبات المنفذة',
    4: 'الطلبات المرفوضة',
    5: 'كافة طلبات المشتريات',
  };

  late String _selectedStatus;

  List<String>? groups;

  @override
  void initState() {
    super.initState();
    _selectedStatus = _getItemStatusString(widget.status);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Calculate the halfway point
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;

    // Check if the current scroll position is at or beyond the halfway point
    if (_scrollController.position.pixels >= halfwayPoint && !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;
    if (_searchController.text == "") {
      runBloc();
    } else {
      runBlocSearch();
    }
  }

  int _getItemStatusID() {
    // Find the entry in the _itemStatus map where the value matches _selectedItemStatus
    var entry = _itemStatus.entries.firstWhere(
      (entry) => entry.value == _selectedStatus,
      orElse: () =>
          const MapEntry(-1, ''), // Default entry if no match is found
    );

    // If a matching entry is found, return its key (status ID)
    if (entry.key != -1) {
      return entry.key;
    }

    // If no matching entry is found, return null
    return 1;
  }

  String _getItemStatusString(int statusID) {
    return _itemStatus[statusID] ?? '';
  }

  void runBloc() {
    int statusID = _getItemStatusID();
    context.read<PurchaseBloc>().add(
          GetAllProductionPurchases(
            page: currentPage,
            status: statusID,
          ),
        );
  }

  void runBlocSearch() {
    context.read<PurchaseBloc>().add(
          SearchProductionPurchases(
              page: currentPage, search: _searchController.text),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppUserState state = context.read<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }

    return Builder(builder: (context) {
      return BlocListener<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseError) {
            showSnackBar(
                context: context, content: 'حدث خطأ ما', failure: true);
          }
        },
        child: Directionality(
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
                          return const AddPurchasePage(
                            type: 'production',
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
              title: const Text(
                'طلبات مشتريات إنتاج',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Dropdown for Status
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          hint: Text(
                            'الحالة',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade200
                                  : Colors.teal.shade700,
                            ),
                          ),
                          value: _selectedStatus,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // Add null check
                              setState(() {
                                currentPage = 1;
                                _selectedStatus = newValue;
                              });
                              _briefPurchases = [];
                              runBloc();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: _itemStatus.values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey.shade200
                                        : Colors.teal.shade700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      SearchRow(
                          textEditingController: _searchController,
                          onSearch: () {
                            _briefPurchases = [];
                            runBlocSearch();
                          })
                    ],
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: BlocConsumer<PurchaseBloc, PurchaseState>(
                    listener: (context, state) async {
                      if (state is PurchaseError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      } else if (state
                          is PurchaseSuccess<List<BriefPurchaseModel>>) {
                        setState(
                          () {
                            if (currentPage == 1) {
                              _briefPurchases =
                                  state.result; // First page, replace data
                            } else {
                              _briefPurchases
                                  .addAll(state.result); // Append new data
                            }
                            isLoadingMore = false;
                          },
                        );
                      } else if (state is PurchaseSuccess<PurchasesModel>) {
                        int statusID = _getItemStatusID();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FullProductionPurchaseDetails(
                                purchasesModel: state.result,
                                status: statusID,
                              );
                            },
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is PurchaseInitial) {
                        return const SizedBox();
                      } else if (state is PurchaseLoading && currentPage == 1) {
                        return const Center(
                          child: Loader(),
                        );
                      } else if (state is PurchaseError) {
                        return const Center(child: Text('حدث خطأ ما'));
                      } else if (_briefPurchases.isEmpty) {
                        // This is the new condition for empty list
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
                                'لا توجد طلبات مشتريات إنتاج لعرضها',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (_briefPurchases.isNotEmpty) {
                        return Builder(builder: (context) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: _briefPurchases.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _briefPurchases.length) {
                                return isLoadingMore
                                    ? const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(child: Loader()),
                                      )
                                    : const SizedBox
                                        .shrink(); // Empty space when not loading more data
                              }

                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              return InkWell(
                                onTap: () {
                                  context.read<PurchaseBloc>().add(
                                        GetOnePurchase(
                                            id: _briefPurchases[index].id),
                                      );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: SizedBox(
                                      width: screenWidth * 0.20,
                                      child: Text(
                                        _briefPurchases[index].type ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: screenWidth * 0.25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                _briefPurchases[index]
                                                            .manager_check ==
                                                        true
                                                    ? Icons
                                                        .check // ✅ If true, show check mark
                                                    : _briefPurchases[index]
                                                                .manager_check ==
                                                            false
                                                        ? Icons.close
                                                        : Icons
                                                            .stop_circle_outlined,
                                                color: _briefPurchases[index]
                                                            .manager_check ==
                                                        true
                                                    ? Colors.green
                                                    : _briefPurchases[index]
                                                                .manager_check ==
                                                            false
                                                        ? Colors.red
                                                        : Colors.grey,
                                                size: 15,
                                              ),
                                              Icon(
                                                (_briefPurchases[index]
                                                            .received_check ==
                                                        true)
                                                    ? Icons.check
                                                    : Icons.close,
                                                color: (_briefPurchases[index]
                                                            .received_check ==
                                                        true)
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          Text(_briefPurchases[index]
                                                  .insert_date ??
                                              '')
                                        ],
                                      ),
                                    ),
                                    subtitle: SizedBox(
                                        width: screenWidth * 0.6,
                                        child: Text(
                                          _briefPurchases[index].details ?? "",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        )),
                                    leading: SizedBox(
                                      width: screenWidth * 0.10,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.teal,
                                            radius: 11,
                                            child: Text(
                                              _briefPurchases[index]
                                                  .id
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8),
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              _briefPurchases[index]
                                                      .department ??
                                                  "",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 8),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      } else if (state is PurchaseError) {
                        return const Center(
                          child: Text(
                            'حدث خطأ ما',
                          ),
                        );
                      } else {
                        return const Center(
                          child: Loader(),
                        );
                      }
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
}
