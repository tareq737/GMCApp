import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/additional_operations/bloc/additional_operations_bloc.dart';
import 'package:gmcappclean/features/production_management/additional_operations/models/additional_operations_model.dart';
import 'package:gmcappclean/features/production_management/additional_operations/services/additional_operations_services.dart';
import 'package:gmcappclean/features/production_management/additional_operations/ui/add_additional_operation_page.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_full_data_page.dart';
import 'package:gmcappclean/features/production_management/total_production/bloc/total_production_bloc.dart';
import 'package:gmcappclean/features/production_management/total_production/models/total_production_model.dart';
import 'package:gmcappclean/features/production_management/total_production/services/total_production_services.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class TotalProductionPage extends StatelessWidget {
  const TotalProductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TotalProductionBloc(TotalProductionServices(
            apiClient: getIt<ApiClient>(),
            authInteractor: getIt<AuthInteractor>(),
          )),
        ),
        BlocProvider(
          create: (context) => AdditionalOperationsBloc(
            AdditionalOperationsServices(
              apiClient: getIt<ApiClient>(),
              authInteractor: getIt<AuthInteractor>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductionBloc(
            ProductionServices(
              apiClient: getIt<ApiClient>(),
              authInteractor: getIt<AuthInteractor>(),
            ),
          ),
        ),
      ],
      child: const TotalProductionChild(),
    );
  }
}

class TotalProductionChild extends StatefulWidget {
  const TotalProductionChild({super.key});

  @override
  State<TotalProductionChild> createState() => _TotalProductionChildState();
}

class _TotalProductionChildState extends State<TotalProductionChild> {
  int currentPage = 1;
  final _workerController = TextEditingController();
  final _date1Controller = TextEditingController();
  final _date2Controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<TotalProductionModel> resultList = [];
  List<String>? groups;
  bool? archive = false;
  String? department = "";
  List departmentList = [
    'قسم الأولية',
    'قسم التصنيع',
    'قسم المخبر',
    'قسم الفوارغ',
    'قسم التعبئة',
    'قسم الجاهزة',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // Set default value for fromDate
    _date1Controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Optionally, set a default value for toDate as well
    _date2Controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _workerController.dispose();
    _date1Controller.dispose();
    _date2Controller.dispose();
    super.dispose();
  }

