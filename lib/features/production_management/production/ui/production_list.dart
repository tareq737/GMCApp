import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/brief_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_full_data_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ProductionList extends StatelessWidget {
  final String type;
  const ProductionList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ProductionBloc(
          ProductionServices(
            apiClient: getIt<ApiClient>(),
            authInteractor: getIt<AuthInteractor>(),
          ),
        );

        if (type == 'Production') {
          bloc.add(GetBriefProductionPagainted(page: 1));
        } else if (type == 'Archive') {
          // Also fetch archive on initial load if type is Archive
          bloc.add(SearchProductionArchivePagainted(page: 1, search: ''));
        }

        return bloc;
      },
      child: Builder(builder: (context) {
        return FullProdPageChild(type: type);
      }),
    );
  }
}

class FullProdPageChild extends StatefulWidget {
  String type;
  FullProdPageChild({super.key, required this.type});

  @override
  State<FullProdPageChild> createState() => _FullProdPageChildState();
}

class _FullProdPageChildState extends State<FullProdPageChild> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Color _darkThemeRed = Colors.red.shade700; // A richer, darker red
  final Color _darkThemeBlue = Colors.blue.shade700; // A deeper blue

  // This map will store the last assigned color for each batch prefix
  final Map<String, Color> _prefixColors = {};
  Color _currentColorForPrefix =
      Colors.red.shade700; // Start with the new dark theme red

  int currentPage = 1;
  bool isLoadingMore = false;
  List<BriefProductionModel> resultList = [];
  List<String>? groups;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Only load more if not currently loading and at the bottom of the scroll
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;

    if (widget.type == 'Production') {
      context.read<ProductionBloc>().add(
            GetBriefProductionPagainted(page: currentPage),
          );
    } else if (widget.type == 'Archive') {
      context.read<ProductionBloc>().add(
            SearchProductionArchivePagainted(
                page: currentPage, search: _searchController.text),
          );
    }
  }

  String _getBatchNumberPrefix(String batchNumber) {
    final RegExp regExp = RegExp(r'^([A-Za-z]+)');
    final Match? match = regExp.firstMatch(batchNumber);
    return match?.group(0) ?? '';
  }

  // Helper function to get the color for a given batch prefix
  Color _getBatchNumberColor(String batchNumber) {
    final prefix = _getBatchNumberPrefix(batchNumber);

    if (prefix.isEmpty) {
      return Colors.blueGrey; // Default color if no prefix found
    }

    if (!_prefixColors.containsKey(prefix)) {
      _prefixColors[prefix] = _currentColorForPrefix;
      // Toggle between the new dark theme red and blue
      _currentColorForPrefix = (_currentColorForPrefix == _darkThemeRed)
          ? _darkThemeBlue
          : _darkThemeRed;
    }
    return _prefixColors[prefix]!;
  }

  // Placeholder for _buildCheckIcon
  Widget _buildCheckIcon(bool? checkValue) {
    if (checkValue == true) {
      return const Icon(Icons.check, color: Colors.green, size: 16);
    } else if (checkValue == false) {
      return const Icon(Icons.check, color: Colors.red, size: 16);
    } else {
      return const Icon(Icons.check, color: Colors.red, size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppUserState state = context.watch<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.type == 'Production' ? 'برنامج الإنتاج' : 'أرشيف الإنتاج',
          ),
          actions: [
            if (widget.type == 'Production')
              IconButton(
                onPressed: () {
                  // Reset to first page and clear existing results before refreshing
                  setState(() {
                    resultList.clear();
                    currentPage = 1;
                    isLoadingMore = false;
                  });
                  context
                      .read<ProductionBloc>()
                      .add(GetBriefProductionPagainted(page: 1));
                },
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
        body: Column(
          children: [
            if (widget.type == 'Archive')
              SizedBox(
                height: 80,
                child: SearchRow(
                  textEditingController: _searchController,
                  onSearch: () {
                    setState(() {
                      resultList.clear(); // Clear the existing data
                      currentPage = 1; // Reset to first page
                      isLoadingMore = false; // Reset loading state
                    });
                    context.read<ProductionBloc>().add(
                          SearchProductionArchivePagainted(
                              search: _searchController.text, page: 1),
                        );
                  },
                ),
              ),
            Expanded(
              child: BlocConsumer<ProductionBloc, ProductionState>(
                listener: (context, state) {
                  if (state is ProductionError) {
                    // Reset isLoadingMore on error to allow retrying
                    setState(() {
                      isLoadingMore = false;
                    });
                    showSnackBar(
                      context: context,
                      content: 'حدث خطأ ما',
                      failure: true,
                    );
                  } else if (state is ProductionSuccess<FullProductionModel>) {
                    // Navigate to full data page for both Production and Archive types
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductionFullDataPage(
                            fullProductionModel: state.result,
                            type: widget.type,
                          );
                        },
                      ),
                    );
                  } else if (state is ProductionSuccess<String>) {
                    // Handle the success message for archiving
                    showSnackBar(
                      context: context,
                      content: state.result, // Display the success message
                      failure: false,
                    );
                    // You might want to refresh the list after archiving if needed
                    // For example, if the archived item should disappear from the "Production" list
                    if (widget.type == 'Production') {
                      setState(() {
                        resultList.clear();
                        currentPage = 1;
                        isLoadingMore = false;
                      });
                      context
                          .read<ProductionBloc>()
                          .add(GetBriefProductionPagainted(page: 1));
                    }
                  }
                },
                builder: (context, state) {
                  if (state is ProductionLoading && currentPage == 1) {
                    return const Loader();
                  }
                  // Update resultList on successful data fetch
                  else if (state
                      is ProductionSuccess<List<BriefProductionModel>>) {
                    // If it's the first page, replace the list; otherwise, add to it
                    if (currentPage == 1) {
                      resultList = state.result;
                    } else {
                      resultList.addAll(state.result);
                    }
                    isLoadingMore = false; // Stop loading more
                  }

                  // Handle cases where resultList might be empty after an initial load or search
                  if (resultList.isEmpty && state is! ProductionLoading) {
                    return Center(
                      child: Text(
                        widget.type == 'Production'
                            ? 'لا يوجد طبخات إنتاج لعرضها.'
                            : _searchController.text.isNotEmpty
                                ? 'لا توجد نتائج بحث لـ "${_searchController.text}"'
                                : 'لا يوجد أرشيف إنتاج لعرضه.',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // Display the list or loading indicator at the bottom
                  return _buildProdPlanList(context, resultList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProdPlanList(
      BuildContext context, List<BriefProductionModel> briefProductionModel) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: briefProductionModel.length +
          (isLoadingMore ? 1 : 0), // Add 1 for the loading indicator
      itemBuilder: (context, index) {
        if (index == briefProductionModel.length) {
          // Show loading indicator at the bottom if more data is being loaded
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Loader()),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final String currentBatchNumber =
            briefProductionModel[index].batch_number ?? '';
        final Color batchColor = _getBatchNumberColor(currentBatchNumber);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            onTap: () {
              if (widget.type == 'Production') {
                context.read<ProductionBloc>().add(
                      GetOneProductionByID(id: briefProductionModel[index].id!),
                    );
              } else if (widget.type == 'Archive') {
                context.read<ProductionBloc>().add(
                      GetOneProductionArchiveByID(
                          id: briefProductionModel[index].id!),
                    );
              }
            },
            title: Text(
              "${briefProductionModel[index].type} - ${briefProductionModel[index].tier}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the content
              children: [
                const SizedBox(height: 5),
                Text(
                  briefProductionModel[index].color ?? 'No Color',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                if (widget.type == 'Production')
                  Wrap(
                    // Use Wrap to allow icons to wrap if space is limited
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Space between icons
                    runSpacing: 2.0, // Space between lines of icons
                    children: [
                      _buildCheckIcon(
                          briefProductionModel[index].raw_material_check_4),
                      _buildCheckIcon(
                          briefProductionModel[index].manufacturing_check_6),
                      _buildCheckIcon(briefProductionModel[index].lab_check_6),
                      _buildCheckIcon(
                          briefProductionModel[index].empty_packaging_check_5),
                      _buildCheckIcon(
                          briefProductionModel[index].packaging_check_6),
                      _buildCheckIcon(
                          briefProductionModel[index].finished_goods_check_3),
                    ],
                  ),
              ],
            ),
            trailing: SizedBox(
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align to end for numbers
                children: [
                  Text(
                    briefProductionModel[index].total_weight != null
                        ? '${briefProductionModel[index].total_weight!.toStringAsFixed(2)} KG'
                        : '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    briefProductionModel[index].total_volume != null
                        ? '${briefProductionModel[index].total_volume!.toStringAsFixed(2)} L'
                        : '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                SizedBox(
                  width: screenWidth * 0.10,
                  child: CircleAvatar(
                    radius: 12, // Slightly larger for better visibility
                    backgroundColor: batchColor,
                    child: Text(
                      briefProductionModel[index].id.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 8, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  briefProductionModel[index].batch_number ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.bold, // Make it bold for more emphasis
                    color: _getBatchNumberColor(
                        briefProductionModel[index].batch_number ?? ''),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
