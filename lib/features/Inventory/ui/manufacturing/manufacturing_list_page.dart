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
import 'package:gmcappclean/features/Inventory/models/manufacturing/brief_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/main_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/manufacturing/manufacturing_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ManufacturingListPage extends StatelessWidget {
  const ManufacturingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetListBriefManufacturing(page: 1),
        ),
      child: Builder(builder: (context) {
        return const ManufacturingListPageChild();
      }),
    );
  }
}

class ManufacturingListPageChild extends StatefulWidget {
  const ManufacturingListPageChild({super.key});

  @override
  State<ManufacturingListPageChild> createState() =>
      _ManufacturingListPageChildState();
}

class _ManufacturingListPageChildState
    extends State<ManufacturingListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  bool isSearching = false;
  bool isLoadingMore = false;
  List<BriefManufacturingModel> _model = [];
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

    runBloc();
  }

  void runBloc() {
    context.read<InventoryBloc>().add(
          GetListBriefManufacturing(
            page: currentPage,
          ),
        );
  }

  void runBlocSearch() {
    context.read<InventoryBloc>().add(
          GetListBriefManufacturing(
              page: currentPage, search: _searchController.text),
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
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ManufacturingPage();
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
                'عمليات التصنيع',
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
                          is InventorySuccess<List<BriefManufacturingModel>>) {
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
                      } else if (state
                          is InventorySuccess<MainManufacturingModel>) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ManufacturingPage(
                                mainModel: state.result,
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
                                crossAxisCount: 3, // Set to 3 columns
                                childAspectRatio: 2.5, // Adjust for better look
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
                                return _buildManufacturingCard(index);
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
                                return _buildManufacturingCard(index);
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

  /// Helper widget to build the manufacturing item card.
  /// This avoids code duplication between ListView and GridView.
  Widget _buildManufacturingCard(int index) {
    return InkWell(
      onTap: () {
        context.read<InventoryBloc>().add(
              GetOneManufacturing(id: _model[index].id),
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
                  _model[index].serial.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _model[index].manufactured_item_name ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(_model[index].date ?? ""),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _model[index].batch_number ?? "",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
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
