import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/maintenance/Models/brief_maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Services/maintenance_services.dart';
import 'package:gmcappclean/features/maintenance/UI/Full_maintance_details_page.dart';
import 'package:gmcappclean/features/maintenance/UI/add_maintenance_page.dart';
import 'package:gmcappclean/features/maintenance/UI/machine_maintenance_log_page.dart';
import 'package:gmcappclean/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'dart:ui' as ui;

class MaintenanceListPage extends StatelessWidget {
  final int status;
  const MaintenanceListPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceBloc(MaintenanceServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetAllMaintenance(page: 1, status: status, department: ''),
        ),
      child: Builder(builder: (context) {
        return MaintenanceListChild(
          status: status,
        );
      }),
    );
  }
}

class MaintenanceListChild extends StatefulWidget {
  final int status;
  const MaintenanceListChild({super.key, required this.status});

  @override
  State<MaintenanceListChild> createState() => _MaintenanceListChildState();
}

class _MaintenanceListChildState extends State<MaintenanceListChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<BriefMaintenanceModel> _briefMaintenance = [];
  final Map<int, String> _itemStatus = {
    1: 'الطلبات الغير موافقة من المدير',
    2: 'الطلبات الموافقة من المدير',
    3: 'الطلبات المرفوضة من المدير',
    4: 'الطلبات الموافقة من المدير وغير منفذة',
    5: 'الطلبات الغير مستلمة',
    6: 'كافة الطلبات الغير مؤرشفة',
    7: 'كافة طلبات الصيانة',
  };
  final List<String> _itemsDepartment = [
    'الأولية',
    'الصيانة',
    'التصنيع',
    'التعبئة',
    'الجاهزة',
    'الزراعة',
    'المخبر',
    'الجودة',
    'المكيفات',
    'الخدمات',
    'IT',
    'المركبات',
    'شركة النور',
  ];

  late String _selectedStatus;
  String? _selectedItemDepartment;
  List<String>? groups;

  @override
  void initState() {
    super.initState();
    _selectedStatus = _getItemStatusString(widget.status);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Builder(builder: (context) {
      return BlocListener<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceError) {
            showSnackBar(
                context: context, content: 'حدث خطأ ما', failure: true);
          }
        },
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AddMaintenancePage();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MachineMaintenanceLogPage();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.list_alt,
                    color: Colors.white,
                  ),
                ),
              ],
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'طلبات الصيانة',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Dropdown for Status
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          hint: Text(
                            'الحالة',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade200
                                  : Colors.teal.shade700,
                            ),
                          ),
                          value: _selectedStatus,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // Add null check
                              setState(() {
                                currentPage = 1;
                                _selectedStatus = newValue;
                              });
                              _briefMaintenance = [];
                              runBloc();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: _itemStatus.values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey.shade200
                                        : Colors.teal.shade700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dropdown for Section
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                hint: Text(
                                  'القسم',
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade200
                                          : Colors.orange.shade700),
                                ),
                                value: _selectedItemDepartment,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentPage = 1;
                                    _selectedItemDepartment = newValue;
                                  });
                                  _briefMaintenance = [];
                                  runBloc();
                                },
                                isExpanded: true,
                                underline:
                                    const SizedBox(), // Remove the default underline
                                items: _itemsDepartment
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.grey.shade200
                                                : Colors.orange
                                                    .shade700), // Dropdown text color
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            if (_selectedItemDepartment !=
                                null) // Show clear button only if a value is selected
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedItemDepartment = null;
                                  });
                                  _briefMaintenance = [];
                                  runBloc();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: BlocConsumer<MaintenanceBloc, MaintenanceState>(
                    listener: (context, state) {
                      if (state is MaintenanceError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      } else if (state
                          is MaintenanceSuccess<List<BriefMaintenanceModel>>) {
                        setState(
                          () {
                            if (currentPage == 1) {
                              _briefMaintenance =
                                  state.result; // First page, replace data
                            } else {
                              _briefMaintenance
                                  .addAll(state.result); // Append new data
                            }
                            isLoadingMore = false;
                          },
                        );
                      } else if (state
                          is MaintenanceSuccess<MaintenanceModel>) {
                        int statusID = _getItemStatusID();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FullMaintanceDetailsPage(
                                maintenanceModel: state.result,
                                status: statusID,
                                log: true,
                              );
                            },
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is MaintenanceInitial) {
                        return const SizedBox();
                      } else if (state is MaintenanceLoading &&
                          currentPage == 1) {
                        return const Center(
                          child: Loader(),
                        );
                      } else if (state is MaintenanceError) {
                        return const Center(child: Text('حدث خطأ ما'));
                      } else if (_briefMaintenance.isEmpty) {
                        // This is the new condition for empty list
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد طلبات صيانة لعرضها',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (_briefMaintenance.isNotEmpty) {
                        return Builder(builder: (context) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: _briefMaintenance.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _briefMaintenance.length) {
                                return isLoadingMore
                                    ? const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(child: Loader()),
                                      )
                                    : const SizedBox
                                        .shrink(); // Empty space when not loading more data
                              }

                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              return InkWell(
                                onTap: () {
                                  context.read<MaintenanceBloc>().add(
                                        GetOneMaintenance(
                                            id: _briefMaintenance[index].id),
                                      );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: SizedBox(
                                      width: screenWidth * 0.20,
                                      child: Text(
                                        _briefMaintenance[index].machine_name ??
                                            "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: screenWidth * 0.25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                _briefMaintenance[index]
                                                            .manager_check ==
                                                        true
                                                    ? Icons
                                                        .check // ✅ If true, show check mark
                                                    : _briefMaintenance[index]
                                                                .manager_check ==
                                                            false
                                                        ? Icons.close
                                                        : Icons
                                                            .stop_circle_outlined,
                                                color: _briefMaintenance[index]
                                                            .manager_check ==
                                                        true
                                                    ? Colors.green
                                                    : _briefMaintenance[index]
                                                                .manager_check ==
                                                            false
                                                        ? Colors.red
                                                        : Colors.grey,
                                                size: 15,
                                              ),
                                              Icon(
                                                (_briefMaintenance[index]
                                                            .received ==
                                                        true)
                                                    ? Icons.check
                                                    : Icons.close,
                                                color: (_briefMaintenance[index]
                                                            .received ==
                                                        true)
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 15,
                                              ),
                                              Icon(
                                                (_briefMaintenance[index]
                                                            .archived ==
                                                        true)
                                                    ? Icons.check
                                                    : Icons.close,
                                                color: (_briefMaintenance[index]
                                                            .archived ==
                                                        true)
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          Text(_briefMaintenance[index]
                                                  .insert_date ??
                                              '')
                                        ],
                                      ),
                                    ),
                                    subtitle: SizedBox(
                                        width: screenWidth * 0.6,
                                        child: Text(
                                          _briefMaintenance[index].problem ??
                                              "",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        )),
                                    leading: SizedBox(
                                      width: screenWidth * 0.08,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.teal,
                                            radius: 11,
                                            child: Text(
                                              _briefMaintenance[index]
                                                  .id
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8),
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            _briefMaintenance[index]
                                                    .department ??
                                                "",
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      } else if (state is MaintenanceError) {
                        return const Center(
                          child: Text(
                            'حدث خطأ ما',
                          ),
                        );
                      } else {
                        return const Center(
                          child: Loader(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
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

  String _getItemStatusString(int statusID) {
    return _itemStatus[statusID] ?? '';
  }

  int _getItemStatusID() {
    // Find the entry in the _itemStatus map where the value matches _selectedItemStatus
    var entry = _itemStatus.entries.firstWhere(
      (entry) => entry.value == _selectedStatus,
      orElse: () =>
          const MapEntry(-1, ''), // Default entry if no match is found
    );

    // If a matching entry is found, return its key (status ID)
    if (entry.key != -1) {
      return entry.key;
    }

    // If no matching entry is found, return null
    return 1;
  }

  void runBloc() {
    int statusID = _getItemStatusID();
    context.read<MaintenanceBloc>().add(
          GetAllMaintenance(
              page: currentPage,
              status: statusID,
              department: _selectedItemDepartment ?? ''),
        );
  }
}
