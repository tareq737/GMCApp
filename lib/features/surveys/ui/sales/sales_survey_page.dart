// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/common/widgets/searchable_dropdown.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/navigate_with_animate.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/surveys/bloc/surveys_bloc.dart';
import 'package:gmcappclean/features/surveys/models/sales/pros_cons_model.dart';
import 'package:gmcappclean/features/surveys/models/sales/sales_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/lists/brands.dart';
import 'package:gmcappclean/features/surveys/ui/sales/list_sales_survey_page.dart';
import 'package:gmcappclean/features/surveys/ui/widgets/dynamic_pie_chart.dart';
import 'package:gmcappclean/features/surveys/ui/widgets/multi_selection_chips.dart';
import 'package:gmcappclean/features/surveys/ui/widgets/store_items_pie_chart.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class SalesSurveyPage extends StatelessWidget {
  final SalesModel? salesModel;
  SalesSurveyPage({
    super.key,
    this.salesModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SurveysBloc(SurveysServices(
            apiClient: getIt<ApiClient>(),
            authInteractor: getIt<AuthInteractor>(),
          )),
        ),
        BlocProvider(
          create: (context) => getIt<SalesBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return SalesSurveyPageChild(salesModel: salesModel);
        },
      ),
    );
  }
}

class SalesSurveyPageChild extends StatefulWidget {
  final SalesModel? salesModel;
  SalesSurveyPageChild({
    super.key,
    this.salesModel,
  });

  @override
  State<SalesSurveyPageChild> createState() => _SalesSurveyPageChildState();
}

