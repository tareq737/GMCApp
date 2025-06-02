import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // Schedule the initial data fetch after the first frame,
    // so `context.read<AppUserCubit>()` is available.
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
  List departmentList = [
    'قسم الأولية',
    'قسم التصنيع',
    'قسم المخبر',
    'قسم الفوارغ',
    'قسم التعبئة',
    'قسم الجاهزة',
  ];

  void _initializeDepartmentAndFetchData() {
    AppUserState appUserState = context.read<AppUserCubit>().state;
    List<String>? userGroups;
    if (appUserState is AppUserLoggedIn) {
      userGroups = appUserState.userEntity.groups;
    }

    List<String> departmentListToShow = [];

    bool isAdminOrProductionManager = userGroups != null &&
        (userGroups.contains('production_managers') ||
            userGroups.contains('admins'));

    if (isAdminOrProductionManager) {
      departmentListToShow = departmentMapping.keys.toList();
    } else if (userGroups != null) {
      for (var entry in departmentMapping.entries) {
        String arabicDepartmentName = entry.key;
        String englishDepartmentCode = entry.value;

        String expectedGroup =
            '${englishDepartmentCode.toLowerCase().replaceAll(' ', '_')}_dep';

        if (englishDepartmentCode == 'RawMaterials') {
          expectedGroup = 'raw_material_dep';
        }
        if (englishDepartmentCode == 'Manufacturing') {
          expectedGroup = 'manufacturing_dep';
        }
        if (englishDepartmentCode == 'Lab') {
          expectedGroup = 'lab_dep';
        }
        if (englishDepartmentCode == 'EmptyPackaging') {
          expectedGroup = 'empty_packaging_dep';
        }
        if (englishDepartmentCode == 'Packaging') {
          expectedGroup = 'packaging_dep';
        }
        if (englishDepartmentCode == 'FinishedGoods') {
          expectedGroup = 'finished_goods_dep';
        }

        if (userGroups.contains(expectedGroup)) {
          departmentListToShow.add(arabicDepartmentName);
        }
      }
    }

    // Set the selectedDepartment based on the determined list
    setState(() {
      if (departmentListToShow.length == 1 && selectedDepartment == null) {
        selectedDepartment = departmentListToShow.first;
      } else if (selectedDepartment != null &&
          !departmentListToShow.contains(selectedDepartment)) {
        selectedDepartment = null;
        if (departmentListToShow.isNotEmpty) {
          selectedDepartment = departmentListToShow.first;
        }
      }
    });

    // Now that selectedDepartment is potentially set, trigger the bloc event
    runBloc();
  }

  @override
  Widget build(BuildContext context) {
    AppUserState state = context.read<AppUserCubit>().state;
    List<String>? groups;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    List<String> departmentListToShow = [];
    bool isAdminOrProductionManager = groups != null &&
        (groups.contains('production_managers') || groups.contains('admins'));

    if (isAdminOrProductionManager) {
      departmentListToShow = departmentMapping.keys.toList();
    } else if (groups != null) {
      // Iterate through the department mapping to find matching groups
      for (var entry in departmentMapping.entries) {
        String arabicDepartmentName = entry.key;
        String englishDepartmentCode = entry.value;

        // Construct the expected group name for this department.
        // Assuming a convention like 'raw_materials_dep' for 'RawMaterials'
        // You might need to adjust this convention based on your actual group names.
        String expectedGroup =
            '${englishDepartmentCode.toLowerCase().replaceAll(' ', '_')}_dep';

        // Special handling for "RawMaterials" if its group is "raw_material_dep" (singular)
        if (englishDepartmentCode == 'RawMaterials') {
          expectedGroup = 'raw_material_dep';
        }
        // Special handling for "Manufacturing" if its group is "manufacturing_dep"
        if (englishDepartmentCode == 'Manufacturing') {
          expectedGroup = 'manufacturing_dep';
        }
        // Special handling for "Lab" if its group is "lab_dep"
        if (englishDepartmentCode == 'Lab') {
          expectedGroup = 'lab_dep';
        }
        // Special handling for "EmptyPackaging" if its group is "empty_packaging_dep"
        if (englishDepartmentCode == 'EmptyPackaging') {
          expectedGroup = 'empty_packaging_dep';
        }
        // Special handling for "Packaging" if its group is "packaging_dep"
        if (englishDepartmentCode == 'Packaging') {
          expectedGroup = 'packaging_dep';
        }
        // Special handling for "FinishedGoods" if its group is "finished_goods_dep"
        if (englishDepartmentCode == 'FinishedGoods') {
          expectedGroup = 'finished_goods_dep';
        }

        if (groups.contains(expectedGroup)) {
          departmentListToShow.add(arabicDepartmentName);
        }
      }
    }

    // If only one department is allowed, pre-select it.
    // Or if the previously selected department is no longer in the allowed list, reset it.
    if (departmentListToShow.length == 1 && selectedDepartment == null) {
      selectedDepartment = departmentListToShow.first;
    } else if (selectedDepartment != null &&
        !departmentListToShow.contains(selectedDepartment)) {
      selectedDepartment = null; // Clear selection if no longer valid
      if (departmentListToShow.isNotEmpty) {
        selectedDepartment =
            departmentListToShow.first; // Or select the first valid one
      }
    }
    return Builder(builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: FloatingDraggableWidget(
          floatingWidget: (groups != null &&
                  (groups.contains('production_managers') ||
                      groups.contains('admins')))
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
              : const SizedBox(), // Changed from `null` to `SizedBox.shrink()`
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
                  SizedBox(
                    height: 100,
                    child: Row(
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
                  ),
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

                          return _buildAdditionalOperationsList(
                              context, state.result);
                        } else {
                          return _buildAdditionalOperationsList(
                              context, resultList);
                        }
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

  Widget _buildAdditionalOperationsList(BuildContext context,
      List<AdditionalOperationsModel> additionalOperationsModel) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: resultList.length + 1,
      itemBuilder: (context, index) {
        if (index == resultList.length) {
          // Show loading indicator at the bottom if more data is being loaded
          return isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Loader()),
                )
              : const SizedBox
                  .shrink(); // Empty space when not loading more data
        }

        final screenWidth = MediaQuery.of(context).size.width;

        return Card(
          child: ListTile(
            onLongPress: () {
              _removeItem(index);
            },
            onTap: () {
              context.read<AdditionalOperationsBloc>().add(
                    GetOneAdditionalOperations(id: resultList[index].id!),
                  );
            },
            leading: SizedBox(
              width: screenWidth * 0.1,
              child: Text(
                reverseDepartmentMapping[resultList[index].department] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 8),
              ),
            ),
            title: SizedBox(
              width: screenWidth * 0.8,
              child: Text(
                resultList[index].operation ?? '',
                textAlign: TextAlign.center,
              ),
            ),
            subtitle: SizedBox(
              width: screenWidth * 0.8,
              child: Text(
                resultList[index].notes ?? '',
                textAlign: TextAlign.center,
              ),
            ),
            trailing: SizedBox(
              width: screenWidth * 0.1,
              child: Row(
                children: [
                  Icon(
                    (resultList[index].done == true)
                        ? Icons.check
                        : Icons.close,
                    color: (resultList[index].done == true)
                        ? Colors.green
                        : Colors.red,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      resultList.removeAt(index);
    });
  }

  void _onScroll() {
    // Calculate the halfway point
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;

    // Check if the current scroll position is at or beyond the halfway point
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
            department: departmentMapping[selectedDepartment],
            done: done ?? false,
          ),
        );
  }

  final reverseDepartmentMapping = {
    'Manufacturing': 'التصنيع',
    'Lab': 'المخبر',
    'RawMaterials': 'الأولية',
    'EmptyPackaging': 'الفوارغ',
    'Packaging': 'التعبئة',
    'FinishedGoods': 'الجاهزة',
  };

  final departmentMapping = {
    'قسم التصنيع': 'Manufacturing',
    'قسم المخبر': 'Lab',
    'قسم الأولية': 'RawMaterials',
    'قسم الفوارغ': 'EmptyPackaging',
    'قسم التعبئة': 'Packaging',
    'قسم الجاهزة': 'FinishedGoods',
  };
}
