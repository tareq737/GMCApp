import 'dart:ui' as ui;

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

  // Declare isAdminOrProductionManager as a state variable
  bool _isAdminOrProductionManager = false;

  void _initializeDepartmentAndFetchData() {
    AppUserState appUserState = context.read<AppUserCubit>().state;
    List<String>? userGroups;
    if (appUserState is AppUserLoggedIn) {
      userGroups = appUserState.userEntity.groups;

      // Debug print: show all user groups
      print('User Groups: $userGroups');
    }

    setState(() {
      _isAdminOrProductionManager = userGroups != null &&
          (userGroups.contains('production_managers') ||
              userGroups.contains('admins'));
    });

    List<String> departmentListToShow =
        _getDepartmentsBasedOnUserGroups(userGroups);

    // Debug print: show departments allowed on this page
    print('Allowed Departments on Page: $departmentListToShow');

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
        return 'rawMaterials_dep'; // camelCase to match user group
      case 'Manufacturing':
        return 'manufacturing_dep';
      case 'Lab':
        return 'lab_dep';
      case 'EmptyPackaging':
        return 'emptyPackaging_dep'; // camelCase fixed here
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

    // This section is now largely handled by _initializeDepartmentAndFetchData
    // but kept for ensuring UI consistency if build is called independently of initState
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
                            // Enable the dropdown if there's more than one department or if admin
                            isEnabled: departmentListToShow.length > 1 ||
                                _isAdminOrProductionManager,
                            // Show clear button only for admins/production managers
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
              width: screenWidth * 0.12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text(
                    // Parse the string into a DateTime object first
                    resultList[index].completion_date != null
                        ? DateFormat('dd/MM').format(
                            DateTime.parse(resultList[index].completion_date!))
                        : '', // Handle null case for completion_date
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 8),
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
    // Pass null for department when the selectedDepartment is null (cleared by 'X' button)
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