class _SalesSurveyPageChildState extends State<SalesSurveyPageChild>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _applicantNameController = TextEditingController();
  final _searchController = TextEditingController();
  int? customerID;
  final _customerNamerController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _regionNameController = TextEditingController();
  final _dateController = TextEditingController();

  // Group 1: Business Types
  final _healthyPercentageController = TextEditingController(text: '0');
  final _paintsPercentageController = TextEditingController(text: '0');
  final _hardwarePercentageController = TextEditingController(text: '0');
  final _electricalPercentageController = TextEditingController(text: '0');
  final _buildingMaterialsPercentageController =
      TextEditingController(text: '0');

  // Group 2: Market Growth
  final _ratingCurrentYearController = TextEditingController();
  final _ratingLastYearController = TextEditingController();
  final _ratingTwoYearsAgoController = TextEditingController();
  final _ratingThreeYearsAgoController = TextEditingController();

  // Group 3: Oil vs Water
  final _oilPaintsSoldPrecentageController = TextEditingController(text: '0');
  final _emulPaintsSoldPrecentageController = TextEditingController(text: '0');

  // Group 4: Oil Sub-types
  final _oilPaintsSlowPrecentageController = TextEditingController(text: '0');
  final _oilPaintsSlowBestPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsSlowMidPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsSlowEcoPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsFastPrecentageController = TextEditingController(text: '0');
  final _oilPaintsFastBestPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsFastMidPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsFastEcoPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsIndPrecentageController = TextEditingController(text: '0');
  final _oilPaintsIndBestPrecentageController =
      TextEditingController(text: '0');
  final _oilPaintsIndMidPrecentageController = TextEditingController(text: '0');
  final _oilPaintsIndEcoPrecentageController = TextEditingController(text: '0');

  // Group 5: Water Sub-types
  final _emulPaintsWaterPrecentageController = TextEditingController(text: '0');
  final _emulPaintsWaterBestPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsWaterMidPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsWaterEcoPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsAcrylicPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsAcrylicBestPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsAcrylicMidPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsAcrylicEcoPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsDecoPuttyPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsDecoPuttyBestPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsDecoPuttyMidPrecentageController =
      TextEditingController(text: '0');
  final _emulPaintsDecoPuttyEcoPrecentageController =
      TextEditingController(text: '0');

  // Brand Controllers
  final _oilPaintsSlowBestBrandController = TextEditingController();
  final _oilPaintsSlowMidBrandController = TextEditingController();
  final _oilPaintsSlowEcoBrandController = TextEditingController();
  final _oilPaintsFastBestBrandController = TextEditingController();
  final _oilPaintsFastMidBrandController = TextEditingController();
  final _oilPaintsFastEcoBrandController = TextEditingController();
  final _oilPaintsIndBestBrandController = TextEditingController();
  final _oilPaintsIndMidBrandController = TextEditingController();
  final _oilPaintsIndEcoBrandController = TextEditingController();
  final _emulPaintsWaterBestBrandController = TextEditingController();
  final _emulPaintsWaterMidBrandController = TextEditingController();
  final _emulPaintsWaterEcoBrandController = TextEditingController();
  final _emulPaintsAcrylicBestBrandController = TextEditingController();
  final _emulPaintsAcrylicMidBrandController = TextEditingController();
  final _emulPaintsAcrylicEcoBrandController = TextEditingController();
  final _emulPaintsDecoPuttyBestBrandController = TextEditingController();
  final _emulPaintsDecoPuttyMidBrandController = TextEditingController();
  final _emulPaintsDecoPuttyEcoBrandController = TextEditingController();

  final _notesController = TextEditingController();

  // Lists
  List<String> presentBrands = [];
  List<String> newBrands = [];
  List<String> decliningBrands = [];
  List<int> companyAdvantages = [];
  List<int> companyDisadvantages = [];
  List<ProsConsItem> prosList = [];
  List<ProsConsItem> consList = [];
  bool _customerSelectedFromSearch = false;
  late List<String> listApplicantName;
  late List<String> listBrands;

  // Tab Controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurveysBloc>().add(GetProsAndCons());
    });

    if (widget.salesModel != null) {
      _loadDataFromModel();
    }

    listApplicantName = [
      'محمد العمر',
      'أحمد الناصري',
      'عبد الله عويد',
      'أحمد الصياد',
      'هادي السهلي'
    ];
    listBrands = Brands.brands;
  }

  void _loadDataFromModel() {
    _applicantNameController.text = widget.salesModel!.applicant_name ?? '';
    _customerNamerController.text = widget.salesModel!.customer_name ?? '';
    _shopNameController.text = widget.salesModel!.shop_name ?? '';
    _regionNameController.text = widget.salesModel!.region_name ?? '';
    customerID = widget.salesModel!.customer;
    _customerSelectedFromSearch = widget.salesModel!.customer != null;
    _dateController.text = widget.salesModel!.date ?? '';

    // Business Types
    _healthyPercentageController.text =
        widget.salesModel!.healthy_percentage?.toString() ?? '0';
    _paintsPercentageController.text =
        widget.salesModel!.paints_percentage?.toString() ?? '0';
    _hardwarePercentageController.text =
        widget.salesModel!.hardware_percentage?.toString() ?? '0';
    _electricalPercentageController.text =
        widget.salesModel!.electrical_percentage?.toString() ?? '0';
    _buildingMaterialsPercentageController.text =
        widget.salesModel!.building_materials_percentage?.toString() ?? '0';

    // Market Growth
    _ratingCurrentYearController.text =
        widget.salesModel!.rating_current_year?.toString() ?? '';
    _ratingLastYearController.text =
        widget.salesModel!.rating_last_year?.toString() ?? '';
    _ratingTwoYearsAgoController.text =
        widget.salesModel!.rating_two_years_ago?.toString() ?? '';
    _ratingThreeYearsAgoController.text =
        widget.salesModel!.rating_three_years_ago?.toString() ?? '';

    // Oil vs Water
    _oilPaintsSoldPrecentageController.text =
        widget.salesModel!.oil_paints_sold_precentage?.toString() ?? '0';
    _emulPaintsSoldPrecentageController.text =
        widget.salesModel!.emul_paints_sold_precentage?.toString() ?? '0';

    // Oil Sub-types
    _oilPaintsSlowPrecentageController.text =
        widget.salesModel!.oil_paints_slow_percentage?.toString() ?? '0';
    _oilPaintsSlowBestPrecentageController.text =
        widget.salesModel!.oil_paints_slow_best_percenatge?.toString() ?? '0';
    _oilPaintsSlowMidPrecentageController.text =
        widget.salesModel!.oil_paints_slow_mid_percenatge?.toString() ?? '0';
    _oilPaintsSlowEcoPrecentageController.text =
        widget.salesModel!.oil_paints_slow_eco_percenatge?.toString() ?? '0';
    _oilPaintsFastPrecentageController.text =
        widget.salesModel!.oil_paints_fast_percentage?.toString() ?? '0';
    _oilPaintsFastBestPrecentageController.text =
        widget.salesModel!.oil_paints_fast_best_percenatge?.toString() ?? '0';
    _oilPaintsFastMidPrecentageController.text =
        widget.salesModel!.oil_paints_fast_mid_percenatge?.toString() ?? '0';
    _oilPaintsFastEcoPrecentageController.text =
        widget.salesModel!.oil_paints_fast_eco_percenatge?.toString() ?? '0';
    _oilPaintsIndPrecentageController.text =
        widget.salesModel!.oil_paints_ind_percentage?.toString() ?? '0';
    _oilPaintsIndBestPrecentageController.text =
        widget.salesModel!.oil_paints_ind_best_percenatge?.toString() ?? '0';
    _oilPaintsIndMidPrecentageController.text =
        widget.salesModel!.oil_paints_ind_mid_percenatge?.toString() ?? '0';
    _oilPaintsIndEcoPrecentageController.text =
        widget.salesModel!.oil_paints_ind_eco_percenatge?.toString() ?? '0';

    // Water Sub-types
    _emulPaintsWaterPrecentageController.text =
        widget.salesModel!.emul_paints_water_percentage?.toString() ?? '0';
    _emulPaintsWaterBestPrecentageController.text =
        widget.salesModel!.emul_paints_water_best_percenatge?.toString() ?? '0';
    _emulPaintsWaterMidPrecentageController.text =
        widget.salesModel!.emul_paints_water_mid_percenatge?.toString() ?? '0';
    _emulPaintsWaterEcoPrecentageController.text =
        widget.salesModel!.emul_paints_water_eco_percenatge?.toString() ?? '0';
    _emulPaintsAcrylicPrecentageController.text =
        widget.salesModel!.emul_paints_acrylic_percentage?.toString() ?? '0';
    _emulPaintsAcrylicBestPrecentageController.text =
        widget.salesModel!.emul_paints_acrylic_best_percenatge?.toString() ??
            '0';
    _emulPaintsAcrylicMidPrecentageController.text =
        widget.salesModel!.emul_paints_acrylic_mid_percenatge?.toString() ??
            '0';
    _emulPaintsAcrylicEcoPrecentageController.text =
        widget.salesModel!.emul_paints_acrylic_eco_percenatge?.toString() ??
            '0';
    _emulPaintsDecoPuttyPrecentageController.text =
        widget.salesModel!.emul_paints_deco_putty_percentage?.toString() ?? '0';
    _emulPaintsDecoPuttyBestPrecentageController.text =
        widget.salesModel!.emul_paints_deco_putty_best_percenatge?.toString() ??
            '0';
    _emulPaintsDecoPuttyMidPrecentageController.text =
        widget.salesModel!.emul_paints_deco_putty_mid_percenatge?.toString() ??
            '0';
    _emulPaintsDecoPuttyEcoPrecentageController.text =
        widget.salesModel!.emul_paints_deco_putty_eco_percenatge?.toString() ??
            '0';

    // Brand Controllers
    _oilPaintsSlowBestBrandController.text =
        widget.salesModel!.oil_paints_slow_best_brand ?? '';
    _oilPaintsSlowMidBrandController.text =
        widget.salesModel!.oil_paints_slow_mid_brand ?? '';
    _oilPaintsSlowEcoBrandController.text =
        widget.salesModel!.oil_paints_slow_eco_brand ?? '';
    _oilPaintsFastBestBrandController.text =
        widget.salesModel!.oil_paints_fast_best_brand ?? '';
    _oilPaintsFastMidBrandController.text =
        widget.salesModel!.oil_paints_fast_mid_brand ?? '';
    _oilPaintsFastEcoBrandController.text =
        widget.salesModel!.oil_paints_fast_eco_brand ?? '';
    _oilPaintsIndBestBrandController.text =
        widget.salesModel!.oil_paints_ind_best_brand ?? '';
    _oilPaintsIndMidBrandController.text =
        widget.salesModel!.oil_paints_ind_mid_brand ?? '';
    _oilPaintsIndEcoBrandController.text =
        widget.salesModel!.oil_paints_ind_eco_brand ?? '';
    _emulPaintsWaterBestBrandController.text =
        widget.salesModel!.emul_paints_water_best_brand ?? '';
    _emulPaintsWaterMidBrandController.text =
        widget.salesModel!.emul_paints_water_mid_brand ?? '';
    _emulPaintsWaterEcoBrandController.text =
        widget.salesModel!.emul_paints_water_eco_brand ?? '';
    _emulPaintsAcrylicBestBrandController.text =
        widget.salesModel!.emul_paints_acrylic_best_brand ?? '';
    _emulPaintsAcrylicMidBrandController.text =
        widget.salesModel!.emul_paints_acrylic_mid_brand ?? '';
    _emulPaintsAcrylicEcoBrandController.text =
        widget.salesModel!.emul_paints_acrylic_eco_brand ?? '';
    _emulPaintsDecoPuttyBestBrandController.text =
        widget.salesModel!.emul_paints_deco_putty_best_brand ?? '';
    _emulPaintsDecoPuttyMidBrandController.text =
        widget.salesModel!.emul_paints_deco_putty_mid_brand ?? '';
    _emulPaintsDecoPuttyEcoBrandController.text =
        widget.salesModel!.emul_paints_deco_putty_eco_brand ?? '';

    // Notes
    _notesController.text = widget.salesModel!.notes ?? '';

    // Lists
    if (widget.salesModel!.present_brands != null) {
      presentBrands = List<String>.from(widget.salesModel!.present_brands!);
    }
    if (widget.salesModel!.new_brands != null) {
      newBrands = List<String>.from(widget.salesModel!.new_brands!);
    }
    if (widget.salesModel!.declining_brands != null) {
      decliningBrands = List<String>.from(widget.salesModel!.declining_brands!);
    }
    if (widget.salesModel!.company_advantages != null) {
      companyAdvantages =
          List<int>.from(widget.salesModel!.company_advantages!);
    }
    if (widget.salesModel!.company_disadvantages != null) {
      companyDisadvantages =
          List<int>.from(widget.salesModel!.company_disadvantages!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

    // Dispose all controllers
    _applicantNameController.dispose();
    _searchController.dispose();
    _customerNamerController.dispose();
    _shopNameController.dispose();
    _regionNameController.dispose();
    _dateController.dispose();

    _healthyPercentageController.dispose();
    _paintsPercentageController.dispose();
    _hardwarePercentageController.dispose();
    _electricalPercentageController.dispose();
    _buildingMaterialsPercentageController.dispose();

    _ratingCurrentYearController.dispose();
    _ratingLastYearController.dispose();
    _ratingTwoYearsAgoController.dispose();
    _ratingThreeYearsAgoController.dispose();

    _oilPaintsSoldPrecentageController.dispose();
    _emulPaintsSoldPrecentageController.dispose();

    _oilPaintsSlowPrecentageController.dispose();
    _oilPaintsSlowBestPrecentageController.dispose();
    _oilPaintsSlowMidPrecentageController.dispose();
    _oilPaintsSlowEcoPrecentageController.dispose();
    _oilPaintsFastPrecentageController.dispose();
    _oilPaintsFastBestPrecentageController.dispose();
    _oilPaintsFastMidPrecentageController.dispose();
    _oilPaintsFastEcoPrecentageController.dispose();
    _oilPaintsIndPrecentageController.dispose();
    _oilPaintsIndBestPrecentageController.dispose();
    _oilPaintsIndMidPrecentageController.dispose();
    _oilPaintsIndEcoPrecentageController.dispose();

    _emulPaintsWaterPrecentageController.dispose();
    _emulPaintsWaterBestPrecentageController.dispose();
    _emulPaintsWaterMidPrecentageController.dispose();
    _emulPaintsWaterEcoPrecentageController.dispose();
    _emulPaintsAcrylicPrecentageController.dispose();
    _emulPaintsAcrylicBestPrecentageController.dispose();
    _emulPaintsAcrylicMidPrecentageController.dispose();
    _emulPaintsAcrylicEcoPrecentageController.dispose();
    _emulPaintsDecoPuttyPrecentageController.dispose();
    _emulPaintsDecoPuttyBestPrecentageController.dispose();
    _emulPaintsDecoPuttyMidPrecentageController.dispose();
    _emulPaintsDecoPuttyEcoPrecentageController.dispose();

    // Brand controllers
    _oilPaintsSlowBestBrandController.dispose();
    _oilPaintsSlowMidBrandController.dispose();
    _oilPaintsSlowEcoBrandController.dispose();
    _oilPaintsFastBestBrandController.dispose();
    _oilPaintsFastMidBrandController.dispose();
    _oilPaintsFastEcoBrandController.dispose();
    _oilPaintsIndBestBrandController.dispose();
    _oilPaintsIndMidBrandController.dispose();
    _oilPaintsIndEcoBrandController.dispose();
    _emulPaintsWaterBestBrandController.dispose();
    _emulPaintsWaterMidBrandController.dispose();
    _emulPaintsWaterEcoBrandController.dispose();
    _emulPaintsAcrylicBestBrandController.dispose();
    _emulPaintsAcrylicMidBrandController.dispose();
    _emulPaintsAcrylicEcoBrandController.dispose();
    _emulPaintsDecoPuttyBestBrandController.dispose();
    _emulPaintsDecoPuttyMidBrandController.dispose();
    _emulPaintsDecoPuttyEcoBrandController.dispose();

    _notesController.dispose();

    super.dispose();
  }

  void _searchCustomer(BuildContext context) {
    context.read<SalesBloc>().add(
        SalesSearch<CustomerBriefViewModel>(lexum: _searchController.text));
  }

  void _selectCustomer(CustomerBriefViewModel customer) {
    setState(() {
      customerID = customer.id;
      _customerNamerController.text = customer.customerName ?? '';
      _shopNameController.text = customer.shopName ?? '';
      _regionNameController.text = customer.region ?? '';
      _customerSelectedFromSearch = true;
    });
    _searchController.clear();
  }

  void _clearCustomerSelection() {
    setState(() {
      customerID = null;
      _customerNamerController.clear();
      _shopNameController.clear();
      _regionNameController.clear();
      _customerSelectedFromSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            widget.salesModel == null
                ? 'إضافة استبيان مبيعات'
                : 'تعديل استبيان مبيعات',
            style: const TextStyle(color: Colors.white),
          ),
          bottom: _customerSelectedFromSearch
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    padding: EdgeInsets.zero,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: isDark ? Colors.blue[300] : Colors.blue,
                      unselectedLabelColor:
                          isDark ? Colors.grey[400] : Colors.grey,
                      indicatorColor: isDark ? Colors.blue[300] : Colors.blue,
                      tabAlignment: TabAlignment.center,
                      tabs: [
                        _buildTab('البيانات', Icons.person, 0),
                        _buildTab('اعمال المحل', Icons.store, 1),
                        _buildTab('نمو السوق', Icons.trending_up, 2),
                        _buildTab('الزيتية', Icons.water_drop, 3),
                        _buildTab('المائية', Icons.water, 4),
                        _buildTab('الماركات', Icons.branding_watermark, 5),
                        _buildTab('التقييم', Icons.star, 6),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        body: BlocConsumer<SurveysBloc, SurveysState>(
          listener: (context, state) {
            if (state is SurveysSuccess<SalesModel>) {
              showSnackBar(
                  context: context,
                  content: 'تم العملية بنجاح',
                  failure: false);
              Navigator.pop(context);
              navigateWithAnimateReplace(context, const ListSalesSurveyPage());
            } else if (state is SurveysError) {
              showSnackBar(
                  context: context, content: state.errorMessage, failure: true);
            } else if (state is SurveysSuccessProsandcons) {
              setState(() {
                prosList = state.pros;
                consList = state.cons;
              });
            }
          },
          builder: (context, state) {
            if (state is SurveysLoading && prosList.isEmpty) {
              return const Center(child: Loader());
            }

            return Column(
              children: [
                if (!_customerSelectedFromSearch)
                  _buildCustomerSearchSection(context),
                Expanded(
                  child: _customerSelectedFromSearch
                      ? TabBarView(
                          controller: _tabController,
                          children: [
                            // Tab 1: البيانات الأساسية
                            _buildBasicDataTab(),

                            // Tab 2: اعمال المحل
                            _buildBusinessTypesTab(),

                            // Tab 3: نمو السوق
                            _buildMarketGrowthTab(),

                            // Tab 4: الزيتية
                            _buildOilPaintsTab(),

                            // Tab 5: المائية
                            _buildWaterPaintsTab(),

                            // Tab 6: الماركات
                            _buildBrandsTab(),

                            // Tab 7: التقييم
                            _buildEvaluationTab(),
                          ],
                        )
                      : const SizedBox(), // Empty when no customer selected
                ),
              ],
            );
          },
        ),
        floatingActionButton: _customerSelectedFromSearch
            ? FloatingActionButton(
                onPressed: _submitForm,
                mini: true,
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  // ============= TAB 1: Basic Data =============
  Widget _buildBasicDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Column(
                      children: [
                        MyTextField(
                            controller: _customerNamerController,
                            labelText: 'اسم الزبون',
                            readOnly: true),
                        const SizedBox(height: 10),
                        MyTextField(
                            controller: _shopNameController,
                            labelText: 'اسم المحل',
                            readOnly: true),
                        const SizedBox(height: 10),
                        MyTextField(
                            controller: _regionNameController,
                            labelText: 'المنطقة',
                            readOnly: true),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.change_circle,
                          color: Colors.orange, size: 30),
                      onPressed: _clearCustomerSelection),
                ],
              ),
              MyTextField(
                readOnly: true,
                controller: _dateController,
                labelText: 'تاريخ الاستبيان',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => _dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate));
                  }
                },
              ),
              const SizedBox(height: 16),
              SearchableDropdown(
                controller: _applicantNameController,
                labelText: 'القائم بالاستبيان',
                items: listApplicantName,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============= TAB 2: Business Types =============
  Widget _buildBusinessTypesTab() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'كيف ترى اعتماد العمل التجاري في محلك',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isLandscape ? 6 : 3,
            childAspectRatio: isLandscape ? 1.5 : 0.7,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: [
              _buildBusinessTypeCard("دهانات", _paintsPercentageController,
                  Colors.red, Icons.format_paint, [
                _healthyPercentageController,
                _hardwarePercentageController,
                _electricalPercentageController,
                _buildingMaterialsPercentageController
              ]),
              _buildBusinessTypeCard("صحية", _healthyPercentageController,
                  Colors.green, Icons.medical_services, [
                _paintsPercentageController,
                _hardwarePercentageController,
                _electricalPercentageController,
                _buildingMaterialsPercentageController
              ]),
              _buildBusinessTypeCard("خرداوات", _hardwarePercentageController,
                  Colors.blue, Icons.hardware, [
                _paintsPercentageController,
                _healthyPercentageController,
                _electricalPercentageController,
                _buildingMaterialsPercentageController
              ]),
              _buildBusinessTypeCard(
                  "كهربائيات",
                  _electricalPercentageController,
                  Colors.orange,
                  Icons.electrical_services, [
                _paintsPercentageController,
                _healthyPercentageController,
                _hardwarePercentageController,
                _buildingMaterialsPercentageController
              ]),
              _buildBusinessTypeCard(
                  "مواد بناء",
                  _buildingMaterialsPercentageController,
                  Colors.purple,
                  Icons.construction, [
                _paintsPercentageController,
                _healthyPercentageController,
                _hardwarePercentageController,
                _electricalPercentageController
              ]),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'ملخص نسب أعمال المحل',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  StoreItemsPieChart(
                    paints:
                        double.tryParse(_paintsPercentageController.text) ?? 0,
                    healthy:
                        double.tryParse(_healthyPercentageController.text) ?? 0,
                    hardware:
                        double.tryParse(_hardwarePercentageController.text) ??
                            0,
                    electrical:
                        double.tryParse(_electricalPercentageController.text) ??
                            0,
                    buildingMaterials: double.tryParse(
                            _buildingMaterialsPercentageController.text) ??
                        0,
                  ),
                  _buildBusinessSummary(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessTypeCard(
    String title,
    TextEditingController controller,
    Color color,
    IconData icon,
    List<TextEditingController> others,
  ) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showPercentageDialog(
            controller, others, 'تعديل نسبة $title', color),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              _buildCircularInputWithLabel(
                controller,
                color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularInputWithLabel(
    TextEditingController controller,
    Color color,
  ) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Text(
              '${double.tryParse(controller.text)?.toInt() ?? 0}%',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBusinessSummary() {
    final total = (double.tryParse(_paintsPercentageController.text) ?? 0) +
        (double.tryParse(_healthyPercentageController.text) ?? 0) +
        (double.tryParse(_hardwarePercentageController.text) ?? 0) +
        (double.tryParse(_electricalPercentageController.text) ?? 0) +
        (double.tryParse(_buildingMaterialsPercentageController.text) ?? 0);

    return Column(
      children: [
        Divider(color: Colors.grey[300]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('الإجمالي:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 20,
            ),
            Text(
              '${total.toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: total == 100 ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),
          ],
        ),
        if (total != 100)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'يجب أن يكون الإجمالي 100%',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // ============= TAB 3: Market Growth =============
  Widget _buildMarketGrowthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تقييم نمو سوق الدهانات خلال ال 4 سنوات الماضية',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildYearRatingCard(
            'العام الماضي',
            _ratingCurrentYearController,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildYearRatingCard(
            'العام قبل الماضي',
            _ratingLastYearController,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildYearRatingCard(
            'قبل ثلاث سنوات',
            _ratingTwoYearsAgoController,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildYearRatingCard(
            'قبل أربع سنوات',
            _ratingThreeYearsAgoController,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildYearRatingCard(
      String year, TextEditingController controller, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: _buildInteractiveStars(controller, color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveStars(TextEditingController controller, Color color) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final theme = Theme.of(context);
        int currentRating = int.tryParse(value.text) ?? 0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(10, (index) {
                int starValue = index + 1;
                return GestureDetector(
                  onTap: () {
                    controller.text = starValue.toString();
                  },
                  child: Icon(
                    starValue <= currentRating ? Icons.star : Icons.star_border,
                    color: starValue <= currentRating
                        ? color
                        : theme.disabledColor,
                    size: 28,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              '$currentRating / 10',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: currentRating > 0 ? color : theme.hintColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // ============= TAB 4: Oil Paints =============
  Widget _buildOilPaintsTab() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: Padding(
              padding: EdgeInsets.zero,
              child: TabBar(
                isScrollable: true,
                labelColor: isDark ? Colors.blue[300] : Colors.blue,
                unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey,
                indicatorColor: isDark ? Colors.blue[300] : Colors.blue,
                tabAlignment: TabAlignment.center,
                tabs: const [
                  Tab(text: 'نظرة عامة'),
                  Tab(text: 'نفطية'),
                  Tab(text: 'سريع'),
                  Tab(text: 'صناعية'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'الدهانات الأكثر مبيعاً',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildPaintOverview(),
                      const SizedBox(height: 20),
                      const Text(
                        'الدهانات الأكثر مبيعاً زيتية',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildOilOverview(),
                    ],
                  ),
                ),

                // نفطية Tab
                _buildOilSubTypeTab(
                  title: 'نفطية',
                  mainController: _oilPaintsSlowPrecentageController,
                  subControllers: [
                    _oilPaintsSlowBestPrecentageController,
                    _oilPaintsSlowMidPrecentageController,
                    _oilPaintsSlowEcoPrecentageController,
                  ],
                  brandControllers: [
                    _oilPaintsSlowBestBrandController,
                    _oilPaintsSlowMidBrandController,
                    _oilPaintsSlowEcoBrandController,
                  ],
                  otherMainControllers: [
                    _oilPaintsFastPrecentageController,
                    _oilPaintsIndPrecentageController,
                  ],
                  color: Colors.cyan,
                  parentController: _oilPaintsSoldPrecentageController,
                  includeBrands: true,
                ),

                // سريع Tab
                _buildOilSubTypeTab(
                  title: 'سريع',
                  mainController: _oilPaintsFastPrecentageController,
                  subControllers: [
                    _oilPaintsFastBestPrecentageController,
                    _oilPaintsFastMidPrecentageController,
                    _oilPaintsFastEcoPrecentageController,
                  ],
                  brandControllers: [
                    _oilPaintsFastBestBrandController,
                    _oilPaintsFastMidBrandController,
                    _oilPaintsFastEcoBrandController,
                  ],
                  otherMainControllers: [
                    _oilPaintsSlowPrecentageController,
                    _oilPaintsIndPrecentageController,
                  ],
                  color: Colors.indigo,
                  parentController: _oilPaintsSoldPrecentageController,
                  includeBrands: false,
                ),

                // صناعية Tab
                _buildOilSubTypeTab(
                  title: 'صناعية',
                  mainController: _oilPaintsIndPrecentageController,
                  subControllers: [
                    _oilPaintsIndBestPrecentageController,
                    _oilPaintsIndMidPrecentageController,
                    _oilPaintsIndEcoPrecentageController,
                  ],
                  brandControllers: [
                    _oilPaintsIndBestBrandController,
                    _oilPaintsIndMidBrandController,
                    _oilPaintsIndEcoBrandController,
                  ],
                  otherMainControllers: [
                    _oilPaintsSlowPrecentageController,
                    _oilPaintsFastPrecentageController,
                  ],
                  color: Colors.red,
                  parentController: _oilPaintsSoldPrecentageController,
                  includeBrands: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaintOverview() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: isLandscape ? 2.5 : 0.6,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildBusinessTypeCard(
          "زيتية",
          _oilPaintsSoldPrecentageController,
          Colors.orange,
          Icons.oil_barrel,
          [_emulPaintsSoldPrecentageController],
        ),
        _buildBusinessTypeCard(
          "مائية",
          _emulPaintsSoldPrecentageController,
          Colors.blue,
          Icons.water_drop,
          [_oilPaintsSoldPrecentageController],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'توزيع مبيعات الدهان',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                DynamicPieChart(
                  chartRadius: 60,
                  dataMap: {
                    "زيتية": double.tryParse(
                            _oilPaintsSoldPrecentageController.text) ??
                        0,
                    "مائية": double.tryParse(
                            _emulPaintsSoldPrecentageController.text) ??
                        0,
                  },
                  colors: const [Colors.orange, Colors.blue],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOilOverview() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isLandscape ? 4 : 3,
      childAspectRatio: isLandscape ? 1.8 : 0.6,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildBusinessTypeCard(
          "نفطية",
          _oilPaintsSlowPrecentageController,
          Colors.cyan,
          Icons.water_drop,
          [
            _oilPaintsFastPrecentageController,
            _oilPaintsIndPrecentageController
          ],
        ),
        _buildBusinessTypeCard(
          "سريع",
          _oilPaintsFastPrecentageController,
          Colors.indigo,
          Icons.flash_on,
          [
            _oilPaintsSlowPrecentageController,
            _oilPaintsIndPrecentageController
          ],
        ),
        _buildBusinessTypeCard(
          "صناعية",
          _oilPaintsIndPrecentageController,
          Colors.orange,
          Icons.factory,
          [
            _oilPaintsSlowPrecentageController,
            _oilPaintsFastPrecentageController
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'توزيع مبيعات الزيتي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                DynamicPieChart(
                  chartRadius: 60,
                  dataMap: {
                    "نفطية": double.tryParse(
                            _oilPaintsSlowPrecentageController.text) ??
                        0,
                    "سريع": double.tryParse(
                            _oilPaintsFastPrecentageController.text) ??
                        0,
                    "صناعية": double.tryParse(
                            _oilPaintsIndPrecentageController.text) ??
                        0,
                  },
                  colors: const [
                    Colors.cyan,
                    Colors.indigo,
                    Colors.orange,
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmulOverview() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isLandscape ? 4 : 3,
      childAspectRatio: isLandscape ? 1.8 : 0.6,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildBusinessTypeCard(
          "طرش",
          _emulPaintsWaterPrecentageController,
          Colors.cyan,
          Icons.water_drop,
          [
            _emulPaintsAcrylicPrecentageController,
            _emulPaintsDecoPuttyPrecentageController
          ],
        ),
        _buildBusinessTypeCard(
          "أكرليك",
          _emulPaintsAcrylicPrecentageController,
          Colors.indigo,
          Icons.flash_on,
          [
            _emulPaintsWaterPrecentageController,
            _emulPaintsDecoPuttyPrecentageController
          ],
        ),
        _buildBusinessTypeCard(
          "معاجين وديكور",
          _emulPaintsDecoPuttyPrecentageController,
          Colors.orange,
          Icons.factory,
          [
            _emulPaintsWaterPrecentageController,
            _emulPaintsAcrylicPrecentageController
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'توزيع مبيعات المائية',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                DynamicPieChart(
                  chartRadius: 60,
                  dataMap: {
                    "طرش": double.tryParse(
                            _emulPaintsWaterPrecentageController.text) ??
                        0,
                    "أكرليك": double.tryParse(
                            _emulPaintsAcrylicPrecentageController.text) ??
                        0,
                    "معاجين وديكور": double.tryParse(
                            _emulPaintsDecoPuttyPrecentageController.text) ??
                        0,
                  },
                  colors: const [
                    Colors.cyan,
                    Colors.indigo,
                    Colors.orange,
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOilSubTypeTab({
    required String title,
    required TextEditingController mainController,
    required List<TextEditingController> subControllers,
    required List<TextEditingController> brandControllers,
    required List<TextEditingController> otherMainControllers,
    required Color color,
    required TextEditingController parentController,
    required bool includeBrands,
  }) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'توزيع أنواع $title',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isLandscape ? 3 : 2,
            childAspectRatio: isLandscape ? 3 : 1.1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              if (isLandscape) ...[
                _buildBusinessTypeCard(
                    "نوع أول",
                    subControllers[0],
                    Colors.cyan,
                    Icons.star,
                    [subControllers[1], subControllers[2]]),
                _buildBusinessTypeCard(
                    "نوع وسط",
                    subControllers[1],
                    Colors.indigo,
                    Icons.thumbs_up_down,
                    [subControllers[0], subControllers[2]]),
                _buildBusinessTypeCard(
                    "نوع تجاري",
                    subControllers[2],
                    Colors.red,
                    Icons.shopping_cart,
                    [subControllers[0], subControllers[1]]),
                _buildBrandDropdownCard(
                    'ماركة نوع أول', brandControllers[0], Colors.cyan),
                _buildBrandDropdownCard(
                    'ماركة نوع وسط', brandControllers[1], Colors.indigo),
                _buildBrandDropdownCard(
                    'ماركة نوع تجاري', brandControllers[2], Colors.red),
              ] else ...[
                _buildBusinessTypeCard(
                    "نوع أول",
                    subControllers[0],
                    Colors.cyan,
                    Icons.star,
                    [subControllers[1], subControllers[2]]),
                _buildBrandDropdownCard(
                    'ماركة نوع أول', brandControllers[0], Colors.cyan),
                _buildBusinessTypeCard(
                    "نوع وسط",
                    subControllers[1],
                    Colors.indigo,
                    Icons.thumbs_up_down,
                    [subControllers[0], subControllers[2]]),
                _buildBrandDropdownCard(
                    'ماركة نوع وسط', brandControllers[1], Colors.indigo),
                _buildBusinessTypeCard(
                    "نوع تجاري",
                    subControllers[2],
                    Colors.red,
                    Icons.shopping_cart,
                    [subControllers[0], subControllers[1]]),
                _buildBrandDropdownCard(
                    'ماركة نوع تجاري', brandControllers[2], Colors.red),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('ملخص التوزيع',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DynamicPieChart(
                    dataMap: {
                      "نوع أول": double.tryParse(subControllers[0].text) ?? 0,
                      "نوع وسط": double.tryParse(subControllers[1].text) ?? 0,
                      "نوع تجاري": double.tryParse(subControllers[2].text) ?? 0,
                    },
                    colors: const [Colors.cyan, Colors.indigo, Colors.red],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandDropdownCard(
      String label, TextEditingController controller, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            SearchableDropdown(
              controller: controller,
              labelText: label,
              items: listBrands,
            ),
          ],
        ),
      ),
    );
  }

  // ============= TAB 5: Water Paints =============
  Widget _buildWaterPaintsTab() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: Padding(
              padding: EdgeInsets.zero,
              child: TabBar(
                isScrollable: true,
                labelColor: isDark ? Colors.blue[300] : Colors.blue,
                unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey,
                indicatorColor: isDark ? Colors.blue[300] : Colors.blue,
                tabAlignment: TabAlignment.center,
                tabs: const [
                  Tab(text: 'نظرة عامة'),
                  Tab(text: 'طرش'),
                  Tab(text: 'أكرليك'),
                  Tab(text: 'معاجين وديكور'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'الدهانات الأكثر مبيعاً',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildPaintOverview(),
                      const SizedBox(height: 20),
                      const Text(
                        'الدهانات الأكثر مبيعاً مائية',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildEmulOverview(),
                    ],
                  ),
                ),
                _buildOilSubTypeTab(
                  title: 'طرش',
                  mainController: _emulPaintsWaterPrecentageController,
                  subControllers: [
                    _emulPaintsWaterBestPrecentageController,
                    _emulPaintsWaterMidPrecentageController,
                    _emulPaintsWaterEcoPrecentageController,
                  ],
                  brandControllers: [
                    _emulPaintsWaterBestBrandController,
                    _emulPaintsWaterMidBrandController,
                    _emulPaintsWaterEcoBrandController,
                  ],
                  otherMainControllers: [
                    _emulPaintsAcrylicPrecentageController,
                    _emulPaintsDecoPuttyPrecentageController,
                  ],
                  color: Colors.cyan,
                  parentController: _emulPaintsSoldPrecentageController,
                  includeBrands: true,
                ),
                _buildOilSubTypeTab(
                  title: 'أكرليك',
                  mainController: _emulPaintsAcrylicPrecentageController,
                  subControllers: [
                    _emulPaintsAcrylicBestPrecentageController,
                    _emulPaintsAcrylicMidPrecentageController,
                    _emulPaintsAcrylicEcoPrecentageController,
                  ],
                  brandControllers: [
                    _emulPaintsAcrylicBestBrandController,
                    _emulPaintsAcrylicMidBrandController,
                    _emulPaintsAcrylicEcoBrandController,
                  ],
                  otherMainControllers: [
                    _emulPaintsWaterPrecentageController,
                    _emulPaintsDecoPuttyPrecentageController,
                  ],
                  color: Colors.indigo,
                  parentController: _emulPaintsSoldPrecentageController,
                  includeBrands: true,
                ),
                _buildOilSubTypeTab(
                  title: 'معاجين وديكور',
                  mainController: _emulPaintsDecoPuttyPrecentageController,
                  subControllers: [
                    _emulPaintsDecoPuttyBestPrecentageController,
                    _emulPaintsDecoPuttyMidPrecentageController,
                    _emulPaintsDecoPuttyEcoPrecentageController,
                  ],
                  brandControllers: [
                    _emulPaintsDecoPuttyBestBrandController,
                    _emulPaintsDecoPuttyMidBrandController,
                    _emulPaintsDecoPuttyEcoBrandController,
                  ],
                  otherMainControllers: [
                    _emulPaintsWaterPrecentageController,
                    _emulPaintsAcrylicPrecentageController,
                  ],
                  color: Colors.red,
                  parentController: _emulPaintsSoldPrecentageController,
                  includeBrands: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============= TAB 6: Brands =============
  Widget _buildBrandsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBrandPicker(
            'ماركات حافظت على مكانتها',
            presentBrands,
            () {
              _openBrandSelection(
                'ماركات حافظت على مكانتها',
                presentBrands,
                (list) => setState(() => presentBrands = list),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildBrandPicker(
            'ماركات ظهرت حديثاً وكانت غائبة',
            newBrands,
            () {
              _openBrandSelection(
                'ماركات ظهرت حديثاً وكانت غائبة',
                newBrands,
                (list) => setState(() => newBrands = list),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildBrandPicker(
            'ماركات غابت أو تراجع ظهورها في السوق',
            decliningBrands,
            () {
              _openBrandSelection(
                'ماركات غابت أو تراجع ظهورها في السوق',
                decliningBrands,
                (list) => setState(() => decliningBrands = list),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============= TAB 7: Evaluation =============
  Widget _buildEvaluationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prosList.isNotEmpty)
            MultiSelectionChips(
              items: prosList,
              selectedIds: companyAdvantages,
              onSelectionChanged: (ids) =>
                  setState(() => companyAdvantages = ids),
              label: 'إيجابيات للشركات جعلتها تتفوق على غيرها',
            ),
          const SizedBox(height: 20),
          if (consList.isNotEmpty)
            MultiSelectionChips(
              items: consList,
              selectedIds: companyDisadvantages,
              onSelectionChanged: (ids) =>
                  setState(() => companyDisadvantages = ids),
              label: 'سلبيات للشركات جعلتها تتراجع عن غيرها',
            ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ملاحظات ومقترحات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  MyTextField(
                    controller: _notesController,
                    labelText: 'اكتب ملاحظاتك هنا...',
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============= TAB 8: Summary =============

  Widget _buildCustomerSearchSection(BuildContext context) {
    return BlocConsumer<SalesBloc, SalesState>(
      listener: (context, state) {
        if (state is SalesOpSuccess<List<CustomerBriefViewModel>>) {
          _showCustomerSelectionDialog(context, state.opResult);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('ابحث عن الزبون',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SearchRow(
                  textEditingController: _searchController,
                  onSearch: () => _searchCustomer(context)),
              const SizedBox(height: 16),
              if (state is SalesOpLoading) const Loader(),
            ],
          ),
        );
      },
    );
  }

  void _showCustomerSelectionDialog(
      BuildContext context, List<CustomerBriefViewModel> customers) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اختر الزبون'),
          content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(customers[index].customerName ?? ''),
                  subtitle: Text(customers[index].shopName ?? ''),
                  onTap: () {
                    Navigator.pop(context);
                    _selectCustomer(customers[index]);
                  },
                ),
              )),
        ),
      ),
    );
  }

  void _submitForm() {
    String? initialError;
    if (_dateController.text.isEmpty) {
      initialError = 'يرجى تحديد تاريخ الاستبيان';
      _tabController.animateTo(0); // Go to 'البيانات' tab
    } else if (_applicantNameController.text.isEmpty) {
      initialError = 'يرجى اختيار اسم القائم بالاستبيان';
      _tabController.animateTo(0); // Go to 'البيانات' tab
    }

    if (initialError != null) {
      showSnackBar(context: context, content: initialError, failure: true);
      return;
    }

    double businessTotal =
        (double.tryParse(_paintsPercentageController.text) ?? 0) +
            (double.tryParse(_healthyPercentageController.text) ?? 0) +
            (double.tryParse(_hardwarePercentageController.text) ?? 0) +
            (double.tryParse(_electricalPercentageController.text) ?? 0) +
            (double.tryParse(_buildingMaterialsPercentageController.text) ?? 0);

    double paintOverviewTotal =
        (double.tryParse(_oilPaintsSoldPrecentageController.text) ?? 0) +
            (double.tryParse(_emulPaintsSoldPrecentageController.text) ?? 0);

    double oilSubTypesTotal =
        (double.tryParse(_oilPaintsSlowPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsFastPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsIndPrecentageController.text) ?? 0);

    double oilSlowTypesTotal =
        (double.tryParse(_oilPaintsSlowBestPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsSlowMidPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsSlowEcoPrecentageController.text) ?? 0);

    double oilFastTypesTotal =
        (double.tryParse(_oilPaintsFastBestPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsFastMidPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsFastEcoPrecentageController.text) ?? 0);

    double oilIndTypesTotal =
        (double.tryParse(_oilPaintsIndBestPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsIndMidPrecentageController.text) ?? 0) +
            (double.tryParse(_oilPaintsIndEcoPrecentageController.text) ?? 0);

    double emulSubTypesTotal =
        (double.tryParse(_emulPaintsWaterPrecentageController.text) ?? 0) +
            (double.tryParse(_emulPaintsAcrylicPrecentageController.text) ??
                0) +
            (double.tryParse(_emulPaintsDecoPuttyPrecentageController.text) ??
                0);

    double emulWaterTypesTotal =
        (double.tryParse(_emulPaintsWaterBestPrecentageController.text) ?? 0) +
            (double.tryParse(_emulPaintsWaterMidPrecentageController.text) ??
                0) +
            (double.tryParse(_emulPaintsWaterEcoPrecentageController.text) ??
                0);

    double emulAcrylicTypesTotal = (double.tryParse(
                _emulPaintsAcrylicBestPrecentageController.text) ??
            0) +
        (double.tryParse(_emulPaintsAcrylicMidPrecentageController.text) ?? 0) +
        (double.tryParse(_emulPaintsAcrylicEcoPrecentageController.text) ?? 0);

    double emulDecoPuttyTypesTotal = (double.tryParse(
                _emulPaintsDecoPuttyBestPrecentageController.text) ??
            0) +
        (double.tryParse(_emulPaintsDecoPuttyMidPrecentageController.text) ??
            0) +
        (double.tryParse(_emulPaintsDecoPuttyEcoPrecentageController.text) ??
            0);

    String? errorMessage;
    int? tabToNavigate;

    if (businessTotal != 100) {
      errorMessage = 'مجموع نسب أعمال المحل يجب أن يكون 100%';
      tabToNavigate = 1; // Navigate to Business Types tab
    } else if (paintOverviewTotal != 100) {
      errorMessage = 'مجموع مبيعات الدهان (زيتية/مائية) يجب أن يكون 100%';
      tabToNavigate = 3; // Navigate to Oil Paints tab
    } else if (oilSubTypesTotal != 100) {
      errorMessage = 'مجموع مبيعات الزيتي (نفطية/سريع/صناعية) يجب أن يكون 100%';
      tabToNavigate = 3;
    } else if (oilSlowTypesTotal != 100) {
      errorMessage =
          'مجموع نسب دهانات النفطية (نوع أول/نوع وسط/نوع تجاري) يجب أن يكون 100%';
      tabToNavigate = 3;
    } else if (oilFastTypesTotal != 100) {
      errorMessage =
          'مجموع نسب دهانات السريع (نوع أول/نوع وسط/نوع تجاري) يجب أن يكون 100%';
      tabToNavigate = 3;
    } else if (oilIndTypesTotal != 100) {
      errorMessage =
          'مجموع نسب دهانات الصناعية (نوع أول/نوع وسط/نوع تجاري) يجب أن يكون 100%';
      tabToNavigate = 3;
    } else if (emulSubTypesTotal != 100) {
      errorMessage =
          'مجموع مبيعات المائية (طرش/أكرليك/معاجين) يجب أن يكون 100%';
      tabToNavigate = 4; // Navigate to Water Paints tab
    } else if (emulWaterTypesTotal != 100) {
      errorMessage =
          'مجموع نسب دهانات الطرش (نوع أول/نوع وسط/نوع تجاري) يجب أن يكون 100%';
      tabToNavigate = 4;
    } else if (emulAcrylicTypesTotal != 100) {
      errorMessage =
          'مجموع نسب دهانات الأكرليك (نوع أول/نوع وسط/نوع تجاري) يجب أن يكون 100%';
      tabToNavigate = 4;
    } else if (emulDecoPuttyTypesTotal != 100) {
      errorMessage =
          'مجموع نسب المعاجين الديكورية (نوع أول/نوع وسط/نوع تجاري) يجب أن يكون 100%';
      tabToNavigate = 4;
    }

    if (errorMessage != null) {
      if (tabToNavigate != null) {
        _tabController.animateTo(tabToNavigate);
      }
      showSnackBar(context: context, content: errorMessage, failure: true);
      return;
    }

    final model = _fillModelFromForm();
    print(model);
    if (widget.salesModel == null) {
      context.read<SurveysBloc>().add(AddNewSalesSurvey(salesModel: model));
    } else {
      context
          .read<SurveysBloc>()
          .add(EditSalesSurvey(salesModel: model, id: widget.salesModel!.id));
    }
  }

  SalesModel _fillModelFromForm() {
    int? parsePercent(String text) {
      if (text.isEmpty) return null;
      return double.tryParse(text)?.toInt();
    }

    return SalesModel(
      id: widget.salesModel?.id ?? 0,
      applicant_name: _applicantNameController.text,
      customer_name: _customerNamerController.text,
      shop_name: _shopNameController.text,
      region_name: _regionNameController.text,
      customer: customerID,
      date: _dateController.text.isNotEmpty ? _dateController.text : null,
      healthy_percentage: parsePercent(_healthyPercentageController.text),
      paints_percentage: parsePercent(_paintsPercentageController.text),
      hardware_percentage: parsePercent(_hardwarePercentageController.text),
      electrical_percentage: parsePercent(_electricalPercentageController.text),
      building_materials_percentage:
          parsePercent(_buildingMaterialsPercentageController.text),
      rating_current_year: int.tryParse(_ratingCurrentYearController.text),
      rating_last_year: int.tryParse(_ratingLastYearController.text),
      rating_two_years_ago: int.tryParse(_ratingTwoYearsAgoController.text),
      rating_three_years_ago: int.tryParse(_ratingThreeYearsAgoController.text),
      oil_paints_sold_precentage:
          parsePercent(_oilPaintsSoldPrecentageController.text),
      oil_paints_slow_percentage:
          parsePercent(_oilPaintsSlowPrecentageController.text),
      oil_paints_slow_best_percenatge:
          parsePercent(_oilPaintsSlowBestPrecentageController.text),
      oil_paints_slow_best_brand: _oilPaintsSlowBestBrandController.text,
      oil_paints_slow_mid_percenatge:
          parsePercent(_oilPaintsSlowMidPrecentageController.text),
      oil_paints_slow_mid_brand: _oilPaintsSlowMidBrandController.text,
      oil_paints_slow_eco_percenatge:
          parsePercent(_oilPaintsSlowEcoPrecentageController.text),
      oil_paints_slow_eco_brand: _oilPaintsSlowEcoBrandController.text,
      oil_paints_fast_percentage:
          parsePercent(_oilPaintsFastPrecentageController.text),
      oil_paints_fast_best_percenatge:
          parsePercent(_oilPaintsFastBestPrecentageController.text),
      oil_paints_fast_best_brand: _oilPaintsFastBestBrandController.text,
      oil_paints_fast_mid_percenatge:
          parsePercent(_oilPaintsFastMidPrecentageController.text),
      oil_paints_fast_mid_brand: _oilPaintsFastMidBrandController.text,
      oil_paints_fast_eco_percenatge:
          parsePercent(_oilPaintsFastEcoPrecentageController.text),
      oil_paints_fast_eco_brand: _oilPaintsFastEcoBrandController.text,
      oil_paints_ind_percentage:
          parsePercent(_oilPaintsIndPrecentageController.text),
      oil_paints_ind_best_percenatge:
          parsePercent(_oilPaintsIndBestPrecentageController.text),
      oil_paints_ind_best_brand: _oilPaintsIndBestBrandController.text,
      oil_paints_ind_mid_percenatge:
          parsePercent(_oilPaintsIndMidPrecentageController.text),
      oil_paints_ind_mid_brand: _oilPaintsIndMidBrandController.text,
      oil_paints_ind_eco_percenatge:
          parsePercent(_oilPaintsIndEcoPrecentageController.text),
      oil_paints_ind_eco_brand: _oilPaintsIndEcoBrandController.text,
      emul_paints_sold_precentage:
          parsePercent(_emulPaintsSoldPrecentageController.text),
      emul_paints_water_percentage:
          parsePercent(_emulPaintsWaterPrecentageController.text),
      emul_paints_water_best_percenatge:
          parsePercent(_emulPaintsWaterBestPrecentageController.text),
      emul_paints_water_best_brand: _emulPaintsWaterBestBrandController.text,
      emul_paints_water_mid_percenatge:
          parsePercent(_emulPaintsWaterMidPrecentageController.text),
      emul_paints_water_mid_brand: _emulPaintsWaterMidBrandController.text,
      emul_paints_water_eco_percenatge:
          parsePercent(_emulPaintsWaterEcoPrecentageController.text),
      emul_paints_water_eco_brand: _emulPaintsWaterEcoBrandController.text,
      emul_paints_acrylic_percentage:
          parsePercent(_emulPaintsAcrylicPrecentageController.text),
      emul_paints_acrylic_best_percenatge:
          parsePercent(_emulPaintsAcrylicBestPrecentageController.text),
      emul_paints_acrylic_best_brand:
          _emulPaintsAcrylicBestBrandController.text,
      emul_paints_acrylic_mid_percenatge:
          parsePercent(_emulPaintsAcrylicMidPrecentageController.text),
      emul_paints_acrylic_mid_brand: _emulPaintsAcrylicMidBrandController.text,
      emul_paints_acrylic_eco_percenatge:
          parsePercent(_emulPaintsAcrylicEcoPrecentageController.text),
      emul_paints_acrylic_eco_brand: _emulPaintsAcrylicEcoBrandController.text,
      emul_paints_deco_putty_percentage:
          parsePercent(_emulPaintsDecoPuttyPrecentageController.text),
      emul_paints_deco_putty_best_percenatge:
          parsePercent(_emulPaintsDecoPuttyBestPrecentageController.text),
      emul_paints_deco_putty_best_brand:
          _emulPaintsDecoPuttyBestBrandController.text,
      emul_paints_deco_putty_mid_percenatge:
          parsePercent(_emulPaintsDecoPuttyMidPrecentageController.text),
      emul_paints_deco_putty_mid_brand:
          _emulPaintsDecoPuttyMidBrandController.text,
      emul_paints_deco_putty_eco_percenatge:
          parsePercent(_emulPaintsDecoPuttyEcoPrecentageController.text),
      emul_paints_deco_putty_eco_brand:
          _emulPaintsDecoPuttyEcoBrandController.text,
      notes: _notesController.text,
      present_brands: presentBrands.isNotEmpty ? presentBrands : null,
      new_brands: newBrands.isNotEmpty ? newBrands : null,
      declining_brands: decliningBrands.isNotEmpty ? decliningBrands : null,
      company_advantages:
          companyAdvantages.isNotEmpty ? companyAdvantages : null,
      company_disadvantages:
          companyDisadvantages.isNotEmpty ? companyDisadvantages : null,
    );
  }

  Widget _buildBrandPicker(
      String label, List<String> selectedBrands, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.add_business, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedBrands.isEmpty
                        ? 'اضغط للاختيار من القائمة'
                        : selectedBrands.join(' - '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (selectedBrands.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${selectedBrands.length} ماركة مختارة',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  void _openBrandSelection(
      String title, List<String> currentList, Function(List<String>) onUpdate) {
    List<String> tempSelected = List.from(currentList);
    final TextEditingController _modalSearchController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredBrands = Brands.brands
                .where((brand) => brand
                    .toLowerCase()
                    .contains(_modalSearchController.text.toLowerCase()))
                .toList();

            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _modalSearchController,
                      decoration: InputDecoration(
                        hintText: 'بحث عن ماركة...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _modalSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _modalSearchController.clear();
                                  setModalState(() {});
                                },
                              )
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) => setModalState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            tempSelected.clear();
                          });
                        },
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        label: const Text('مسح الكل',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredBrands.length,
                        itemBuilder: (context, index) {
                          final brand = filteredBrands[index];
                          return CheckboxListTile(
                            title: Text(brand),
                            value: tempSelected.contains(brand),
                            onChanged: (bool? checked) {
                              setModalState(() {
                                checked!
                                    ? tempSelected.add(brand)
                                    : tempSelected.remove(brand);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Mybutton(
                      text: 'حفظ الاختيارات',
                      onPressed: () {
                        onUpdate(tempSelected);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPercentageDialog(
    TextEditingController controller,
    List<TextEditingController> others,
    String title,
    Color color,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return PercentageInputDialog(
          title: title,
          color: color,
          controller: controller,
          otherControllers: others,
        );
      },
    );

    setState(() {});
  }
}

class PercentageInputDialog extends StatefulWidget {
  final String title;
  final Color color;
  final TextEditingController controller;
  final List<TextEditingController> otherControllers;

  const PercentageInputDialog({
    super.key,
    required this.title,
    required this.color,
    required this.controller,
    required this.otherControllers,
  });

  @override
  State<PercentageInputDialog> createState() => _PercentageInputDialogState();
}

class _PercentageInputDialogState extends State<PercentageInputDialog> {
  final TextEditingController _dialogController = TextEditingController();
  double _sliderValue = 0;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _sliderValue = double.tryParse(widget.controller.text) ?? 0;
    _dialogController.text = _sliderValue.toStringAsFixed(1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // 3. Always dispose focus nodes to avoid memory leaks
    _focusNode.dispose();
    _dialogController.dispose();
    super.dispose();
  }

  // 1. Extract the Save Logic into a reusable function
  void _handleSave() {
    final total = _calculateTotal();
    if (total > 100) {
      showSnackBar(
          context: context,
          content: 'عذراً، المجموع الكلي لا يمكن أن يتجاوز 100%',
          failure: true);
    } else {
      widget.controller.text = _sliderValue.toStringAsFixed(1);
      Navigator.pop(context);
    }
  }

  double _calculateTotal() {
    double otherTotal = 0;
    for (var controller in widget.otherControllers) {
      otherTotal += double.tryParse(controller.text) ?? 0;
    }
    return otherTotal + _sliderValue;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          widget.title,
          style: TextStyle(color: widget.color),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _sliderValue.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                  _dialogController.text = value.toStringAsFixed(1);
                });
              },
              activeColor: widget.color,
            ),
            const SizedBox(height: 20),
            TextField(
              focusNode: _focusNode,
              controller: _dialogController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onSubmitted: (_) => _handleSave(),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'النسبة المئوية',
                suffixText: '%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                final doubleValue = double.tryParse(value) ?? 0;
                if (doubleValue >= 0 && doubleValue <= 100) {
                  setState(() {
                    _sliderValue = doubleValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            _buildTotalCalculation(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.color),
            onPressed: _handleSave,
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCalculation() {
    double otherTotal = 0;
    for (var controller in widget.otherControllers) {
      otherTotal += double.tryParse(controller.text) ?? 0;
    }
    final total = otherTotal + _sliderValue;

    return Column(
      children: [
        Row(
          children: [
            const Text('نسبة المجموعات الأخرى:'),
            const Spacer(),
            Text('${otherTotal.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('المجموع الكلي:'),
            const Spacer(),
            Text(
              '${total.toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: total > 100
                    ? Colors.red
                    : (total == 100 ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
        if (total > 100)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'المجموع يتجاوز 100%!',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (total < 100)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'يمكنك إضافة ${(100 - total).toStringAsFixed(1)}%',
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}
