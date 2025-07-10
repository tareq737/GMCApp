import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/bloc/product_efficiency_bloc.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/model/product_efficiency_model.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/service/product_efficiency_service.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/ui/product_efficiency_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ProductEfficiencyListPage extends StatelessWidget {
  const ProductEfficiencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductEfficiencyBloc(
        ProductEfficiencyService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetAllProducts(page: 1, search: '')),
      child: Builder(builder: (context) {
        return const ProductEfficiencyListPageChild();
      }),
    );
  }
}

class ProductEfficiencyListPageChild extends StatefulWidget {
  const ProductEfficiencyListPageChild({super.key});

  @override
  State<ProductEfficiencyListPageChild> createState() =>
      _ProductEfficiencyListPageChildState();
}

class _ProductEfficiencyListPageChildState
    extends State<ProductEfficiencyListPageChild> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<ProductEfficiencyModel> model = [];
  bool isLoadingMore = false;
  int currentPage = 1;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    context.read<ProductEfficiencyBloc>().add(
          GetAllProducts(page: currentPage, search: _searchController.text),
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
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كفاءة المنتجات'),
        ),
        body: Column(
          children: [
            SearchRow(
              textEditingController: _searchController,
              onSearch: () {
                model = [];
                currentPage = 1;
                runBloc();
              },
            ),
            Expanded(
              child:
                  BlocConsumer<ProductEfficiencyBloc, ProductEfficiencyState>(
                listener: (context, state) async {
                  if (state is ProductEfficiencyError) {
                    setState(() {
                      selectedIndex = null;
                    });
                    showSnackBar(
                      context: context,
                      content: 'حدث خطأ ما',
                      failure: true,
                    );
                  } else if (state is ProductEfficiencySuccess<
                      List<ProductEfficiencyModel>>) {
                    setState(() {
                      if (currentPage == 1) {
                        model = state.result;
                      } else {
                        model.addAll(state.result);
                      }
                      isLoadingMore = false;
                    });
                  } else if (state
                      is ProductEfficiencySuccess<ProductEfficiencyModel>) {
                    setState(() {
                      selectedIndex = null;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductEfficiencyPage(
                          model: state.result,
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProductEfficiencyInitial) {
                    return const SizedBox();
                  } else if (state is ProductEfficiencyLoading &&
                      currentPage == 1) {
                    return const Center(child: Loader());
                  } else if (state is ProductEfficiencyError) {
                    return const Center(child: Text('حدث خطأ ما'));
                  } else if (model.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('لا توجد منتجات لعرضها',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              )),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: model.length + 1,
                      itemBuilder: (context, index) {
                        if (index == model.length) {
                          return isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: Loader()),
                                )
                              : const SizedBox.shrink();
                        }

                        final screenWidth = MediaQuery.of(context).size.width;
                        final item = model[index];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            context.read<ProductEfficiencyBloc>().add(
                                  GetOneProduct(id: item.id),
                                );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: selectedIndex == index
                                ? const Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Center(child: Loader()),
                                  )
                                : ListTile(
                                    title: SizedBox(
                                      width: screenWidth * 0.20,
                                      child: Text(
                                        item.product ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.manufacturer ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    leading: SizedBox(
                                      width: screenWidth * 0.10,
                                      child: CircleAvatar(
                                        radius: 11,
                                        child: Text(
                                          item.type ?? '',
                                          style: const TextStyle(fontSize: 8),
                                        ),
                                      ),
                                    ),
                                    trailing: Text(
                                      NumberFormat('#,##0.00')
                                          .format(item.price_per_liter),
                                    ),
                                  ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
