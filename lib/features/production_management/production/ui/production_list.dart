import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
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

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

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
          final today = DateTime.now();
          final todayFormatted = _formatDate(today);

          // Initial load for Archive uses default dates
          bloc.add(SearchProductionArchivePagainted(
            page: 1,
            date1: '2025-01-01',
            date2: todayFormatted,
          ));
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
  int? count;
  List<String>? groups;

  String? _selectedType;
  String? _selectedTier;
  String? _selectedColor;

  // State for Date Filters
  DateTime _selectedDate1 = DateTime(2025, 1, 1);
  DateTime _selectedDate2 = DateTime.now();

  static const List<String> _types = [
    'زياتي فواتح',
    'مركز زياتي فواتح',
    'مركز زياتي غوامق',
    'زياتي غوامق',
    'أكرليك',
    'معجونة',
    'سواغ',
    'مركز مائي',
    'طرش',
    'نترو',
    'ديكورات + ملونات',
    'تفريغ',
    'صناعي',
  ];

  static const Map<String, List<String>> _typeTiers = {
    'زياتي فواتح': [
      'بروفيشنال لميع',
      'بروفيشنال نص لمعة',
      'بروفيشنال ربع لمعة',
      'بروفيشنال مت',
      'جمس لميع',
      'جمس نص لمعة',
      'جمس ربع لمعة',
      'جمس مت',
      'كلاسيك لميع',
      'كلاسيك نص لمعة',
      'كلاسيك ربع لمعة',
      'كلاسيك مت',
      '202 لميع',
      '202 نص لمعة',
      '202 مت',
      '101 لميع',
      '101 نص لمعة',
      '101 مت',
      'ايكو لميع',
      'ايكو نص لمعة',
      'ايكو مت',
      'لكر جمس',
      'لكر جمس نص لمعة',
      'لكر جمس مت',
      'لكر 202',
      'لكر 202 نص لمعة',
      'لكر 202 مت',
      'كلاسيك اندركوت',
      'جمس مميز',
      'زياتي 202 مميز ',
      'جمس ممدد',
      'زياتي 202 ممدد'
    ],
    'صناعي': [
      'جمس ألمنيوم',
      '202 ألمنيوم',
    ],
    'نترو': [
      'همروك',
      'جمس',
    ],
    'طرش': [
      'جمس',
      'كلاسيك',
      'سلر مائي ',
      '202',
      '101',
      'ايكو',
      'اقتصادي',
    ],
    'أكرليك': [
      'كلاسيك لميع',
      'كلاسيك نص لمعة',
      'كلاسيك ربع لمعة',
      'كلاسيك مت',
      'كلاسيك اندركوت',
      'كلاسيك ابتك',
      'جمس لميع',
      'جمس نص لمعة',
      'جمس ربع لمعة',
      'جمس مت',
      'جمس اندركوت',
      'كلاسيك ',
      'غراء',
      'أندركوت اقتصادي',
      'أندركوت لميع',
      'ايكو لميع',
      'ايكو نص لمعة',
      'ايكو اندركوت',
    ],
    'معجونة': [
      'كلاسيك ',
      'سماكات ',
    ],
    'ديكورات + ملونات': [
      'فيلفيت',
      'كنزي',
      'روعة',
      'فلور',
      'ديكو هوم',
      'غروب الشمس',
      'تكسير',
      'ستوكو',
      'جليز',
      'ديكو ميتال',
      'مائي',
      'منشف',
    ],
    'سواغ': [
      'زياتي ايكو',
      'محلول فيسكوجيل',
      'محلول فيسكوجيل أهرة',
      'محلول الكول ',
      'منشف',
      'زياتي ايكو بالكيد 90-638% ',
      'زياتي بالكيد 90-638% ',
    ],
    'مركز زياتي فواتح': [
      'بألكيد طويل',
      'بألكيد متوسط',
    ],
    'مركز زياتي غوامق': [
      'بألكيد طويل',
    ],
    'زياتي غوامق': [
      'جمس لميع',
      'جمس نص لمعة',
      'جمس ربع لمعة',
      'جمس مت',
      'كلاسيك لميع',
      'كلاسيك نص لمعة',
      'كلاسيك ربع لمعة',
      'كلاسيك مت',
      '202 لميع',
      '202 نص لمعة',
      '202 مت',
      '101 لميع',
      '101 نص لمعة',
      '101 مت',
      'ايكو لميع',
      'ايكو نص لمعة',
      'ايكو مت',
    ],
    'مركز مائي': [
      'جمس',
      'كلاسيك',
      '202',
      '101',
      'ايكو',
      'اكرليك جمس',
      'اكرليك كلاسيك',
    ],
    'تفريغ': ['جمس'],
  };

  static const List<String> colorSuggestions = [
    'أبيض',
    'نصف لمعة',
    'مت',
    'ربع لمعة',
    'أسود',
    'بني غامق',
    'بني فاتح',
    'بني غامق مت',
    'بني فاتح مت',
    'أخضر',
    'أخضر مت',
    'أصفر ل',
    'أصفر م',
    'أحمر',
    'أهرة',
    'عسلي',
    'كحلي',
    'كريم',
    'سيرقون أحمر',
    'سيرقون رمادي',
    'سيرقون أصفر',
    'سيرقون أسود',
    'سيرقون برتقالي',
    'ألماسي',
    'مارون',
    'أسود مت',
    'عسلي مت',
    'سلر',
    'لكر',
    'برونز',
    'ذهبي',
    'أزرق',
    '330',
    'بنفسجي',
    '210',
    'فضي',
    'المنيوم',
  ];

  // Helper to format date
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _selectedDate1 : _selectedDate2,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedDate1 = picked;
        } else {
          _selectedDate2 = picked;
        }
      });
    }
  }

  // Unified function to run the filter logic
  void _runFilter() {
    // 2. Clear current list and reset pagination
    setState(() {
      resultList.clear();
      currentPage = 1;
      isLoadingMore = false;
    });

    // Format dates to String for the BLoC event
    final String date1Formatted = _formatDate(_selectedDate1);
    final String date2Formatted = _formatDate(_selectedDate2);

    // Dispatch the search/filter event
    context.read<ProductionBloc>().add(SearchProductionArchivePagainted(
          search: _searchController.text,
          page: 1,
          date1: date1Formatted,
          date2: date2Formatted,
          type: _selectedType,
          tier: _selectedTier,
          color: _selectedColor,
        ));
  }

  @override
  void initState() {
    super.initState();
    _currentColorForPrefix = _darkThemeRed; // Initialize here
    _scrollController.addListener(_onScroll);
    // Initialize dates to match the initial load logic in ProductionList.build
    _selectedDate1 = DateTime(2025, 1, 1);
    _selectedDate2 = DateTime.now();
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
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);
    currentPage++;

    final String date1Formatted = _formatDate(_selectedDate1);
    final String date2Formatted = _formatDate(_selectedDate2);

    if (widget.type == 'Production') {
      context
          .read<ProductionBloc>()
          .add(GetBriefProductionPagainted(page: currentPage));
    } else if (widget.type == 'Archive') {
      // NOTE: Pass all current filter parameters when loading the next page
      context.read<ProductionBloc>().add(SearchProductionArchivePagainted(
            search: _searchController.text,
            page: currentPage,
            date1: date1Formatted,
            date2: date2Formatted,
            type: _selectedType,
            tier: _selectedTier,
            color: _selectedColor,
          ));
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

  // Refactored to use MyDropdownButton
  Widget _buildFilterDropdowns(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Filter 1: Type
          SizedBox(
            width: width * 0.3,
            child: MyDropdownButton(
              // Using MyDropdownButton
              value: _selectedType,
              labelText: 'النوع',
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('الكل'),
                ),
                ..._types.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                  _selectedTier = null; // Reset tier when type changes
                });
                // Filter is triggered by the button
              },
            ),
          ),
          const SizedBox(width: 8.0),

          // Filter 2: Tier (Conditional based on Type)
          SizedBox(
            width: width * 0.3,
            child: MyDropdownButton(
              // Using MyDropdownButton
              value: _selectedTier,
              labelText: 'الدرجة',
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('الكل'),
                ),
                if (_selectedType != null &&
                    _typeTiers.containsKey(_selectedType))
                  ..._typeTiers[_selectedType]!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTier = newValue;
                });
                // Filter is triggered by the button
              },
              isEnabled:
                  _selectedType != null, // Disable if Type isn't selected
            ),
          ),
          const SizedBox(width: 8.0),

          // Filter 3: Color
          SizedBox(
            width: width * 0.3,
            child: MyDropdownButton(
              // Using MyDropdownButton
              value: _selectedColor,
              labelText: 'اللون',
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('الكل'),
                ),
                ...colorSuggestions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedColor = newValue;
                });
                // Filter is triggered by the button
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Date Pickers and Filter Button
  Widget _buildDateAndFilterControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          // Date 1 (Start Date) Picker
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'من: ${_formatDate(_selectedDate1)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // Date 2 (End Date) Picker
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'إلى: ${_formatDate(_selectedDate2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // Filter Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: _runFilter,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(80, 48),
              ),
              child: const Text('تصفية', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    width = MediaQuery.of(context).size.width;
    AppUserState userState = context.watch<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      groups = userState.userEntity.groups;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Row(
            children: [
              Text(
                widget.type == 'Production'
                    ? 'برنامج الإنتاج'
                    : 'أرشيف الإنتاج',
                style: const TextStyle(color: Colors.white),
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
        body: Column(
          children: [
            if (widget.type == 'Archive') ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchRow(
                  textEditingController: _searchController,
                  // UPDATED: Call the unified filter function
                  onSearch: _runFilter,
                ),
              ),
              // Filter Dropdowns
              _buildFilterDropdowns(context),
              // Date Pickers and Filter Button
              _buildDateAndFilterControls(context),
            ],
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
                  if (state is ProductionSuccess<PageintedResult>) {
                    bool shouldRebuildAppBar = false;
                    if (count == null ||
                        currentPage == 1 ||
                        state.result.totalCount! > 0) {
                      shouldRebuildAppBar = count != state.result.totalCount;
                      count = state.result.totalCount;
                    }
                    if (currentPage == 1) {
                      resultList =
                          state.result.results.cast<BriefProductionModel>();
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
}
