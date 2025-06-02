import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      prodPlanList[index].depChecks['rawMaterial'] == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 12,
                            ),
                      prodPlanList[index].depChecks['manufacturing'] == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 12,
                            ),
                      prodPlanList[index].depChecks['lab'] == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 12,
                            ),
                      prodPlanList[index].depChecks['emptyPackaging'] == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 12,
                            ),
                      prodPlanList[index].depChecks['packaging'] == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 12,
                            ),
                      prodPlanList[index].depChecks['finishedGoods'] == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 12,
                            ),
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
}
