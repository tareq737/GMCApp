import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/init_dependencies.dart';

class GroupsListPage extends StatelessWidget {
  const GroupsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetAllGroups(page: 1),
        ),
      child: Builder(builder: (context) {
        return const GroupsListPageChild();
      }),
    );
  }
}

class GroupsListPageChild extends StatefulWidget {
  const GroupsListPageChild({super.key});

  @override
  State<GroupsListPageChild> createState() => _GroupsListPageChildState();
}

class _GroupsListPageChildState extends State<GroupsListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<GroupsModel> _groupModel = [];
  List<String>? groups;

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
              actions: [
                IconButton(
                    onPressed: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const AddWarehousePage();
                      //     },
                      //   ),
                      // );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))
              ],
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'المجموعات',
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
                } else if (state is InventorySuccess<List<GroupsModel>>) {
                  setState(
                    () {
                      if (currentPage == 1) {
                        _groupModel = state.result;
                      } else {
                        _groupModel.addAll(state.result);
                      }
                      isLoadingMore = false;
                    },
                  );
                } else if (state is InventorySuccess<GroupsModel>) {}
              },
              builder: (context, state) {
                if (state is InventoryInitial) {
                  return const SizedBox();
                } else if (state is InventoryLoading && currentPage == 1) {
                  return const Center(
                    child: Loader(),
                  );
                } else if (state is InventoryError) {
                  return const Center(child: Text('حدث خطأ ما'));
                } else if (_groupModel.isEmpty) {
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
                          'لا توجد مجموعات لعرضها',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (_groupModel.isNotEmpty) {
                  return Builder(builder: (context) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _groupModel.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _groupModel.length) {
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
                          onTap: () {},
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                radius: 11,
                                child: Text(
                                  _groupModel[index].id.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 8),
                                ),
                              ),
                              title: SizedBox(
                                width: screenWidth * 0.20,
                                child: Text(
                                  _groupModel[index].name ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              subtitle: SizedBox(
                                  width: screenWidth * 0.6,
                                  child: Text(
                                    _groupModel[index].code ?? "",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  )),
                            ),
                          ),
                        );
                      },
                    );
                  });
                } else if (state is InventoryError) {
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
    context.read<InventoryBloc>().add(
          GetAllGroups(
            page: currentPage,
          ),
        );
  }
}
