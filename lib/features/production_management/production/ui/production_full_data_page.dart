import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'dart:ui' as ui;
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_empty_packaging_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_finished_goods_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_lab_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_main_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_manufacturing_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_packaging_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_quality_control_data_widget.dart';
import 'package:gmcappclean/features/production_management/production/widgets/production_raw_material_data_widget.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ProductionFullDataPage extends StatefulWidget {
  final String type;
  final FullProductionModel fullProductionModel;

  const ProductionFullDataPage({
    super.key,
    required this.fullProductionModel,
    required this.type,
  });

  @override
  State<ProductionFullDataPage> createState() => _ProductionFullDataPageState();
}

class _ProductionFullDataPageState extends State<ProductionFullDataPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to switch tabs programmatically
  void moveToTab(int index) {
    _tabController.animateTo(index); // Moves to the given tab index
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                isDark ? AppColors.gradient2 : AppColors.lightGradient2,
            title: Text(
              'الطبخة رقم ${widget.fullProductionModel.productions.batch_number} - ${widget.fullProductionModel.productions.id}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: BlocProvider(
            create: (context) => ProductionBloc(
              ProductionServices(
                apiClient: getIt<ApiClient>(),
                authInteractor: getIt<AuthInteractor>(),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: ProductionMainDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                          moveToTab: moveToTab,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionRawMaterialDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionManufacturingDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionLabDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionEmptyPackagingDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionPackagingDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionFinishedGoodsDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ProductionQualityControlDataWidget(
                          type: widget.type,
                          fullProductionModel: widget.fullProductionModel,
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonsTabBar(
                  controller: _tabController,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  buttonMargin: const EdgeInsets.all(4),
                  backgroundColor:
                      isDark ? Colors.red.shade900 : Colors.blue.shade100,
                  unselectedBackgroundColor:
                      isDark ? Colors.grey[800] : Colors.grey[200],
                  unselectedLabelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/checklist.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/raw_materials.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/manufacturing.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/lab.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/empty_packiging.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/packaging.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/finishedGoods.png'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/images/quality_control.png'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
