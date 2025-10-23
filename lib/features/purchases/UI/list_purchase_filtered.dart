import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/purchases/Bloc/purchase_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/brief_purchase_model.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
import 'package:gmcappclean/features/purchases/UI/general%20purchases/full_purchase_details.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ListPurchaseFiltered extends StatelessWidget {
  final String date_1;
  final String date_2;
  final String status;
  const ListPurchaseFiltered(
      {super.key,
      required this.date_1,
      required this.date_2,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseBloc(PurchaseService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetPurchasesFilter(
            page: 1,
            status: status,
            date_1: date_1,
            date_2: date_2,
          ),
        ),
      child: Builder(builder: (context) {
        return ListPurchaseFilteredChild(
          date_1: date_1,
          date_2: date_2,
          status: status,
        );
      }),
    );
  }
}

class ListPurchaseFilteredChild extends StatefulWidget {
  final String date_1;
  final String date_2;
  final String status;
  const ListPurchaseFilteredChild(
      {super.key,
      required this.date_1,
      required this.date_2,
      required this.status});

  @override
  State<ListPurchaseFilteredChild> createState() =>
      _ListPurchaseFilteredChildState();
}

class _ListPurchaseFilteredChildState extends State<ListPurchaseFilteredChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isSearching = false;
  bool isLoadingMore = false;
  List<BriefPurchaseModel> _model = [];
  double width = 0;
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

    runBloc();
  }

  void runBloc() {
    context.read<PurchaseBloc>().add(
          GetPurchasesFilter(
            page: currentPage,
            status: widget.status,
            date_1: widget.date_1,
            date_2: widget.date_2,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    width = MediaQuery.of(context).size.width;
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
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: Text(
                widget.status == ""
                    ? "كافة طلبات الشراء المدرجة"
                    : widget.status == "pending"
                        ? "طلبات الشراء قيد التنفيذ"
                        : widget.status == "finished"
                            ? "طلبات الشراء المنفذة"
                            : widget.status == "on_time"
                                ? "طلبات الشراء المنفذة على الوقت"
                                : widget.status == "late"
                                    ? "طلبات الشراء المتأخرة"
                                    : "طلبات مشتريات عام",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              _model = state.result; // First page, replace data
                            } else {
                              _model.addAll(state.result); // Append new data
                            }
                            isLoadingMore = false;
                          },
                        );
                      } else if (state is PurchaseSuccess<PurchasesModel>) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FullPurchaseDetails(
                                purchasesModel: state.result,
                                status: 100,
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
                      } else if (_model.isEmpty) {
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
                                'لا توجد طلبات مشتريات لعرضها',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (_model.isNotEmpty) {
                        return Builder(builder: (context) {
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
                                    : const SizedBox
                                        .shrink(); // Empty space when not loading more data
                              }

                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              return InkWell(
                                onTap: () {
                                  context.read<PurchaseBloc>().add(
                                        GetOnePurchase(id: _model[index].id),
                                      );
                                },
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: width, end: 0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.decelerate,
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(value, 0),
                                      child: child,
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
                                          _model[index].type ?? "",
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
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.center,
                                            //   children: [
                                            //     Icon(
                                            //       (_model[index].last_price ?? "")
                                            //               .isNotEmpty
                                            //           ? Icons.check
                                            //           : Icons.close,
                                            //       color:
                                            //           (_model[index].last_price ??
                                            //                       "")
                                            //                   .isNotEmpty
                                            //               ? Colors.green
                                            //               : Colors.red,
                                            //       size: 15,
                                            //     ),
                                            //     Icon(
                                            //       _model[index].manager_check ==
                                            //               true
                                            //           ? Icons
                                            //               .check // ✅ If true, show check mark
                                            //           : _model[index]
                                            //                       .manager_check ==
                                            //                   false
                                            //               ? Icons.close
                                            //               : Icons
                                            //                   .stop_circle_outlined,
                                            //       color: _model[index]
                                            //                   .manager_check ==
                                            //               true
                                            //           ? Colors.green
                                            //           : _model[index]
                                            //                       .manager_check ==
                                            //                   false
                                            //               ? Colors.red
                                            //               : Colors.grey,
                                            //       size: 15,
                                            //     ),
                                            //     Icon(
                                            //       (_model[index].received_check ==
                                            //               true)
                                            //           ? Icons.check
                                            //           : Icons.close,
                                            //       color: (_model[index]
                                            //                   .received_check ==
                                            //               true)
                                            //           ? Colors.green
                                            //           : Colors.red,
                                            //       size: 15,
                                            //     ),
                                            //     Icon(
                                            //       (_model[index].archived == true)
                                            //           ? Icons.check
                                            //           : Icons.close,
                                            //       color:
                                            //           (_model[index].archived ==
                                            //                   true)
                                            //               ? Colors.green
                                            //               : Colors.red,
                                            //       size: 15,
                                            //     ),
                                            //     Icon(
                                            //       (_model[index]
                                            //                   .bill
                                            //                   ?.isNotEmpty ??
                                            //               false)
                                            //           ? Icons.check
                                            //           : Icons.close,
                                            //       color: (_model[index]
                                            //                   .bill
                                            //                   ?.isNotEmpty ??
                                            //               false)
                                            //           ? Colors.green
                                            //           : Colors.red,
                                            //       size: 15,
                                            //     ),
                                            //   ],
                                            // ),
                                            Text(_model[index].insert_date ??
                                                ''),
                                            Text(
                                              _model[index].duration != null
                                                  ? '${_model[index].duration} أيام'
                                                  : 'قيد التنفيذ',
                                              style: TextStyle(
                                                fontWeight:
                                                    _model[index].duration !=
                                                                null &&
                                                            _model[index]
                                                                    .duration! >
                                                                7
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: _model[index].duration !=
                                                            null &&
                                                        _model[index]
                                                                .duration! >
                                                            7
                                                    ? Colors.red
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                          width: screenWidth * 0.6,
                                          child: Text(
                                            _model[index].details ?? "",
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
                                              radius: 14,
                                              child: Text(
                                                _model[index].id.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            AutoSizeText(
                                              minFontSize: 8,
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              _model[index].department ?? "",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
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
