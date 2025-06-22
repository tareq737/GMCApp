import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/items/items_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ItemsListPage extends StatelessWidget {
  const ItemsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          SearchItems(page: 1, search: ''),
        ),
      child: Builder(builder: (context) {
        return const ItemsListPageChild();
      }),
    );
  }
}

class ItemsListPageChild extends StatefulWidget {
  const ItemsListPageChild({super.key});

  @override
  State<ItemsListPageChild> createState() => _ItemsListPageChildState();
}

class _ItemsListPageChildState extends State<ItemsListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  bool isSearching = false;
  bool isLoadingMore = false;
  List<ItemsModel> _itemModel = [];
  List<String>? groups;

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ItemsPage();
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))
              ],
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'المواد',
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
                    _itemModel.clear();
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
                      } else if (state is InventorySuccess<List<ItemsModel>>) {
                        setState(
                          () {
                            if (currentPage == 1) {
                              _itemModel = state.result;
                            } else {
                              _itemModel.addAll(state.result);
                            }
                            isLoadingMore = false;
                          },
                        );
                      } else if (state is InventorySuccess<ItemsModel>) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ItemsPage(
                                itemsModel: state.result,
                              );
                            },
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is InventoryInitial) {
                        return const SizedBox();
                      } else if (state is InventoryLoading &&
                          currentPage == 1) {
                        return const Center(
                          child: Loader(),
                        );
                      } else if (state is InventoryError) {
                        return const Center(child: Text('حدث خطأ ما'));
                      } else if (_itemModel.isEmpty) {
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
                                'لا توجد مواد لعرضها',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (_itemModel.isNotEmpty) {
                        return Builder(builder: (context) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: _itemModel.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _itemModel.length) {
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
                                  context.read<InventoryBloc>().add(
                                        GetOneItem(id: _itemModel[index].id),
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
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.teal,
                                        radius: 11,
                                        child: Text(
                                          _itemModel[index].id.toString(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                      title: SizedBox(
                                        width: screenWidth * 0.20,
                                        child: Text(
                                          '${_itemModel[index].code ?? ""}-${_itemModel[index].name ?? ""}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                        width: screenWidth * 0.6,
                                        child: Text(
                                          _itemModel[index].group_code_name ??
                                              "",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                      ),
                                      trailing: Text(
                                        _itemModel[index].unit ?? "",
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    )),
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
              ],
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

    runBlocSearch();
  }

  void runBlocSearch() {
    context.read<InventoryBloc>().add(
          SearchItems(page: currentPage, search: _searchController.text),
        );
  }
}