  String _calculateTotalDuration() {
    Duration totalDuration = Duration.zero;

    for (var item in resultList) {
      if (item.start_time != null && item.finish_time != null) {
        try {
          DateTime start = DateFormat("hh:mm a").parse(item.start_time!);
          DateTime finish = DateFormat("hh:mm a").parse(item.finish_time!);
          totalDuration += finish.difference(start);
        } catch (e) {
          // Skip invalid time formats
          print(
              'Error parsing time: $e for item: ${item.id}'); // Add a print for debugging
        }
      }
    }

    String hours = totalDuration.inHours.toString().padLeft(2, '0');
    String minutes = (totalDuration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    AppUserState state = context.read<AppUserCubit>().state;
    List<String>? groups;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return Builder(
      builder: (context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('أعمال الموظفين'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 170,
                    child: Column(
                      // Use a Column here, not directly a Row with spacing
                      children: [
                        Row(
                          // spacing: 10, // 'spacing' is not a direct property of Row
                          children: [
                            Expanded(
                              child: MyDropdownButton(
                                value: department,
                                items: departmentList.map((type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    department = newValue;
                                  });
                                },
                                labelText: 'القسم',
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Add SizedBox for spacing
                            Expanded(
                              child: MyTextField(
                                  controller: _workerController,
                                  labelText: 'الموظف'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Add SizedBox for spacing
                        Row(
                          // spacing: 10, // 'spacing' is not a direct property of Row
                          children: [
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _date1Controller,
                                labelText: 'من تاريخ',
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _date1Controller.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Add SizedBox for spacing
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _date2Controller,
                                labelText: 'إلى تاريخ',
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _date2Controller.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Add SizedBox for spacing
                        Mybutton(
                          text: 'بحث',
                          onPressed: () {
                            resultList = []; // Clear the list on new search
                            currentPage = 1; // Reset page on new search
                            if (department == '' &&
                                _workerController.text == '') {
                              showSnackBar(
                                  context: context,
                                  content: 'يجب اختيار قسم أو موظف',
                                  failure: true);
                            } else {
                              context.read<TotalProductionBloc>().add(
                                    GetTotalProductionPagainted(
                                        page: 1,
                                        department:
                                            departmentMapping[department] ?? '',
                                        worker: _workerController.text,
                                        date1: _date1Controller.text,
                                        date2: _date2Controller.text),
                                  );
                            }
                          },
                        ),
                        // This Text widget should be inside a BlocConsumer or listen to changes
                        // in resultList for accurate display.
                        // For now, it will update when the whole widget rebuilds due to setState.
                        // The issue is that the initial call to _calculateTotalDuration might be on an empty list.
                        // It will update correctly after the first successful data fetch.
                        // We will move this into the BlocConsumer for better reactivity.
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer<AdditionalOperationsBloc,
                        AdditionalOperationsState>(
                      listener: (context, state) {
                        if (state is AdditionalOperationsSuccess<
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
                        if (state is AdditionalOperationsLoading) {
                          return const Loader();
                        }
                        return BlocConsumer<ProductionBloc, ProductionState>(
                          listener: (context, state) {
                            if (state
                                is ProductionSuccess<FullProductionModel>) {
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
                            if (state is ProductionLoading) {
                              return const Loader();
                            }
                            return BlocConsumer<TotalProductionBloc,
                                TotalProductionState>(
                              listener: (context, state) {
                                if (state is TotalProductionError) {
                                  showSnackBar(
                                    context: context,
                                    content: 'حدث خطأ ما',
                                    failure: true,
                                  );
                                } else if (state is TotalProductionSuccess<
                                    List<TotalProductionModel>>) {
                                  // Update resultList when data is successfully fetched
                                  if (currentPage == 1) {
                                    resultList = state.result;
                                  } else {
                                    resultList.addAll(state.result);
                                  }
                                  isLoadingMore = false;
                                  // Trigger a rebuild to update the total duration
                                  // This setState might be redundant if the builder already rebuilds due to state change
                                  // but it ensures the total duration is updated immediately.
                                  setState(() {});
                                }
                              },
                              builder: (context, state) {
                                if (state is TotalProductionLoading &&
                                    currentPage == 1) {
                                  return const Loader();
                                } else if (state is TotalProductionSuccess<
                                    List<TotalProductionModel>>) {
                                  // Since resultList is updated in the listener,
                                  // this builder will use the updated resultList.
                                  return Column(
                                    children: [
                                      // Display the total duration here, after resultList is populated
                                      Text(
                                        'مجموع الأوقات المعروضة: ${_calculateTotalDuration()}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: _buildTotalProductionList(
                                            context, resultList),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Handle other states or display existing data
                                  return Column(
                                    children: [
                                      Text(
                                        'مجموع الأوقات المعروضة: ${_calculateTotalDuration()}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: _buildTotalProductionList(
                                            context, resultList),
                                      ),
                                    ],
                                  );
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
        );
      },
    );
  }

  Widget _buildTotalProductionList(
      BuildContext context, List<TotalProductionModel> totalProductionModel) {
    if (resultList.isEmpty) {
      if (resultList.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.solidClipboard, // Example icon for "no data"
                size: 50,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Text(
                'لا توجد بيانات لعرضها.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: resultList.length +
          (isLoadingMore ? 1 : 0), // Add 1 for loading indicator
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
              if (resultList[index].batch_number == null) {
                context.read<AdditionalOperationsBloc>().add(
                      GetOneAdditionalOperations(id: resultList[index].id),
                    );
              }
              if (resultList[index].batch_number != null) {
                context.read<ProductionBloc>().add(
                      GetOneProductionByID(id: resultList[index].id),
                    );
              }
            },
            title: Text(
              reverseDepartmentMapping[resultList[index].department] ?? '',
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              resultList[index].operation ?? '',
              textAlign: TextAlign.right,
            ),
            leading: SizedBox(
              width: screenWidth * 0.10,
              child: Text(
                resultList[index].batch_number ?? '',
                style: const TextStyle(fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ),
            trailing: SizedBox(
              width: screenWidth * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    resultList[index].worker ?? '',
                    style: const TextStyle(fontSize: 8),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(_calculateDuration(resultList[index].start_time,
                      resultList[index].finish_time)),
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
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      // Check if the current scroll position is at the very end
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;

    context.read<TotalProductionBloc>().add(
          GetTotalProductionPagainted(
              page: currentPage,
              department: departmentMapping[department] ?? '',
              worker: _workerController.text,
              date1: _date1Controller.text,
              date2: _date2Controller.text),
        );
  }

  String _calculateDuration(String? startTime, String? finishTime) {
    if (startTime == null ||
        finishTime == null ||
        startTime.isEmpty ||
        finishTime.isEmpty) {
      return '';
    }

    try {
      // Use 'hh:mm a' to parse 12-hour format with AM/PM
      DateTime start = DateFormat("hh:mm a").parse(startTime);
      DateTime finish = DateFormat("hh:mm a").parse(finishTime);
      Duration duration = finish.difference(start);

      return "${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}";
    } catch (e) {
      print(
          'Error calculating duration for $startTime - $finishTime: $e'); // Debugging print
      return '';
    }
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
