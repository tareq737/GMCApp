import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/brief_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_full_data_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ListProductionFiltered extends StatelessWidget {
  final String status;
  final String type;
  final String date_1;
  final String date_2;
  final String timeliness;
  const ListProductionFiltered(
      {super.key,
      required this.status,
      required this.type,
      required this.date_1,
      required this.date_2,
      required this.timeliness});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductionBloc(ProductionServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetProductionFilter(
            page: 1,
            status: status,
            type: type,
            date_1: date_1,
            date_2: date_2,
            timeliness: timeliness,
          ),
        ),
      child: Builder(builder: (context) {
        return ListProductionFilteredChild(
          status: status,
          type: type,
          date_1: date_1,
          date_2: date_2,
          timeliness: timeliness,
        );
      }),
    );
  }
}

class ListProductionFilteredChild extends StatefulWidget {
  final String status;
  final String type;
  final String date_1;
  final String date_2;
  final String timeliness;
  const ListProductionFilteredChild(
      {super.key,
      required this.status,
      required this.type,
      required this.date_1,
      required this.date_2,
      required this.timeliness});

  @override
  State<ListProductionFilteredChild> createState() =>
      _ListProductionFilteredChildState();
}

class _ListProductionFilteredChildState
    extends State<ListProductionFilteredChild> {
  final ScrollController _scrollController = ScrollController();
  final Color _darkThemeRed = Colors.red.shade700;
  final Color _darkThemeBlue = Colors.blue.shade700;
  final Map<String, Color> _prefixColors = {};
  Color _currentColorForPrefix = Colors.red.shade700;
  int currentPage = 1;
  bool isLoadingMore = false;
  List<BriefProductionModel> resultList = [];
  List<String>? groups;
  int? count;
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
    context.read<ProductionBloc>().add(
          GetProductionFilter(
            page: currentPage,
            status: widget.status,
            type: widget.type,
            date_1: widget.date_1,
            date_2: widget.date_2,
            timeliness: widget.timeliness,
          ),
        );
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
  Widget _buildCheckIcon(String department, bool? checkValue) {
    IconData icon;

    switch (department) {
      case 'raw_material':
        icon = FontAwesomeIcons.boxesStacked; // مواد أولية
        break;
      case 'manufacturing':
        icon = FontAwesomeIcons.industry; // تصنيع
        break;
      case 'lab':
        icon = FontAwesomeIcons.flaskVial; // مخبر
        break;
      case 'empty_packaging':
        icon = FontAwesomeIcons.boxOpen; // فوارغ
        break;
      case 'packaging':
        icon = FontAwesomeIcons.boxesPacking; // تعبئة
        break;
      case 'finished_goods':
        icon = FontAwesomeIcons.cubes; // مواد جاهزة
        break;
      default:
        icon = FontAwesomeIcons.circleQuestion; // fallback
    }

    return FaIcon(
      icon,
      color: checkValue == true ? Colors.green : Colors.grey,
      size: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Row(
            children: [
              Text(
                widget.type == "oil_based"
                    ? "طبخات الزياتي المنفذة"
                    : widget.type == "water_based"
                        ? "طبخات الطرش المنفذة"
                        : widget.type == "acrylic"
                            ? "طبخات الأكريليك المنفذة"
                            : widget.type == "other"
                                ? "طبخات أخرى منفذة"
                                : widget.timeliness == "on_time"
                                    ? "طبخات منفذة في الوقت"
                                    : widget.timeliness == "late"
                                        ? "طبخات متأخرة"
                                        : widget.status == ""
                                            ? "طبخات الإنتاج المدرجة"
                                            : widget.status == "pending"
                                                ? "طبخات الإنتاج قيد التنفيذ"
                                                : widget.status == "finished"
                                                    ? "الطبخات المنفذة"
                                                    : "إحصائيات الإنتاج",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (count != null)
                MyCircleAvatar(
                  text: count.toString(),
                ),
            ],
          ),
        ),
        body: BlocConsumer<ProductionBloc, ProductionState>(
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
                      type: 'Production',
                    );
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductionLoading && currentPage == 1) {
              return const Loader();
            }
            // Update resultList on successful data fetch
            // else if (state is ProductionSuccess<List<BriefProductionModel>>) {
            //   // If it's the first page, replace the list; otherwise, add to it
            //   if (currentPage == 1) {
            //     resultList = state.result;
            //   } else {
            //     resultList.addAll(state.result);
            //   }
            //   isLoadingMore = false; // Stop loading more
            // }
            else if (state is ProductionSuccess<PageintedResult>) {
              bool shouldRebuildAppBar = false;
              if (count == null ||
                  currentPage == 1 ||
                  state.result.totalCount! > 0) {
                shouldRebuildAppBar = count != state.result.totalCount;
                count = state.result.totalCount;
              }
              if (currentPage == 1) {
                resultList = state.result.results.cast<BriefProductionModel>();
              } else {
                final newResults =
                    state.result.results.cast<BriefProductionModel>();
                if (newResults.isNotEmpty) {
                  resultList.addAll(newResults);
                }
              }
              isLoadingMore = false;

              if (shouldRebuildAppBar) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {});
                  }
                });
              }
            }

            // Handle cases where resultList might be empty after an initial load or search
            if (resultList.isEmpty && state is! ProductionLoading) {
              return const Center(
                child: Text(
                  'لا يوجد طبخات إنتاج لعرضها.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }

            // Display the list or loading indicator at the bottom
            return _buildProdPlanList(context, resultList);
          },
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
        return TweenAnimationBuilder<double>(
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
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              onTap: () {
                context.read<ProductionBloc>().add(
                      GetOneProductionArchiveByID(
                          id: briefProductionModel[index].id!),
                    );
              },
              title: Text(
                "${briefProductionModel[index].type} - ${briefProductionModel[index].tier}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                  Wrap(
                    // Use Wrap to allow icons to wrap if space is limited
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Space between icons
                    runSpacing: 2.0, // Space between lines of icons
                    children: [
                      _buildCheckIcon('raw_material',
                          briefProductionModel[index].raw_material_check_4),
                      _buildCheckIcon('manufacturing',
                          briefProductionModel[index].manufacturing_check_6),
                      _buildCheckIcon(
                          'lab', briefProductionModel[index].lab_check_6),
                      _buildCheckIcon('empty_packaging',
                          briefProductionModel[index].empty_packaging_check_5),
                      _buildCheckIcon('packaging',
                          briefProductionModel[index].packaging_check_6),
                      _buildCheckIcon('finished_goods',
                          briefProductionModel[index].finished_goods_check_3),
                    ],
                  ),
                ],
              ),
              trailing: SizedBox(
                width: screenWidth * 0.20,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Weight
                      Text(
                        briefProductionModel[index].total_weight != null
                            ? '${briefProductionModel[index].total_weight!.toStringAsFixed(2)} KG'
                            : '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),

                      // Volume
                      Text(
                        briefProductionModel[index].total_volume != null
                            ? '${briefProductionModel[index].total_volume!.toStringAsFixed(2)} L'
                            : '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),

                      // Duration
                      Text(
                        briefProductionModel[index].duration != null
                            ? '${briefProductionModel[index].duration} أيام'
                            : 'قيد التنفيذ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              briefProductionModel[index].duration != null &&
                                      briefProductionModel[index].duration! > 3
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color: briefProductionModel[index].duration != null &&
                                  briefProductionModel[index].duration! > 3
                              ? Colors.red
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  SizedBox(
                    width: screenWidth * 0.10,
                    child: CircleAvatar(
                      radius: 12, // Slightly larger for better visibility
                      backgroundColor: batchColor,
                      child: Text(
                        briefProductionModel[index].id.toString(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 8, color: Colors.white),
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
          ),
        );
      },
    );
  }
}
