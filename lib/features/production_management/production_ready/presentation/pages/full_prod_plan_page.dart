import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/pages/add_pro_plan_page.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/pages/full_pro_plan_details_page.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/prod_planning_viewmodel.dart';
import 'package:gmcappclean/init_dependencies.dart';

class FullProdPlanPage extends StatefulWidget {
  const FullProdPlanPage({super.key});

  @override
  State<FullProdPlanPage> createState() => _FullProdPlanPageState();
}

class _FullProdPlanPageState extends State<FullProdPlanPage> {
  late int userDepChoice;
  List<String>? groups;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppUserState userState = context.watch<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      groups = userState.userEntity.groups;
    }
    List<ProdPlanViewModel> resultList = [];
    return BlocProvider(
      create: (context) =>
          getIt<ProdPlanBloc>()..add(ProdGetAll<ProdPlanViewModel>()),
      child: Builder(
        builder: (context) {
          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    isDark ? AppColors.gradient2 : AppColors.lightGradient2,
                title: const Text(
                  'طبخات الجهوزية',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              floatingActionButton: (groups != null &&
                      (groups!.contains('admins') ||
                          groups!.contains('production_managers')))
                  ? FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProdPlanPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add_sharp,
                        size: 30,
                      ),
                    )
                  : null,
              body: Column(
                children: [
                  Expanded(
                    // Make BlocConsumer fill the available space
                    child: BlocConsumer<ProdPlanBloc, ProdState>(
                      listener: (context, state) {
                        _handleState(context, state);
                      },
                      builder: (context, state) {
                        if (state is ProdOpLoading) {
                          return const Loader();
                        }
                        if (state is ProdOpSuccess<List<ProdPlanViewModel>>) {
                          resultList = state.opResult;
                        }
                        // Use OrientationBuilder to switch layouts
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
        },
      ),
    );
  }

  void _handleState(BuildContext context, ProdState state) {
    if (state is ProdOpFailure) {
      showSnackBar(
        context: context,
        content: 'حدث خطأ ما',
        failure: true,
      );
    }
  }

  // --- PORTRAIT LAYOUT: Your original ListView ---
  Widget _buildProdPlanList(
      BuildContext context, List<ProdPlanViewModel> prodPlanList) {
    // This is your original ListView code, mostly unchanged.
    return ListView.builder(
      itemCount: prodPlanList.length,
      itemBuilder: (context, index) {
        final screenWidth = MediaQuery.of(context).size.width;
        final plan = prodPlanList[index];

        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullProPlanDetailsPage(prodPlanViewModel: plan),
                ),
              );
            },
            title: Text(
              "${plan.type} - ${plan.tier}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              children: [
                Text(plan.color, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDepIcon('rawMaterial', plan.depChecks['rawMaterial']),
                    const SizedBox(width: 4),
                    _buildDepIcon(
                        'manufacturing', plan.depChecks['manufacturing']),
                    const SizedBox(width: 4),
                    _buildDepIcon('lab', plan.depChecks['lab']),
                    const SizedBox(width: 4),
                    _buildDepIcon(
                        'emptyPackaging', plan.depChecks['emptyPackaging']),
                    const SizedBox(width: 4),
                    _buildDepIcon('packaging', plan.depChecks['packaging']),
                    const SizedBox(width: 4),
                    _buildDepIcon(
                        'finishedGoods', plan.depChecks['finishedGoods']),
                  ],
                )
              ],
            ),
            trailing: SizedBox(
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(plan.totalWeight != null
                      ? '${plan.totalWeight!.toStringAsFixed(2)} KG'
                      : ''),
                  Text(plan.totalVolume != null
                      ? '${plan.totalVolume!.toStringAsFixed(2)} L'
                      : ''),
                ],
              ),
            ),
            leading: SizedBox(
              width: screenWidth * 0.13,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 10,
                    child: Text(plan.id.toString(),
                        style: const TextStyle(fontSize: 8)),
                  ),
                  const SizedBox(height: 4),
                  Text(plan.insertDate ?? '',
                      style: const TextStyle(fontSize: 8)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- LANDSCAPE LAYOUT: New GridView ---
  Widget _buildProdPlanGrid(
      BuildContext context, List<ProdPlanViewModel> prodPlanList) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300, // Max width for each grid item
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.8, // Adjust the shape of the cards
      ),
      itemCount: prodPlanList.length,
      itemBuilder: (context, index) {
        return _ProdPlanGridItem(
          plan: prodPlanList[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullProPlanDetailsPage(
                  prodPlanViewModel: prodPlanList[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Reusable Icon Helper ---
  Widget _buildDepIcon(String department, bool? checkValue,
      {double size = 14}) {
    IconData icon;
    switch (department) {
      case 'rawMaterial':
        icon = FontAwesomeIcons.boxesStacked;
        break;
      case 'manufacturing':
        icon = FontAwesomeIcons.industry;
        break;
      case 'lab':
        icon = FontAwesomeIcons.flaskVial;
        break;
      case 'emptyPackaging':
        icon = FontAwesomeIcons.boxOpen;
        break;
      case 'packaging':
        icon = FontAwesomeIcons.boxesPacking;
        break;
      case 'finishedGoods':
        icon = FontAwesomeIcons.cubes;
        break;
      default:
        icon = FontAwesomeIcons.circleQuestion;
    }
    return FaIcon(
      icon,
      size: size,
      color: checkValue == true ? Colors.green : Colors.red,
    );
  }
}

// --- NEW WIDGET: Custom card for the GridView ---
class _ProdPlanGridItem extends StatelessWidget {
  final ProdPlanViewModel plan;
  final VoidCallback onTap;

  const _ProdPlanGridItem({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Top Row: ID and Weight
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 12,
                    child: Text(plan.id.toString(),
                        style: const TextStyle(fontSize: 10)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plan.totalWeight != null
                            ? '${plan.totalWeight!.toStringAsFixed(1)} KG'
                            : '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        plan.totalVolume != null
                            ? '${plan.totalVolume!.toStringAsFixed(1)} L'
                            : '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Middle: Title and Color
              Text(
                "${plan.type} - ${plan.tier}",
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(plan.color,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
              const Spacer(),
              // Bottom: Status Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  _buildDepIcon('rawMaterial', plan.depChecks['rawMaterial'],
                      size: 16),
                  _buildDepIcon(
                      'manufacturing', plan.depChecks['manufacturing'],
                      size: 16),
                  _buildDepIcon('lab', plan.depChecks['lab'], size: 16),
                  _buildDepIcon(
                      'emptyPackaging', plan.depChecks['emptyPackaging'],
                      size: 16),
                  _buildDepIcon('packaging', plan.depChecks['packaging'],
                      size: 16),
                  _buildDepIcon(
                      'finishedGoods', plan.depChecks['finishedGoods'],
                      size: 16),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // Duplicating this helper here for encapsulation, or you can pass it as a parameter
  Widget _buildDepIcon(String department, bool? checkValue,
      {double size = 14}) {
    IconData icon;
    switch (department) {
      case 'rawMaterial':
        icon = FontAwesomeIcons.boxesStacked;
        break;
      case 'manufacturing':
        icon = FontAwesomeIcons.industry;
        break;
      case 'lab':
        icon = FontAwesomeIcons.flaskVial;
        break;
      case 'emptyPackaging':
        icon = FontAwesomeIcons.boxOpen;
        break;
      case 'packaging':
        icon = FontAwesomeIcons.boxesPacking;
        break;
      case 'finishedGoods':
        icon = FontAwesomeIcons.cubes;
        break;
      default:
        icon = FontAwesomeIcons.circleQuestion;
    }
    return FaIcon(
      icon,
      size: size,
      color: checkValue == true ? Colors.green : Colors.red,
    );
  }
}
