import 'dart:ui' as ui;

import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Added for animations
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/additional_operations/bloc/additional_operations_bloc.dart';
import 'package:gmcappclean/features/production_management/additional_operations/models/additional_operations_model.dart';
import 'package:gmcappclean/features/production_management/additional_operations/services/additional_operations_services.dart';
import 'package:gmcappclean/features/production_management/additional_operations/ui/add_additional_operation_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ListAdditionalOperationsPage extends StatelessWidget {
  const ListAdditionalOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdditionalOperationsBloc(
        AdditionalOperationsServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: const ListAdditionalOperationsChild(),
    );
  }
}

class ListAdditionalOperationsChild extends StatefulWidget {
  const ListAdditionalOperationsChild({super.key});

  @override
  State<ListAdditionalOperationsChild> createState() =>
      _ListAdditionalOperationsChildState();
}

class _ListAdditionalOperationsChildState
    extends State<ListAdditionalOperationsChild> {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDepartmentAndFetchData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String? selectedDepartment;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<AdditionalOperationsModel> resultList = [];
  bool? done = false;

  bool _isAdminOrProductionManager = false;

  void _initializeDepartmentAndFetchData() {
    AppUserState appUserState = context.read<AppUserCubit>().state;
    List<String>? userGroups;
    if (appUserState is AppUserLoggedIn) {
      userGroups = appUserState.userEntity.groups;
    }

    setState(() {
      _isAdminOrProductionManager = userGroups != null &&
          (userGroups.contains('production_managers') ||
              userGroups.contains('admins'));
    });

    List<String> departmentListToShow =
        _getDepartmentsBasedOnUserGroups(userGroups);

    setState(() {
      if (departmentListToShow.isNotEmpty) {
        if (selectedDepartment == null ||
            !departmentListToShow.contains(selectedDepartment)) {
          selectedDepartment = departmentListToShow.first;
        }
      } else {
        selectedDepartment = null;
      }
    });

    if (selectedDepartment != null || _isAdminOrProductionManager) {
      runBloc();
    }
  }

  List<String> _getDepartmentsBasedOnUserGroups(List<String>? userGroups) {
    List<String> departmentListToShow = [];

    if (_isAdminOrProductionManager) {
      departmentListToShow = departmentMapping.keys.toList();
    } else if (userGroups != null) {
      for (var entry in departmentMapping.entries) {
        String arabicDepartmentName = entry.key;
        String englishDepartmentCode = entry.value;

        String expectedGroup =
            _getExpectedGroupForDepartment(englishDepartmentCode);

        if (userGroups.contains(expectedGroup)) {
          departmentListToShow.add(arabicDepartmentName);
        }
      }
    }
    return departmentListToShow;
  }

  String _getExpectedGroupForDepartment(String englishDepartmentCode) {
    switch (englishDepartmentCode) {
      case 'RawMaterials':
        return 'raw_material_dep';
      case 'Manufacturing':
        return 'manufacturing_dep';
      case 'Lab':
        return 'lab_dep';
      case 'EmptyPackaging':
        return 'emptyPackaging_dep';
      case 'Packaging':
        return 'packaging_dep';
      case 'FinishedGoods':
        return 'finished_goods_dep';
      default:
        return '${englishDepartmentCode.toLowerCase().replaceAll(' ', '_')}_dep';
    }
  }

  @override
  Widget build(BuildContext context) {
    AppUserState state = context.read<AppUserCubit>().state;
    List<String>? groups;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    List<String> departmentListToShow =
        _getDepartmentsBasedOnUserGroups(groups);

    if (departmentListToShow.isNotEmpty) {
      if (selectedDepartment == null ||
          !departmentListToShow.contains(selectedDepartment)) {
        selectedDepartment = departmentListToShow.first;
      }
    } else {
      selectedDepartment = null;
    }

    return Builder(builder: (context) {
      return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: FloatingDraggableWidget(
          floatingWidget: (_isAdminOrProductionManager)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (
                          context,
                        ) {
                          return const AddAdditionalOperationPage();
                        },
                      ),
                    );
                  },
                  mini: true,
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
          floatingWidgetWidth: 40,
          floatingWidgetHeight: 40,
          mainScreenWidget: Scaffold(
            appBar: AppBar(
              title: const Text('الأعمال الإضافية'),
              actions: [
                IconButton(
                    onPressed: () {
                      resultList = [];
                      currentPage = 1;
                      runBloc();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: MyDropdownButton(
                          value: selectedDepartment,
                          items: departmentListToShow.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(
                              () {
                                selectedDepartment = newValue;
                              },
                            );
                            resultList = [];
                            currentPage = 1;
                            runBloc();
                          },
                          labelText: 'القسم',
                          isEnabled: departmentListToShow.length > 1 ||
                              _isAdminOrProductionManager,
                          showClearButton: false,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: CheckboxListTile(
                          title: Text(
                            (done ?? false) ? 'منهي' : 'غير منهي',
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: done,
                          onChanged: (bool? value) {
                            setState(() {
                              done = value;
                            });
                            resultList = [];
                            currentPage = 1;
                            runBloc();
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocConsumer<AdditionalOperationsBloc,
                        AdditionalOperationsState>(
                      listener: (context, state) {
                        if (state is AdditionalOperationsError) {
                          showSnackBar(
                            context: context,
                            content: 'حدث خطأ ما',
                            failure: true,
                          );
                        } else if (state is AdditionalOperationsSuccess<
                            AdditionalOperationsModel>) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) {
                                return AddAdditionalOperationPage(
                                    additionalOperationsModel: state.result);
                              },
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AdditionalOperationsLoading &&
                            currentPage == 1) {
                          return const Loader();
                        } else if (state is AdditionalOperationsSuccess<
                            List<AdditionalOperationsModel>>) {
                          if (currentPage == 1) {
                            resultList = state.result;
                          } else {
                            resultList.addAll(state.result);
                          }
                          isLoadingMore = false;
                        }

                        if (resultList.isEmpty && !isLoadingMore) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidClipboard,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'لا توجد بيانات لعرضها.',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }

                        return OrientationBuilder(
                          builder: (context, orientation) {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: resultList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == resultList.length) {
                                  return isLoadingMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(child: Loader()),
                                        )
                                      : const SizedBox.shrink();
                                }
                                if (orientation == Orientation.landscape) {
                                  return _buildLandscapeItem(index);
                                } else {
                                  return _buildPortraitItem(index);
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPortraitItem(int index) {
    final item = resultList[index];
    return Card(
      child: ListTile(
        onTap: () {
          context.read<AdditionalOperationsBloc>().add(
                GetOneAdditionalOperations(id: item.id!),
              );
        },
        leading: Text(
          reverseDepartmentMapping[item.department] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
        title: Text(item.operation ?? ''),
        subtitle: Text(item.notes ?? ''),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              (item.done == true) ? Icons.check : Icons.close,
              color: (item.done == true) ? Colors.green : Colors.red,
              size: 18,
            ),
            Text(
              item.completion_date != null
                  ? DateFormat('dd/MM')
                      .format(DateTime.parse(item.completion_date!))
                  : '',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(
          begin: 0.5,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildLandscapeItem(int index) {
    final item = resultList[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: InkWell(
        onTap: () {
          context.read<AdditionalOperationsBloc>().add(
                GetOneAdditionalOperations(id: item.id!),
              );
        },
        borderRadius:
            BorderRadius.circular(12), // Match card's default border radius
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Center(
                  child: Text(
                    reverseDepartmentMapping[item.department] ?? 'N/A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.operation ?? 'No Operation',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.notes!,
                          style: TextStyle(fontSize: 13, color: noteColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: 1, indent: 8, endIndent: 8),
              Container(
                width: 90,
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (item.done == true) ? Icons.check_circle : Icons.cancel,
                      color: (item.done == true) ? Colors.green : Colors.red,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.completion_date != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(item.completion_date!))
                          : 'N/A',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms).slideX(
          begin: 0.5,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
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
    context.read<AdditionalOperationsBloc>().add(
          GetAdditionalOperationsPagainted(
            page: currentPage,
            department: selectedDepartment == null
                ? null
                : departmentMapping[selectedDepartment],
            done: done ?? false,
          ),
        );
  }

  final reverseDepartmentMapping = {
    'RawMaterials': 'الأولية',
    'Manufacturing': 'التصنيع',
    'Lab': 'المخبر',
    'EmptyPackaging': 'الفوارغ',
    'Packaging': 'التعبئة',
    'FinishedGoods': 'الجاهزة',
  };

  final departmentMapping = {
    'قسم الأولية': 'RawMaterials',
    'قسم التصنيع': 'Manufacturing',
    'قسم المخبر': 'Lab',
    'قسم الفوارغ': 'EmptyPackaging',
    'قسم التعبئة': 'Packaging',
    'قسم الجاهزة': 'FinishedGoods',
  };
}
