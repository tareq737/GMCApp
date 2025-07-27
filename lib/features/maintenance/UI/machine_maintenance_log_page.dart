import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/maintenance/Models/brief_maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Models/machine_model.dart';
import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Services/maintenance_services.dart';
import 'package:gmcappclean/features/maintenance/UI/Full_maintance_details_page.dart';
import 'package:gmcappclean/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:gmcappclean/init_dependencies.dart';

class MachineMaintenanceLogPage extends StatelessWidget {
  const MachineMaintenanceLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceBloc(MaintenanceServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>())),
      child: Builder(builder: (context) {
        return const MachineMaintenanceLogPageChild();
      }),
    );
  }
}

class MachineMaintenanceLogPageChild extends StatefulWidget {
  const MachineMaintenanceLogPageChild({super.key});

  @override
  State<MachineMaintenanceLogPageChild> createState() =>
      _MachineMaintenanceLogPageChildState();
}

class _MachineMaintenanceLogPageChildState
    extends State<MachineMaintenanceLogPageChild> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;
  int? selectedMachineId;
  String? selectedMachineName;
  List<BriefMaintenanceModel> maintenanceLogs = [];
  bool showSearch = true;
  List<MachineModel> searchedMachines = [];
  bool isSearchingMachines = false;
  int? selectedLogIdForDetails;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        !showSearch) {
      _loadMoreLogs();
    }
  }

  void _loadMoreLogs() {
    if (selectedMachineId == null) return;

    setState(() {
      isLoadingMore = true;
    });
    currentPage++;
    context.read<MaintenanceBloc>().add(
          GetMachineLog(page: currentPage, machineId: selectedMachineId!),
        );
  }

  void _resetSelection() {
    setState(() {
      selectedMachineId = null;
      selectedMachineName = null;
      maintenanceLogs = [];
      showSearch = true;
      currentPage = 1;
      searchedMachines = [];
      _searchController.clear();
    });
  }

  void _selectMachine(MachineModel machine) {
    setState(() {
      selectedMachineId = machine.id;
      selectedMachineName = machine.machine_code;
      showSearch = false;
      currentPage = 1;
      searchedMachines = [];
      _searchController.clear();
    });
    context.read<MaintenanceBloc>().add(
          GetMachineLog(page: 1, machineId: selectedMachineId!),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: showSearch
              ? const Text(
                  'سجل صيانة آلة',
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  'سجل صيانة: $selectedMachineName',
                  style: const TextStyle(color: Colors.white),
                ),
          actions: [
            if (!showSearch)
              IconButton(
                icon: const Icon(
                  Icons.search_off,
                  color: Colors.white,
                ),
                onPressed: _resetSelection,
              ),
          ],
        ),
        body: BlocConsumer<MaintenanceBloc, MaintenanceState>(
          listener: (context, state) {
            print('Current state: $state');
            if (state is MaintenanceError) {
              showSnackBar(
                  context: context, content: state.errorMessage, failure: true);
            } else if (state is MaintenanceSuccess<List<MachineModel>?>) {
              final machines = state.result;

              if (machines != null) {
                setState(() {
                  searchedMachines = machines;
                  isSearchingMachines = false;
                });
              }
            } else if (state
                is MaintenanceSuccess<List<BriefMaintenanceModel>?>) {
              final logs = state.result;

              if (logs != null) {
                setState(() {
                  if (currentPage == 1) {
                    maintenanceLogs = logs;
                  } else {
                    maintenanceLogs.addAll(logs);
                  }
                  isLoadingMore = false;
                });
              }
            } else if (state is MaintenanceSuccess<MaintenanceModel>) {
              setState(() {
                selectedLogIdForDetails = null;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FullMaintanceDetailsPage(
                      maintenanceModel: state.result,
                      status: 7,
                      log: true,
                    );
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (showSearch) {
              return Column(
                children: [
                  SearchRow(
                    textEditingController: _searchController,
                    onSearch: () {
                      if (_searchController.text.isNotEmpty) {
                        setState(() {
                          isSearchingMachines = true;
                        });
                        context.read<MaintenanceBloc>().add(
                              GetSearchMachines(
                                page: 1,
                                search: _searchController.text,
                              ),
                            );
                      }
                    },
                  ),
                  if (isSearchingMachines) const Center(child: Loader()),
                  if (searchedMachines.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: searchedMachines.length,
                        itemBuilder: (context, index) {
                          final machine = searchedMachines[index];
                          return ListTile(
                            title: Text(
                                '${machine.name ?? ''} - ${machine.machine_code ?? ''}'),
                            onTap: () => _selectMachine(machine),
                          );
                        },
                      ),
                    ),
                  if (!isSearchingMachines &&
                      searchedMachines.isEmpty &&
                      _searchController.text.isNotEmpty)
                    const Center(child: Text('لا توجد نتائج')),
                ],
              );
            } else {
              if (maintenanceLogs.isEmpty && state is! MaintenanceLoading) {
                return const Center(child: Text('لا توجد سجلات صيانة'));
              }

              if (state is MaintenanceLoading && currentPage == 1) {
                return const Center(child: Loader());
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          maintenanceLogs.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == maintenanceLogs.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: Loader()),
                          );
                        }

                        final screenWidth = MediaQuery.of(context).size.width;
                        final log = maintenanceLogs[index];
                        if (log.id == selectedLogIdForDetails) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: Loader()),
                          );
                        }
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedLogIdForDetails = log.id;
                            });
                            context.read<MaintenanceBloc>().add(
                                  GetOneMaintenance(id: log.id),
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
                                  log.machine_name ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              trailing: SizedBox(
                                width: screenWidth * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          log.manager_check == true
                                              ? Icons.check
                                              : log.manager_check == false
                                                  ? Icons.close
                                                  : Icons.stop_circle_outlined,
                                          color: log.manager_check == true
                                              ? Colors.green
                                              : log.manager_check == false
                                                  ? Colors.red
                                                  : Colors.grey,
                                          size: 15,
                                        ),
                                        Icon(
                                          (log.received == true)
                                              ? Icons.check
                                              : Icons.close,
                                          color: (log.received == true)
                                              ? Colors.green
                                              : Colors.red,
                                          size: 15,
                                        ),
                                        Icon(
                                          (log.archived == true)
                                              ? Icons.check
                                              : Icons.close,
                                          color: (log.archived == true)
                                              ? Colors.green
                                              : Colors.red,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                    Text(log.insert_date ?? '')
                                  ],
                                ),
                              ),
                              subtitle: SizedBox(
                                  width: screenWidth * 0.6,
                                  child: Text(
                                    log.problem ?? "",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  )),
                              leading: SizedBox(
                                width: screenWidth * 0.08,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      radius: 11,
                                      child: Text(
                                        log.id.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      log.department ?? "",
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
