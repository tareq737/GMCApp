import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final String type;
  const FullProdPageChild({super.key, required this.type});

  @override
  State<FullProdPageChild> createState() => _FullProdPageChildState();
}

class _FullProdPageChildState extends State<FullProdPageChild> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Color _darkThemeRed = Colors.red.shade700;
  final Color _darkThemeBlue = Colors.blue.shade700;
  double width = 0;
  final Map<String, Color> _prefixColors = {};
  late Color _currentColorForPrefix;

  int currentPage = 1;
  bool isLoadingMore = false;
  List<BriefProductionModel> resultList = [];
  List<String>? groups;

  @override
  void initState() {
    super.initState();
    _currentColorForPrefix = _darkThemeRed; // Initialize here
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent *
                0.9 && // Trigger near the end
        !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() => isLoadingMore = true);
    currentPage++;

    if (widget.type == 'Production') {
      context
          .read<ProductionBloc>()
          .add(GetBriefProductionPagainted(page: currentPage));
    } else if (widget.type == 'Archive') {
      context.read<ProductionBloc>().add(SearchProductionArchivePagainted(
          page: currentPage, search: _searchController.text));
    }
  }

  String _getBatchNumberPrefix(String batchNumber) {
    final RegExp regExp = RegExp(r'^([A-Za-z]+)');
    final Match? match = regExp.firstMatch(batchNumber);
    return match?.group(0) ?? '';
  }

  Color _getBatchNumberColor(String batchNumber) {
    final prefix = _getBatchNumberPrefix(batchNumber);
    if (prefix.isEmpty) return Colors.blueGrey;
    if (!_prefixColors.containsKey(prefix)) {
      _prefixColors[prefix] = _currentColorForPrefix;
      _currentColorForPrefix = (_currentColorForPrefix == _darkThemeRed)
          ? _darkThemeBlue
          : _darkThemeRed;
    }
    return _prefixColors[prefix]!;
  }

  Widget _buildCheckIcon(String department, bool? checkValue,
      {double size = 14}) {
    IconData icon;
    switch (department) {
      case 'raw_material':
        icon = FontAwesomeIcons.boxesStacked;
        break;
      case 'manufacturing':
        icon = FontAwesomeIcons.industry;
        break;
      case 'lab':
        icon = FontAwesomeIcons.flaskVial;
        break;
      case 'empty_packaging':
        icon = FontAwesomeIcons.boxOpen;
        break;
      case 'packaging':
        icon = FontAwesomeIcons.boxesPacking;
        break;
      case 'finished_goods':
        icon = FontAwesomeIcons.cubes;
        break;
      default:
        icon = FontAwesomeIcons.circleQuestion;
    }
    return FaIcon(
      icon,
      color: checkValue == true ? Colors.green : Colors.grey,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    AppUserState userState = context.watch<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      groups = userState.userEntity.groups;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.type == 'Production' ? 'برنامج الإنتاج' : 'أرشيف الإنتاج'),
          actions: [
            if (widget.type == 'Production')
              IconButton(
                onPressed: () {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchRow(
                  textEditingController: _searchController,
                  onSearch: () {
                    setState(() {
                      resultList.clear();
                      currentPage = 1;
                      isLoadingMore = false;
                    });
                    context.read<ProductionBloc>().add(
                        SearchProductionArchivePagainted(
                            search: _searchController.text, page: 1));
                  },
                ),
              ),
            Expanded(
              child: BlocConsumer<ProductionBloc, ProductionState>(
                listener: (context, state) {
                  if (state is ProductionError) {
                    setState(() => isLoadingMore = false);
                    showSnackBar(
                        context: context, content: 'حدث خطأ ما', failure: true);
                  } else if (state is ProductionSuccess<FullProductionModel>) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductionFullDataPage(
                        fullProductionModel: state.result,
                        type: widget.type,
                      );
                    }));
                  } else if (state is ProductionSuccess<String>) {
                    showSnackBar(
                        context: context,
                        content: state.result,
                        failure: false);
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
                  if (state is ProductionLoading && resultList.isEmpty) {
                    return const Loader();
                  }

                  if (state is ProductionSuccess<List<BriefProductionModel>>) {
                    if (currentPage == 1) {
                      resultList = state.result;
                    } else {
                      resultList.addAll(state.result);
                    }
                    isLoadingMore = false;
                  }

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

                  // Use OrientationBuilder to switch between layouts
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == Orientation.landscape) {
                        return _buildProdPlanGrid(context, resultList);
                      } else {
                        return _buildProdPlanList(context, resultList);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PORTRAIT LAYOUT: Your original ListView ---
  Widget _buildProdPlanList(
      BuildContext context, List<BriefProductionModel> briefProductionModel) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: briefProductionModel.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == briefProductionModel.length) {
          return const Padding(
              padding: EdgeInsets.all(16.0), child: Center(child: Loader()));
        }

        final item = briefProductionModel[index];
        final batchColor = _getBatchNumberColor(item.batch_number ?? '');

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            onTap: () {
              if (widget.type == 'Production') {
                context
                    .read<ProductionBloc>()
                    .add(GetOneProductionByID(id: item.id!));
              } else if (widget.type == 'Archive') {
                context
                    .read<ProductionBloc>()
                    .add(GetOneProductionArchiveByID(id: item.id!));
              }
            },
            title: Text(
              "${item.type} - ${item.tier}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              children: [
                Text(item.color ?? '', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 5),
                if (widget.type == 'Production')
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4.0,
                    children: [
                      _buildCheckIcon(
                          'raw_material', item.raw_material_check_4),
                      _buildCheckIcon(
                          'manufacturing', item.manufacturing_check_6),
                      _buildCheckIcon('lab', item.lab_check_6),
                      _buildCheckIcon(
                          'empty_packaging', item.empty_packaging_check_5),
                      _buildCheckIcon('packaging', item.packaging_check_6),
                      _buildCheckIcon(
                          'finished_goods', item.finished_goods_check_3),
                    ],
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    item.total_weight != null
                        ? '${item.total_weight!.toStringAsFixed(2)} KG'
                        : '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500)),
                Text(
                    item.total_volume != null
                        ? '${item.total_volume!.toStringAsFixed(2)} L'
                        : '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: batchColor,
                  child: Text(item.id.toString(),
                      style: const TextStyle(fontSize: 8, color: Colors.white)),
                ),
                const SizedBox(height: 4),
                Text(item.batch_number ?? '',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: batchColor)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProdPlanGrid(
      BuildContext context, List<BriefProductionModel> briefProductionModel) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.7,
      ),
      itemCount: briefProductionModel.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == briefProductionModel.length) {
          return const Center(child: Loader());
        }
        final item = briefProductionModel[index];
        final batchColor = _getBatchNumberColor(item.batch_number ?? '');
        return _ProductionGridItem(
          item: item,
          batchColor: batchColor,
          type: widget.type,
          onTap: () {
            if (widget.type == 'Production') {
              context
                  .read<ProductionBloc>()
                  .add(GetOneProductionByID(id: item.id!));
            } else if (widget.type == 'Archive') {
              context
                  .read<ProductionBloc>()
                  .add(GetOneProductionArchiveByID(id: item.id!));
            }
          },
        );
      },
    );
  }
}

