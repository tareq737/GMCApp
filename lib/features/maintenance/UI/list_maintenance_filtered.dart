import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/maintenance/Models/brief_maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Services/maintenance_services.dart';
import 'package:gmcappclean/features/maintenance/UI/Full_maintance_details_page.dart';
import 'package:gmcappclean/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ListMaintenanceFiltered extends StatelessWidget {
  final String date_1;
  final String date_2;
  final String status;
  const ListMaintenanceFiltered(
      {super.key,
      required this.date_1,
      required this.date_2,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceBloc(MaintenanceServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetMaintenanceFilter(
            page: 1,
            status: status,
            date_1: date_1,
            date_2: date_2,
          ),
        ),
      child: Builder(builder: (context) {
        return ListMaintenanceFilteredChild(
          status: status,
          date_1: date_1,
          date_2: date_2,
        );
      }),
    );
  }
}

class ListMaintenanceFilteredChild extends StatefulWidget {
  final String date_1;
  final String date_2;
  final String status;
  const ListMaintenanceFilteredChild(
      {super.key,
      required this.date_1,
      required this.date_2,
      required this.status});

  @override
  State<ListMaintenanceFilteredChild> createState() =>
      _ListMaintenanceFilteredChildState();
}

class _ListMaintenanceFilteredChildState
    extends State<ListMaintenanceFilteredChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isSearching = false;
  bool isLoadingMore = false;
  List<BriefMaintenanceModel> _briefMaintenance = [];
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
    context.read<MaintenanceBloc>().add(
          GetMaintenanceFilter(
            page: currentPage,
            status: widget.status,
            date_1: widget.date_1,
            date_2: widget.date_2,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Builder(builder: (context) {
      return BlocListener<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceError) {
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
                    ? "كافة طلبات الصيانة المدرجة"
                    : widget.status == "finished"
                        ? "طلبات الصيانة المنفذة"
                        : "طلبات الصيانة",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: BlocConsumer<MaintenanceBloc, MaintenanceState>(
              listener: (context, state) {
                if (state is MaintenanceError) {
                  showSnackBar(
                    context: context,
                    content: 'حدث خطأ ما',
                    failure: true,
                  );
                } else if (state
                    is MaintenanceSuccess<List<BriefMaintenanceModel>>) {
                  setState(
                    () {
                      if (currentPage == 1) {
                        _briefMaintenance =
                            state.result; // First page, replace data
                      } else {
                        _briefMaintenance
                            .addAll(state.result); // Append new data
                      }
                      isLoadingMore = false;
                    },
                  );
                } else if (state is MaintenanceSuccess<MaintenanceModel>) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FullMaintanceDetailsPage(
                          maintenanceModel: state.result,
                          status: 100,
                          log: false,
                        );
                      },
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MaintenanceInitial) {
                  return const SizedBox();
                } else if (state is MaintenanceLoading && currentPage == 1) {
                  return const Center(
                    child: Loader(),
                  );
                } else if (state is MaintenanceError) {
                  return const Center(child: Text('حدث خطأ ما'));
                } else if (_briefMaintenance.isEmpty) {
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
                          'لا توجد طلبات صيانة لعرضها',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (_briefMaintenance.isNotEmpty) {
                  return Builder(builder: (context) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _briefMaintenance.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _briefMaintenance.length) {
                          return isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: Loader()),
                                )
                              : const SizedBox
                                  .shrink(); // Empty space when not loading more data
                        }

                        final screenWidth = MediaQuery.of(context).size.width;
                        return InkWell(
                          onTap: () {
                            context.read<MaintenanceBloc>().add(
                                  GetOneMaintenance(
                                      id: _briefMaintenance[index].id),
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
                                    _briefMaintenance[index].machine_name ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: screenWidth * 0.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     Icon(
                                      //       _briefMaintenance[index]
                                      //                   .manager_check ==
                                      //               true
                                      //           ? Icons
                                      //               .check // ✅ If true, show check mark
                                      //           : _briefMaintenance[index]
                                      //                       .manager_check ==
                                      //                   false
                                      //               ? Icons.close
                                      //               : Icons.stop_circle_outlined,
                                      //       color: _briefMaintenance[index]
                                      //                   .manager_check ==
                                      //               true
                                      //           ? Colors.green
                                      //           : _briefMaintenance[index]
                                      //                       .manager_check ==
                                      //                   false
                                      //               ? Colors.red
                                      //               : Colors.grey,
                                      //       size: 15,
                                      //     ),
                                      //     Icon(
                                      //       (_briefMaintenance[index].received ==
                                      //               true)
                                      //           ? Icons.check
                                      //           : Icons.close,
                                      //       color: (_briefMaintenance[index]
                                      //                   .received ==
                                      //               true)
                                      //           ? Colors.green
                                      //           : Colors.red,
                                      //       size: 15,
                                      //     ),
                                      //     Icon(
                                      //       (_briefMaintenance[index].archived ==
                                      //               true)
                                      //           ? Icons.check
                                      //           : Icons.close,
                                      //       color: (_briefMaintenance[index]
                                      //                   .archived ==
                                      //               true)
                                      //           ? Colors.green
                                      //           : Colors.red,
                                      //       size: 15,
                                      //     ),
                                      //   ],
                                      // ),
                                      Text(_briefMaintenance[index]
                                              .insert_date ??
                                          ''),
                                      Text(
                                        _briefMaintenance[index].duration !=
                                                null
                                            ? '${_briefMaintenance[index].duration} أيام'
                                            : 'قيد التنفيذ',
                                      )
                                    ],
                                  ),
                                ),
                                subtitle: SizedBox(
                                    width: screenWidth * 0.6,
                                    child: Text(
                                      _briefMaintenance[index].problem ?? "",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    )),
                                leading: SizedBox(
                                  width: screenWidth * 0.08,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.teal,
                                        radius: 11,
                                        child: Text(
                                          _briefMaintenance[index]
                                              .id
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        _briefMaintenance[index].department ??
                                            "",
                                        style: const TextStyle(fontSize: 8),
                                      ),
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
                } else if (state is MaintenanceError) {
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
        ),
      );
    });
  }
}
