import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/gardening/bloc/gardening_bloc.dart';
import 'package:gmcappclean/features/gardening/models/garden_activities_model.dart';
import 'package:gmcappclean/features/gardening/models/garden_tasks_model.dart';
import 'package:gmcappclean/features/gardening/services/gardening_services.dart';
import 'package:gmcappclean/features/gardening/ui/garden_task_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class GenralListGardenTasksPage extends StatelessWidget {
  const GenralListGardenTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    return BlocProvider(
      create: (context) => GardeningBloc(GardeningServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      ))
        ..add(
          GetAllGardenTasks(
            page: 1,
            date1: formattedDate,
            date2: formattedDate,
          ),
        ),
      child: Builder(builder: (context) {
        return const GenralListGardenTasksPageChild();
      }),
    );
  }
}

class GenralListGardenTasksPageChild extends StatefulWidget {
  const GenralListGardenTasksPageChild({super.key});

  @override
  State<GenralListGardenTasksPageChild> createState() =>
      _GenralListGardenTasksPageChildState();
}

class _GenralListGardenTasksPageChildState
    extends State<GenralListGardenTasksPageChild> {
  int currentPage = 1;
  bool hasReachedMax = false;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<GardenTasksModel> _model = [];
  final _date1Controller = TextEditingController();
  final _date2Controller = TextEditingController();
  String? selectedActivity;
  String? selectedDetail;
  List<String> activities = [];
  List<String> details = [];
  List<GardenActivitiesModel> gardenActivityDetails = [];
  List<String> workers = [];
  String? selectedWorker;
  double width = 0;
  int? count;
  @override
  void initState() {
    super.initState();
    context
        .read<GardeningBloc>()
        .add(GetAllGardeningWorkers(department: 'قسم الزراعة'));
    context.read<GardeningBloc>().add(GetAllGardenActivities());

    _scrollController.addListener(_onScroll);
    _date1Controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _date2Controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _date1Controller.dispose();
    _date2Controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !isLoadingMore &&
        !hasReachedMax) {
      _nextPage();
    }
  }

  void _nextPage() {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;

    context.read<GardeningBloc>().add(
          GetAllGardenTasks(
            page: currentPage,
            date1: _date1Controller.text,
            date2: _date2Controller.text,
            activity_details: selectedDetail,
            worker: selectedWorker,
            activity_name: selectedActivity,
          ),
        );
  }

  void _fetchTasksWithNewfilter() {
    _model.clear();
    setState(() {
      currentPage = 1;
      hasReachedMax = false;
    });

    context.read<GardeningBloc>().add(
          GetAllGardenTasks(
            page: currentPage,
            date1: _date1Controller.text,
            date2: _date2Controller.text,
            activity_details: selectedDetail,
            worker: selectedWorker,
            activity_name: selectedActivity,
          ),
        );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
      return time;
    } catch (e) {
      return '--:--';
    }
  }

  String _calculateTotalTime(String? from, String? to) {
    if (from == null || to == null) return '--:--';

    try {
      final fromParts = from.split(':');
      final toParts = to.split(':');

      if (fromParts.length >= 2 && toParts.length >= 2) {
        final fromHour = int.parse(fromParts[0]);
        final fromMin = int.parse(fromParts[1]);
        final toHour = int.parse(toParts[0]);
        final toMin = int.parse(toParts[1]);

        final totalMinutes = (toHour * 60 + toMin) - (fromHour * 60 + fromMin);
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;

        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }
      return '--:--';
    } catch (e) {
      return '--:--';
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  List<String>? groups;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    width = MediaQuery.of(context).size.width;
    AppUserState state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Row(
            children: [
              const Text(
                'برنامج الزراعة العام',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              if (count != null)
                MyCircleAvatar(
                  text: count.toString(),
                ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: MyTextField(
                        readOnly: true,
                        controller: _date1Controller,
                        labelText: 'من التاريخ',
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
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                            _fetchTasksWithNewfilter();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: MyTextField(
                        readOnly: true,
                        controller: _date2Controller,
                        labelText: 'إلى التاريخ',
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
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                            _fetchTasksWithNewfilter();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDropdownButton(
                  value: selectedActivity,
                  items: activities.map((activity) {
                    return DropdownMenuItem<String>(
                      value: activity,
                      child: Text(activity),
                    );
                  }).toList(),
                  labelText: 'العمل',
                  onChanged: (value) {
                    setState(() {
                      selectedActivity = value;
                      selectedDetail = null;
                      details = [];
                    });

                    if (value != null) {
                      context.read<GardeningBloc>().add(
                            GetAllGardenActivitiesDetails(name: value),
                          );
                    }
                    _fetchTasksWithNewfilter();
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDropdownButton(
                  value: selectedDetail,
                  items: details.map((detail) {
                    return DropdownMenuItem<String>(
                      value: detail,
                      child: Text(detail),
                    );
                  }).toList(),
                  labelText: 'التفاصيل',
                  onChanged: (value) {
                    setState(() {
                      selectedDetail = value;
                    });
                    _fetchTasksWithNewfilter();
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDropdownButton(
                  value: selectedWorker,
                  items: workers.map((worker) {
                    return DropdownMenuItem<String>(
                      value: worker,
                      child: Text(worker),
                    );
                  }).toList(),
                  labelText: 'اسم العامل',
                  onChanged: (value) {
                    setState(() {
                      selectedWorker = value;
                    });
                    _fetchTasksWithNewfilter();
                  },
                ),
              ),
              Expanded(
                flex: 14,
                child: BlocConsumer<GardeningBloc, GardeningState>(
                  listener: (context, state) async {
                    if (state is GardeningError) {
                      showSnackBar(
                        context: context,
                        content: 'حدث خطأ ما',
                        failure: true,
                      );
                    } else if (state is GardeningSuccess<PageintedResult>) {
                      bool shouldRebuildAppBar = false;
                      if (count == null ||
                          currentPage == 1 ||
                          state.result.totalCount! > 0) {
                        shouldRebuildAppBar = count != state.result.totalCount;
                        count = state.result.totalCount;
                      }
                      if (currentPage == 1) {
                        _model = state.result.results.cast<GardenTasksModel>();
                      } else {
                        final newResults =
                            state.result.results.cast<GardenTasksModel>();
                        if (newResults.isNotEmpty) {
                          _model.addAll(newResults);
                        }
                      }
                      isLoadingMore = false;

                      if (shouldRebuildAppBar) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {});
                          }
                        });
                      }
                    } else if (state is GardeningSuccess<GardenTasksModel>) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return GardenTaskPage(
                              gardenTasksModel: state.result,
                            );
                          },
                        ),
                      );
                    } else if (state is GardeningSuccess<List>) {
                      final resultList = state.result;

                      if (resultList.isNotEmpty && resultList.first is String) {
                        setState(() {
                          activities = List<String>.from(
                              resultList.map((e) => e.toString()));
                        });
                      } else if (resultList.isNotEmpty &&
                          resultList.first is GardenActivitiesModel) {
                        setState(() {
                          gardenActivityDetails =
                              List<GardenActivitiesModel>.from(resultList);
                          details = gardenActivityDetails
                              .map((e) => e.details!.trim())
                              .toList();
                        });
                      }
                    } else if (state is GetWorkerSuccess<List<dynamic>>) {
                      final resultList = state.result;
                      if (resultList.isNotEmpty && resultList.first is String) {
                        setState(() {
                          workers = List<String>.from(
                              resultList.map((e) => e.toString()));
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is GardeningInitial) {
                      return const SizedBox();
                    } else if (state is GardeningLoading && currentPage == 1) {
                      return const Center(child: Loader());
                    } else if (state is GardeningError) {
                      return const Center(child: Text('حدث خطأ ما'));
                    } else if (_model.isEmpty) {
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
                              'لا توجد مهام لعرضها',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (_model.isNotEmpty) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: _model.length + (hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == _model.length) {
                            return isLoadingMore
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: Loader()),
                                  )
                                : const SizedBox.shrink();
                          }

                          final screenWidth = MediaQuery.of(context).size.width;
                          return InkWell(
                            onTap: () {
                              context.read<GardeningBloc>().add(
                                    GetOneGardenTask(id: _model[index].id!),
                                  );
                            },
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: width, end: 0),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.decelerate,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(value, 0),
                                  child: child,
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    title: SizedBox(
                                      width: screenWidth * 0.20,
                                      child: Text(
                                        _model[index].activity!.name ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    subtitle: SizedBox(
                                      width: screenWidth * 0.6,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (_model[index]
                                                  .activity!
                                                  .details
                                                  ?.isNotEmpty ??
                                              false)
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Text(
                                                _model[index]
                                                    .activity!
                                                    .details!,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          if (_model[index].notes?.isNotEmpty ??
                                              false)
                                            Text(
                                              _model[index].notes!,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                    leading: SizedBox(
                                      width: screenWidth * 0.08,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 1,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.teal,
                                            radius: 12,
                                            child: Text(
                                              _model[index].id.toString(),
                                              style: const TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          FaIcon(
                                            (_model[index].done == true)
                                                ? FontAwesomeIcons.solidThumbsUp
                                                : FontAwesomeIcons
                                                    .solidThumbsDown,
                                            color: (_model[index].done == true)
                                                ? Colors.green
                                                : Colors.red,
                                            size: 10,
                                          ),
                                          Text(
                                            _formatDate(_model[index].date),
                                            style: const TextStyle(
                                              fontSize: 8,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: screenWidth * 0.25,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (_model[index]
                                                  .worker_name
                                                  ?.isNotEmpty ??
                                              false)
                                            Text(
                                              _model[index].worker_name!,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const SizedBox(height: 2),
                                          Row(
                                            spacing: 5,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _formatTime(_model[index]
                                                        .time_from),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatTime(
                                                        _model[index].time_to),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _calculateTotalTime(
                                                  _model[index].time_from,
                                                  _model[index].time_to,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is GardeningError) {
                      return const Center(
                        child: Text('حدث خطأ ما'),
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
  }
}