// --- NEW WIDGET: Custom card for the GridView ---
class _ProductionGridItem extends StatelessWidget {
  final BriefProductionModel item;
  final Color batchColor;
  final String type;
  final VoidCallback onTap;

  const _ProductionGridItem({
    required this.item,
    required this.batchColor,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: batchColor,
                        child: Text(item.id.toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.batch_number ?? '',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: batchColor),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          item.total_weight != null
                              ? '${item.total_weight!.toStringAsFixed(1)} KG'
                              : '',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(
                          item.total_volume != null
                              ? '${item.total_volume!.toStringAsFixed(1)} L'
                              : '',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Middle: Title and Color
              Text("${item.type} - ${item.tier}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text(
                item.color ?? '',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Bottom: Status Icons
              if (type == 'Production')
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  children: [
                    _buildCheckIcon('raw_material', item.raw_material_check_4),
                    _buildCheckIcon(
                        'manufacturing', item.manufacturing_check_6),
                    _buildCheckIcon('lab', item.lab_check_6),
                    _buildCheckIcon(
                        'empty_packaging', item.empty_packaging_check_5),
                    _buildCheckIcon('packaging', item.packaging_check_6),
                    _buildCheckIcon(
                        'finished_goods', item.finished_goods_check_3),
                  ],
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // Duplicating this helper here for encapsulation
  Widget _buildCheckIcon(String department, bool? checkValue,
      {double size = 16}) {
    IconData icon;
    switch (department) {
      case 'raw_material':
        icon = FontAwesomeIcons.boxesStacked;
        break;
      case 'manufacturing':
        icon = FontAwesomeIcons.industry;
        break;
      case 'lab':
        icon = FontAwesomeIcons.flaskVial;
        break;
      case 'empty_packaging':
        icon = FontAwesomeIcons.boxOpen;
        break;
      case 'packaging':
        icon = FontAwesomeIcons.boxesPacking;
        break;
      case 'finished_goods':
        icon = FontAwesomeIcons.cubes;
        break;
      default:
        icon = FontAwesomeIcons.circleQuestion;
    }
    return FaIcon(
      icon,
      color: checkValue == true ? Colors.green : Colors.grey,
      size: size,
    );
  }
}
