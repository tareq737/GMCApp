import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/gardening/bloc/gardening_bloc.dart';
import 'package:gmcappclean/features/gardening/models/garden_tasks_model.dart';
import 'package:gmcappclean/features/gardening/models/worker_hour_model.dart';
import 'package:gmcappclean/features/gardening/services/gardening_services.dart';
import 'package:gmcappclean/features/gardening/ui/garden_task_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ListGardenTasksPage extends StatelessWidget {
  final String? prevDate;
  const ListGardenTasksPage({
    super.key,
    this.prevDate,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final dateToUse = prevDate ?? formattedDate;

    return BlocProvider(
      create: (context) => GardeningBloc(GardeningServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      ))
        ..add(
          GetAllGardenTasks(
            page: 1,
            date1: dateToUse,
            date2: dateToUse,
          ),
        ),
      child: Builder(builder: (context) {
        return ListGardenTasksPageChild(
          prevDate: prevDate,
        );
      }),
    );
  }
}

class ListGardenTasksPageChild extends StatefulWidget {
  final String? prevDate;
  const ListGardenTasksPageChild({
    super.key,
    this.prevDate,
  });

  @override
  State<ListGardenTasksPageChild> createState() =>
      _ListGardenTasksPageChildState();
}

class _ListGardenTasksPageChildState extends State<ListGardenTasksPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<GardenTasksModel> _model = [];
  final _dateController = TextEditingController();
  double width = 0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _dateController.text =
        widget.prevDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dateController.dispose();
    super.dispose();
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
    context.read<GardeningBloc>().add(
          GetAllGardenTasks(
            page: currentPage,
            date1: _dateController.text,
            date2: _dateController.text,
          ),
        );
  }

  void _fetchTasksWithNewDate() {
    setState(() {
      currentPage = 1; // Reset to first page when date changes
      _model = []; // Clear existing data
    });

    // Trigger the bloc event with the new date
    context.read<GardeningBloc>().add(
          GetAllGardenTasks(
            page: 1,
            date1: _dateController.text,
            date2: _dateController.text,
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
    if (from == null || to == null)
      return '--:--'; // Return dashes for null values

    try {
      final fromParts = from.split(':');
      final toParts = to.split(':');

      if (fromParts.length >= 2 && toParts.length >= 2) {
        final fromHour = int.parse(fromParts[0]);
        final fromMin = int.parse(fromParts[1]);
        final toHour = int.parse(toParts[0]);
        final toMin = int.parse(toParts[1]);

        final totalMinutes = (toHour * 60 + toMin) - (fromHour * 60 + fromMin);

        // Calculate hours and minutes
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;

        // Format as hh:mm with leading zeros
        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }
      return '--:--'; // Return dashes if time format is invalid
    } catch (e) {
      return '--:--'; // Return dashes if any error occurs
    }
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();

      const fileName = 'تقرير عمل الزراعة.xlsx';
      final path = '${directory.path}\\$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

      // Open the file
      final result = await OpenFilex.open(path);

      if (result.type != ResultType.done) {
        await _showDialog('Error', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      await _showDialog('Error', 'Failed to save/open file:\n$e');
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeDate(int daysToAdd) {
    final currentDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    final newDate = currentDate.add(Duration(days: daysToAdd));

    setState(() {
      _dateController.text = DateFormat('yyyy-MM-dd').format(newDate);
    });
    _fetchTasksWithNewDate();
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
        child: FloatingDraggableWidget(
          floatingWidget: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (
                    context,
                  ) {
                    return GardenTaskPage(
                      prevDate: _dateController.text,
                    );
                  },
                ),
              );
            },
            mini: true,
            child: const Icon(Icons.add),
          ),
          floatingWidgetWidth: 40,
          floatingWidgetHeight: 40,
          mainScreenWidget: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'برنامج الزراعة',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                // Worker hours button remains as IconButton
                IconButton(
                  onPressed: () {
                    context
                        .read<GardeningBloc>()
                        .add(GetWorkerHours(date: _dateController.text));
                  },
                  icon: const FaIcon(FontAwesomeIcons.stopwatch,
                      color: Colors.white),
                ),

                //if (Platform.isWindows)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'email') {
                      context
                          .read<GardeningBloc>()
                          .add(GetMailOfTasks(date: _dateController.text));
                    } else if (value == 'excel') {
                      context.read<GardeningBloc>().add(
                          ExportExcelGardenTasks(date: _dateController.text));
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'email',
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.envelope, size: 16),
                          SizedBox(width: 8),
                          Text('إرسال بالايميل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'excel',
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.fileExport, size: 16),
                          SizedBox(width: 8),
                          Text('تصدير لإكسل'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () => _changeDate(-1),
                      ),
                      Expanded(
                        child: MyTextField(
                          readOnly: true,
                          controller: _dateController,
                          labelText: 'تاريخ المهام',
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                              _fetchTasksWithNewDate();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () => _changeDate(1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: BlocConsumer<GardeningBloc, GardeningState>(
                    listener: (context, state) async {
                      print(state);
                      if (state is GardeningError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      } else if (state
                          is GardeningSuccess<List<GardenTasksModel>>) {
                        setState(
                          () {
                            if (currentPage == 1) {
                              _model = state.result; // First page, replace data
                            } else {
                              _model.addAll(state.result); // Append new data
                            }
                            isLoadingMore = false;
                          },
                        );
                      } else if (state is GardeningSuccess<GardenTasksModel>) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GardenTaskPage(
                                gardenTasksModel: state.result,
                                prevDate: _dateController.text,
                              );
                            },
                          ),
                        );
                      } else if (state is GardeningMailSuccess) {
                        showSnackBar(
                            context: context,
                            content: 'تم إرسال الايميل للمعنين',
                            failure: false);
                      } else if (state is GardeningExcelSuccess<Uint8List>) {
                        await _saveFile(state.result);
                      } else if (state is GardeningWorkerHoursSuccess<
                          List<WorkerHourModel>>) {
                        // Open dialog with the result
                        showDialog(
                          context: context,
                          builder: (context) {
                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;
                            final borderColor = isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300;
                            final headerColor = isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200;
                            final textColor =
                                isDark ? Colors.white : Colors.black;
                            final nullWorkerColor = isDark
                                ? Colors.red.shade900
                                : Colors.red.shade50;
                            final nullWorkerTextColor =
                                isDark ? Colors.red.shade200 : Colors.red;

                            return Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: AlertDialog(
                                title: const Text('ساعات العمل',
                                    textAlign: TextAlign.center),
                                backgroundColor: isDark
                                    ? Colors.grey.shade900
                                    : Colors.white,
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: SingleChildScrollView(
                                    child: Table(
                                      border: TableBorder.all(
                                        color: borderColor,
                                        width: 1,
                                      ),
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(1.5),
                                        2: FlexColumnWidth(1.5),
                                      },
                                      children: [
                                        // Table header
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: headerColor,
                                          ),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'اسم العامل',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'المطلوب',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'المكتمل',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Table rows
                                        ...state.result
                                            .map((worker) => TableRow(
                                                  decoration: BoxDecoration(
                                                    color: worker.worker_name ==
                                                            null
                                                        ? nullWorkerColor
                                                        : isDark
                                                            ? Colors
                                                                .grey.shade900
                                                            : Colors.white,
                                                  ),
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        worker.worker_name ??
                                                            'غير معروف',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              worker.worker_name ==
                                                                      null
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                          color: worker
                                                                      .worker_name ==
                                                                  null
                                                              ? nullWorkerTextColor
                                                              : textColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        worker.total_hours ??
                                                            '--:--',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        worker.completed_hours ??
                                                            '--:--',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: worker
                                                                      .completed_hours ==
                                                                  '0:00'
                                                              ? isDark
                                                                  ? Colors.red
                                                                      .shade300
                                                                  : Colors.red
                                                              : isDark
                                                                  ? Colors.green
                                                                      .shade300
                                                                  : Colors
                                                                      .green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'إغلاق',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.blue.shade200
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GardeningInitial) {
                        return const SizedBox();
                      } else if (state is GardeningLoading &&
                          currentPage == 1) {
                        return const Center(
                          child: Loader(),
                        );
                      } else if (state is GardeningError) {
                        return const Center(child: Text('حدث خطأ ما'));
                      } else if (_model.isEmpty) {
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
                        return Builder(builder: (context) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: _model.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _model.length) {
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                        title: SizedBox(
                                          width: screenWidth * 0.20,
                                          child: Text(
                                            _model[index].activity!.name ?? "",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  14, // Explicit font size
                                            ),
                                            maxLines:
                                                1, // Prevent text overflow
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        subtitle: SizedBox(
                                          width: screenWidth * 0.6,
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Take minimum vertical space
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (_model[index]
                                                      .activity!
                                                      .details
                                                      ?.isNotEmpty ??
                                                  false)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2.0),
                                                  child: Text(
                                                    _model[index]
                                                        .activity!
                                                        .details!,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize:
                                                          12, // Smaller font size
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              if (_model[index]
                                                      .notes
                                                      ?.isNotEmpty ??
                                                  false)
                                                Text(
                                                  _model[index].notes!,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize:
                                                        12, // Smaller font size
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        ),
                                        leading: SizedBox(
                                          width: screenWidth * 0.08,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 5,
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
                                                    ? FontAwesomeIcons
                                                        .solidThumbsUp
                                                    : FontAwesomeIcons
                                                        .solidThumbsDown,
                                                color:
                                                    (_model[index].done == true)
                                                        ? Colors.green
                                                        : Colors.red,
                                                size: 15,
                                              )
                                            ],
                                          ),
                                        ),
                                        trailing: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: screenWidth *
                                                0.25, // Limit trailing width
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Take minimum vertical space
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              const SizedBox(height: 2),
                                              Row(
                                                spacing: 5,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        _formatTime(
                                                            _model[index]
                                                                .time_from),
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        _formatTime(
                                                            _model[index]
                                                                .time_to),
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
                        });
                      } else if (state is GardeningError) {
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
        ));
  }
}
