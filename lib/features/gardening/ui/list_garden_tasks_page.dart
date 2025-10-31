import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
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
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = <int>{};
  int? count;
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
      _selectedIds.clear();
      _isSelectionMode = false;
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
              onPressed: () {
                Navigator.of(context).pop();
              },

              // Close the dialog
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

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedIds.clear();
      }
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _showDateSelectionDialog() {
    DateTime selectedDate = DateTime.now();

    // Store the original context that has access to the provider
    final originalContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر تاريخ'),
            content: SizedBox(
              height: 300,
              width: 300,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onDateChanged: (DateTime date) {
                  selectedDate = date;
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('إلغاء'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: const Text('موافق'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();

                  // Format the date as string
                  final formattedDate =
                      DateFormat("yyyy-MM-dd").format(selectedDate);

                  // Convert selected IDs to a proper list
                  final selectedIdsList = _selectedIds.toList();

                  // Print in the desired JSON format
                  print({
                    "date": formattedDate,
                    "IDs": selectedIdsList,
                  });

                  // Use the original context that has access to the provider
                  originalContext.read<GardeningBloc>().add(
                        AddGardenTasksDuplicate(
                          data: {
                            "date": formattedDate,
                            "IDs": selectedIdsList,
                          },
                        ),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // New method to handle checkDouble icon press
  void _handleCheckDoublePress() {
    if (_isSelectionMode) {
      // If already in selection mode, check the selected tasks
      if (_selectedIds.isNotEmpty) {
        context.read<GardeningBloc>().add(
              CheckListGardenTasks(IDs: _selectedIds.toList()),
            );
      } else {
        showSnackBar(
          context: context,
          content: 'يرجى تحديد مهام أولاً',
          failure: true,
        );
      }
    } else {
      // If not in selection mode, toggle selection mode
      _toggleSelectionMode();
    }
  }

  List<String>? groups;

  /// ## Portrait Item Builder
  /// Builds the list item for portrait orientation.
  Widget _buildPortraitItem(int index) {
    final item = _model[index];
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: _isSelectionMode
          ? () => _toggleSelection(item.id!)
          : () {
              context.read<GardeningBloc>().add(GetOneGardenTask(id: item.id!));
            },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            title: Text(
              item.activity!.name ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.activity!.details?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      item.activity!.details!,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (item.notes?.isNotEmpty ?? false)
                  Text(
                    item.notes!,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            leading: SizedBox(
              width: screenWidth * 0.08,
              child: _isSelectionMode
                  ? Checkbox(
                      value: _selectedIds.contains(item.id),
                      onChanged: (value) => _toggleSelection(item.id!),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 12,
                          child: Text(
                            item.id.toString(),
                            style: const TextStyle(
                                fontSize: 8, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 5),
                        FaIcon(
                          (item.done == true)
                              ? FontAwesomeIcons.solidThumbsUp
                              : FontAwesomeIcons.solidThumbsDown,
                          color:
                              (item.done == true) ? Colors.green : Colors.red,
                          size: 15,
                        )
                      ],
                    ),
            ),
            trailing: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.worker_name?.isNotEmpty ?? false)
                    Text(
                      item.worker_name!,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_formatTime(item.time_from),
                              style: const TextStyle(fontSize: 10)),
                          Text(_formatTime(item.time_to),
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _calculateTotalTime(item.time_from, item.time_to),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ## Landscape Item Builder
  /// Builds a wider list item for landscape orientation.
  Widget _buildLandscapeItem(int index) {
    final item = _model[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return InkWell(
      onTap: _isSelectionMode
          ? () => _toggleSelection(item.id!)
          : () {
              context.read<GardeningBloc>().add(GetOneGardenTask(id: item.id!));
            },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ### Leading Section (Checkbox or ID/Status)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _isSelectionMode
                    ? Checkbox(
                        value: _selectedIds.contains(item.id),
                        onChanged: (value) => _toggleSelection(item.id!),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 14,
                            child: Text(
                              item.id.toString(),
                              style: const TextStyle(
                                  fontSize: 9, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 6),
                          FaIcon(
                            (item.done == true)
                                ? FontAwesomeIcons.solidThumbsUp
                                : FontAwesomeIcons.solidThumbsDown,
                            color:
                                (item.done == true) ? Colors.green : Colors.red,
                            size: 16,
                          )
                        ],
                      ),
              ),
              const VerticalDivider(width: 1),

              // ### Task Details Section
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.activity!.name ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.activity!.details?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.activity!.details!,
                          style: TextStyle(color: textColor, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (item.notes?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 2),
                        Text(
                          "ملاحظات: ${item.notes!}",
                          style: TextStyle(color: textColor, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: 1),

              // ### Worker Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'العامل',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.worker_name ?? 'غير محدد',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: 1),

              // ### Time Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الوقت',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatTime(item.time_from)} - ${_formatTime(item.time_to)}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'الإجمالي: ${_calculateTotalTime(item.time_from, item.time_to)}',
                        style: TextStyle(color: textColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        floatingWidget: Row(
          spacing: 10,
          children: [
            FloatingActionButton(
              heroTag: 1,
              onPressed: _isSelectionMode
                  ? _showDateSelectionDialog
                  : () {
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
              child: Icon(_isSelectionMode ? Icons.date_range : Icons.add),
            ),
            FloatingActionButton(
              heroTag: 2,
              onPressed: _toggleSelectionMode,
              mini: true,
              child: FaIcon(_isSelectionMode
                  ? FontAwesomeIcons.checkSquare
                  : FontAwesomeIcons.listCheck),
            ),
          ],
        ),
        floatingWidgetWidth: 90,
        floatingWidgetHeight: 40,
        mainScreenWidget: Scaffold(
          appBar: AppBar(
            backgroundColor:
                isDark ? AppColors.gradient2 : AppColors.lightGradient2,
            title: Row(
              children: [
                Text(
                  _isSelectionMode
                      ? 'تم تحديد ${_selectedIds.length} مهمة'
                      : 'برنامج الزراعة',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (count != null && _isSelectionMode != true)
                  MyCircleAvatar(
                    text: count.toString(),
                  ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context
                      .read<GardeningBloc>()
                      .add(GetWorkerHours(date: _dateController.text));
                },
                icon: const FaIcon(FontAwesomeIcons.stopwatch,
                    color: Colors.white),
              ),
              IconButton(
                onPressed: _handleCheckDoublePress,
                icon: FaIcon(
                  FontAwesomeIcons.checkDouble,
                  color: _isSelectionMode ? Colors.amber : Colors.white,
                ),
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
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                      icon: const Icon(Icons.chevron_left),
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
                      icon: const Icon(Icons.chevron_right),
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
                              prevDate: _dateController.text,
                            );
                          },
                        ),
                      );
                    } else if (state is GardeningSuccessDuplicate) {
                      showSnackBar(
                        context: context,
                        content: 'تم إضافة ${_selectedIds.length} مهام',
                        failure: false,
                      );
                      _toggleSelectionMode();
                    } else if (state is GardeningMailSuccess) {
                      showSnackBar(
                          context: context,
                          content: 'تم إرسال الايميل للمعنين',
                          failure: false);
                    } else if (state is GardeningExcelSuccess<Uint8List>) {
                      await _saveFile(state.result);
                    } else if (state
                        is GardeningWorkerHoursSuccess<List<WorkerHourModel>>) {
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
                          final nullWorkerColor =
                              isDark ? Colors.red.shade900 : Colors.red.shade50;
                          final nullWorkerTextColor =
                              isDark ? Colors.red.shade200 : Colors.red;

                          return Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text('ساعات العمل',
                                  textAlign: TextAlign.center),
                              backgroundColor:
                                  isDark ? Colors.grey.shade900 : Colors.white,
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
                                            padding: const EdgeInsets.all(8.0),
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
                                            padding: const EdgeInsets.all(8.0),
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
                                            padding: const EdgeInsets.all(8.0),
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
                                                          ? Colors.grey.shade900
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
                                                                : Colors.green,
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
                    } else if (state is GardeningSuccessChecks) {
                      // Show success snackbar when tasks are checked
                      showSnackBar(
                        context: context,
                        content: 'تم تشطيب المهام المحددة',
                        failure: false,
                      );

                      // Exit selection mode and clear selected IDs
                      setState(() {
                        _isSelectionMode = false;
                        _selectedIds.clear();
                      });

                      // Refresh the tasks list
                      _fetchTasksWithNewDate();
                    }
                  },
                  builder: (context, state) {
                    if (state is GardeningInitial) {
                      return const SizedBox();
                    } else if (state is GardeningLoading && currentPage == 1) {
                      return const Center(
                        child: Loader(),
                      );
                    } else if (state is GardeningError && _model.isEmpty) {
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
                    } else {
                      return OrientationBuilder(
                        builder: (context, orientation) {
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
                                    : const SizedBox.shrink();
                              }

                              final itemWidget =
                                  orientation == Orientation.landscape
                                      ? _buildLandscapeItem(index)
                                      : _buildPortraitItem(index);

                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: width, end: 0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.decelerate,
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(value, 0),
                                    child: child,
                                  );
                                },
                                child: itemWidget,
                              );
                            },
                          );
                        },
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
