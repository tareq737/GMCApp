import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                                }

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
                                      child: _buildTotalProductionList(),
                                    ),
                                  ],
                                );
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

  Widget _buildTotalProductionList() {
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
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    // NEW: Use OrientationBuilder
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: resultList.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == resultList.length) {
              return isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Loader()),
                    )
                  : const SizedBox.shrink();
            }

            // NEW: Switch between layouts based on orientation
            if (orientation == Orientation.landscape) {
              return _buildLandscapeItem(index);
            } else {
              return _buildPortraitItem(index);
            }
          },
        );
      },
    );
  }

  // NEW: Refactored portrait item builder
  Widget _buildPortraitItem(int index) {
    final item = resultList[index];
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: ListTile(
        onTap: () {
          if (item.batch_number == null) {
            context.read<AdditionalOperationsBloc>().add(
                  GetOneAdditionalOperations(id: item.id),
                );
          }
          if (item.batch_number != null) {
            context.read<ProductionBloc>().add(
                  GetOneProductionByID(id: item.id),
                );
          }
        },
        title: Text(
          reverseDepartmentMapping[item.department] ?? '',
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          item.operation ?? '',
          textAlign: TextAlign.right,
        ),
        leading: SizedBox(
          width: screenWidth * 0.10,
          child: Text(
            item.batch_number ?? '',
            style: const TextStyle(fontSize: 8),
            textAlign: TextAlign.center,
          ),
        ),
        trailing: SizedBox(
          width: screenWidth * 0.20, // Increased width for better fit
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.worker ?? '',
                style: const TextStyle(fontSize: 10), // Increased font size
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _calculateDuration(item.start_time, item.finish_time),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Landscape item builder
  Widget _buildLandscapeItem(int index) {
    final item = resultList[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: InkWell(
        onTap: () {
          if (item.batch_number == null) {
            context.read<AdditionalOperationsBloc>().add(
                  GetOneAdditionalOperations(id: item.id),
                );
          }
          if (item.batch_number != null) {
            context.read<ProductionBloc>().add(
                  GetOneProductionByID(id: item.id),
                );
          }
        },
        borderRadius:
            BorderRadius.circular(12), // Match card's default border radius
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 120,
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
                      if (item.batch_number != null &&
                          item.batch_number!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'رقم الطبخة: ${item.batch_number!}',
                          style: TextStyle(fontSize: 13, color: subtitleColor),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: 1, indent: 8, endIndent: 8),
              Container(
                width: 500,
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.worker ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _calculateDuration(item.start_time, item.finish_time),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
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
