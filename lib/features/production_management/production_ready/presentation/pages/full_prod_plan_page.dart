import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppUserState state = context.watch<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
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
                actions: [
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<ProdPlanBloc>(context).add(
                        ProdGetAll<ProdPlanViewModel>(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                  )
                ],
                title: const Text('طبخات الجهوزية'),
                centerTitle: true,
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
                            builder: (context) {
                              return const AddProdPlanPage();
                            },
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
                  BlocConsumer<ProdPlanBloc, ProdState>(
                    listener: (context, state) {
                      _handleState(context, state);
                    },
                    builder: (context, state) {
                      if (state is ProdOpLoading) {
                        return const Loader();
                      } else if (state
                          is ProdOpSuccess<List<ProdPlanViewModel>>) {
                        resultList = state.opResult;
                        return _buildProdPlanList(context, resultList);
                      } else {
                        return _buildProdPlanList(context, resultList);
                      }
                    },
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

  Widget _buildProdPlanList(
      BuildContext context, List<ProdPlanViewModel> prodPlanList) {
    return Expanded(
      child: ListView.builder(
        itemCount: prodPlanList.length,
        itemBuilder: (context, index) {
          final screenWidth = MediaQuery.of(context).size.width;

          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (
                      context,
                    ) {
                      return FullProPlanDetailsPage(
                        prodPlanViewModel: prodPlanList[index],
                      );
                    },
                  ),
                );
              },
              title: Text(
                "${prodPlanList[index].type} - ${prodPlanList[index].tier}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    prodPlanList[index].color,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDepIcon('rawMaterial',
                          prodPlanList[index].depChecks['rawMaterial']),
                      const SizedBox(width: 4),
                      _buildDepIcon('manufacturing',
                          prodPlanList[index].depChecks['manufacturing']),
                      const SizedBox(width: 4),
                      _buildDepIcon(
                          'lab', prodPlanList[index].depChecks['lab']),
                      const SizedBox(width: 4),
                      _buildDepIcon('emptyPackaging',
                          prodPlanList[index].depChecks['emptyPackaging']),
                      const SizedBox(width: 4),
                      _buildDepIcon('packaging',
                          prodPlanList[index].depChecks['packaging']),
                      const SizedBox(width: 4),
                      _buildDepIcon('finishedGoods',
                          prodPlanList[index].depChecks['finishedGoods']),
                    ],
                  )
                ],
              ),
              trailing: SizedBox(
                width: screenWidth * 0.20,
                child: Column(
                  children: [
                    Text(
                      prodPlanList[index].totalWeight != null
                          ? '${prodPlanList[index].totalWeight!.toStringAsFixed(2)} KG'
                          : '',
                    ),
                    Text(
                      prodPlanList[index].totalVolume != null
                          ? '${prodPlanList[index].totalVolume!.toStringAsFixed(2)} L'
                          : '',
                    ),
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
                      child: Text(
                        prodPlanList[index].id.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    Text(
                      prodPlanList[index].insertDate ?? '',
                      style: const TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepIcon(String department, bool? checkValue) {
    IconData icon;

    switch (department) {
      case 'rawMaterial':
        icon = FontAwesomeIcons.boxesStacked; // مواد أولية
        break;
      case 'manufacturing':
        icon = FontAwesomeIcons.industry; // تصنيع
        break;
      case 'lab':
        icon = FontAwesomeIcons.flaskVial; // مخبر
        break;
      case 'emptyPackaging':
        icon = FontAwesomeIcons.boxOpen; // فوارغ
        break;
      case 'packaging':
        icon = FontAwesomeIcons.boxesPacking; // تعبئة
        break;
      case 'finishedGoods':
        icon = FontAwesomeIcons.cubes; // مواد جاهزة
        break;
      default:
        icon = FontAwesomeIcons.circleQuestion;
    }

    return FaIcon(
      icon,
      size: 14, // uniform size for all
      color: checkValue == true ? Colors.green : Colors.red,
    );
  }
}
