import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/attendance_logs_model.dart';
import 'package:gmcappclean/features/HR/models/overtime_model.dart';
import 'package:gmcappclean/features/HR/models/workleaves_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/features/HR/ui/overtime/overtime_page.dart';
import 'package:gmcappclean/features/HR/ui/work%20leaves/work_leaves_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class AttendanceLogeListPage extends StatelessWidget {
  const AttendanceLogeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return BlocProvider(
      create: (context) => HrBloc(
        HrServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetAttendanceLogs(page: 1, date: todayDate)),
      child: const AttendanceLogeListPageChild(),
    );
  }
}

class AttendanceLogeListPageChild extends StatefulWidget {
  const AttendanceLogeListPageChild({super.key});

  @override
  State<AttendanceLogeListPageChild> createState() =>
      _AttendanceLogeListPageChildState();
}

class _AttendanceLogeListPageChildState
    extends State<AttendanceLogeListPageChild> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _dateController = TextEditingController();

  int currentPage = 1;
  bool isLoadingMore = false;
  List<AttendanceLogsModel> resultList = [];
  int? count;
  double width = 0;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() => isLoadingMore = true);
    currentPage++;
    context.read<HrBloc>().add(
          GetAttendanceLogs(page: currentPage, date: _dateController.text),
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

  void _fetchTasksWithNewDate() {
    setState(() {
      currentPage = 1;
      resultList = [];
    });

    context.read<HrBloc>().add(
          GetAttendanceLogs(page: 1, date: _dateController.text),
        );
  }

  void _importFromFingerprint() {
    // Show confirmation dialog if resultList is not empty
    if (resultList.isNotEmpty) {
      _showImportConfirmationDialog();
    } else {
      _executeImportFromFingerprint();
    }
  }

  void _showImportConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد الاستيراد'),
            content: const Text(
              'يوجد بالفعل سجلات حضور لهذا التاريخ. هل تريد استيراد البيانات من البصمة؟ هذا قد يؤدي إلى فقدان البيانات.',
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _executeImportFromFingerprint();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('استيراد'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _executeImportFromFingerprint() {
    context.read<HrBloc>().add(
          FetchAttendance(date: _dateController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    width = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Row(
            children: [
              const Text(
                'جدول الدوام',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              if (count != null) MyCircleAvatar(text: count.toString()),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'استيراد من البصامة',
              onPressed: _importFromFingerprint,
              icon: const Icon(Icons.fingerprint, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildDateSelector(),
            Expanded(
              flex: 14,
              child: BlocConsumer<HrBloc, HrState>(
                listener: (context, state) {
                  if (state is HRError) {
                    setState(() => isLoadingMore = false);
                    showSnackBar(
                      context: context,
                      content: 'حدث خطأ ما',
                      failure: true,
                    );
                  } else if (state is HRSuccess<AttendanceLogsModel>) {
                    showSnackBar(
                      context: context,
                      content: 'تم تحديث سجل الدوام بنجاح',
                      failure: false,
                    );
                    _fetchTasksWithNewDate();
                  } else if (state is HRSuccessFetched) {
                    showSnackBar(
                      context: context,
                      content: state.result,
                      failure: false,
                    );
                    _fetchTasksWithNewDate();
                  } else if (state is HRSuccess<OvertimeModel>) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return OvertimePage(
                            overtimeModel: state.result,
                          );
                        },
                      ),
                    );
                  } else if (state is HRSuccess<WorkleavesModel>) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WorkLeavesPage(
                            workleavesModel: state.result,
                          );
                        },
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is HRLoading && currentPage == 1) {
                    return const Loader();
                  }

                  if (state is HRSuccess<PageintedResult>) {
                    bool shouldRebuildAppBar = false;

                    if (count == null ||
                        currentPage == 1 ||
                        state.result.totalCount! > 0) {
                      shouldRebuildAppBar = count != state.result.totalCount;
                      count = state.result.totalCount;
                    }

                    if (currentPage == 1) {
                      resultList =
                          state.result.results.cast<AttendanceLogsModel>();
                    } else {
                      final newResults =
                          state.result.results.cast<AttendanceLogsModel>();
                      if (newResults.isNotEmpty) {
                        resultList.addAll(newResults);
                      }
                    }
                    isLoadingMore = false;

                    if (shouldRebuildAppBar) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() {});
                      });
                    }
                  }

                  if (resultList.isEmpty && state is! HRLoading) {
                    return _buildEmptyState();
                  }

                  return _buildTable(context, resultList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
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
              labelText: 'تاريخ جدول الدوام',
              onTap: () async {
                final pickedDate = await showDatePicker(
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
    );
  }

  Widget _buildTable(BuildContext context, List<AttendanceLogsModel> logs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    return ListView.builder(
      controller: _scrollController,
      itemCount: logs.length + (isLoadingMore ? 1 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemBuilder: (context, index) {
        if (index >= logs.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Loader()),
          );
        }

        final log = logs[index];
        final isMobile = MediaQuery.of(context).size.width < 600;

        return InkWell(
          onTap: () => _showAttendanceLogDialog(context, log),
          child: Card(
            color: cardColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  _getStatusColor(log).withOpacity(0.1),
                              child: Icon(
                                _getStatusIcon(log),
                                color: _getStatusColor(log),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                log.employee_full_name ?? '---',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2.4,
                          children: _buildTimeChips(log),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildStatusChip(
                            label: _getStatusLabel(log),
                            color: _getStatusColor(log),
                            log: log,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              _getStatusColor(log).withOpacity(0.1),
                          child: Icon(
                            _getStatusIcon(log),
                            color: _getStatusColor(log),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.employee_full_name ?? '---',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (int i = 0;
                                        i < _buildTimeChips(log).length;
                                        i++) ...[
                                      _buildTimeChips(log)[i],
                                      if (i != _buildTimeChips(log).length - 1)
                                        const SizedBox(width: 12),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusChip(
                          label: _getStatusLabel(log),
                          color: _getStatusColor(log),
                          log: log,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  String _getStatusLabel(AttendanceLogsModel log) {
    if (log.absent == true) {
      return 'غياب';
    } else if (log.has_leave == true) {
      return 'إجازة';
    } else if (log.late != null && log.late! > 0) {
      return 'تأخير ${log.late!} دقائق';
    } else {
      return 'دوام';
    }
  }

  IconData _getStatusIcon(AttendanceLogsModel log) {
    if (log.absent == true) {
      return Icons.cancel_outlined;
    } else if (log.has_leave == true) {
      return Icons.beach_access_outlined;
    } else if (log.late != null && log.late! > 0) {
      return Icons.watch_later_outlined;
    } else {
      return Icons.check_circle_outline;
    }
  }

  List<Widget> _buildTimeChips(AttendanceLogsModel log) {
    final List<Widget> chips = [];

    if (log.attendance_logs != null && log.attendance_logs!.isNotEmpty) {
      for (final ts in log.attendance_logs!) {
        final formattedTime = _formatTime(ts['timestamp']);
        final color = ts['status'] == 'check_in' ? Colors.blue : Colors.purple;
        chips.add(_buildTimeChip(
          label: ts['status'] == 'check_in' ? 'دخول' : 'خروج',
          time: formattedTime,
          color: color,
        ));
      }
    } else {
      chips
          .add(_buildTimeChip(label: 'دخول', time: '*****', color: Colors.red));
      chips
          .add(_buildTimeChip(label: 'خروج', time: '*****', color: Colors.red));
    }

    if (log.overtime != null &&
        log.overtime!.isNotEmpty &&
        log.overtime != '00:00:00') {
      chips.add(_buildTimeChip(
        label: 'وقت إضافي',
        time: _formatOvertime(log.overtime!),
        color: Colors.orange,
        icon: Icons.timer,
        onTap: log.overtime_id != null
            ? () {
                context.read<HrBloc>().add(
                      GetOnOvertime(id: log.overtime_id!),
                    );
              }
            : null,
      ));
    }

    return chips;
  }

  String _formatTime(String? utcTime) {
    if (utcTime == null) return '*****';
    final dt = DateTime.parse(utcTime).toLocal();
    return DateFormat('HH:mm').format(dt);
  }

  String _formatOvertime(String overtime) {
    if (overtime.length >= 5) {
      return overtime.substring(0, 5);
    }
    return overtime;
  }

  Widget _buildTimeChip({
    required String label,
    required String time,
    required Color color,
    IconData icon = Icons.access_time,
    VoidCallback? onTap,
  }) {
    final timeColor = time == '*****' ? Colors.red : color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 2),
            Text(time,
                style: TextStyle(
                    fontSize: 13,
                    color: timeColor,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AttendanceLogsModel log) {
    if (log.absent == true) {
      return Colors.red;
    } else if (log.has_leave == true) {
      return Colors.blue;
    } else if (log.late != null && log.late! > 0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Widget _buildStatusChip({
    required String label,
    required Color color,
    required AttendanceLogsModel log,
  }) {
    final bool isLeave = label == 'إجازة' && log.workleave_id != null;

    return InkWell(
      onTap: isLeave
          ? () {
              context.read<HrBloc>().add(
                    GetOnWorkLeave(id: log.workleave_id!),
                  );
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showAttendanceLogDialog(BuildContext context, AttendanceLogsModel log) {
    final List<Map<String, dynamic>> editableLogs = log.attendance_logs != null
        ? List<Map<String, dynamic>>.from(log.attendance_logs!)
        : [];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (dialogStateContext, setState) {
            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: AlertDialog(
                title: Text(
                  'سجلات الدوام لـ ${log.employee_full_name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('التاريخ: ${_dateController.text}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Divider(),
                      const Text('قائمة سجلات الحضور:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (editableLogs.isNotEmpty)
                        ...editableLogs.asMap().entries.map((entry) {
                          final index = entry.key;
                          final ts = entry.value;

                          final statusController = TextEditingController(
                            text: ts['status'] == 'check_in' ? 'دخول' : 'خروج',
                          );

                          final timeController = TextEditingController(
                            text: _formatTime(ts['timestamp']),
                          );

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: MyTextField(
                                    controller: statusController,
                                    labelText: 'النوع',
                                    readOnly: true,
                                    suffixIcon: const Icon(Icons.access_time),
                                    onTap: () {
                                      setState(() {
                                        ts['status'] =
                                            ts['status'] == 'check_in'
                                                ? 'check_out'
                                                : 'check_in';
                                        statusController.text =
                                            ts['status'] == 'check_in'
                                                ? 'دخول'
                                                : 'خروج';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 4,
                                  child: MyTextField(
                                    controller: timeController,
                                    labelText: 'الوقت',
                                    onTap: () async {
                                      final now = DateTime.now();
                                      final picked = await showTimePicker(
                                        context: dialogStateContext,
                                        initialTime:
                                            TimeOfDay.fromDateTime(now),
                                      );
                                      if (picked != null) {
                                        final newTime =
                                            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                        setState(() {
                                          timeController.text = newTime;
                                          final localDate = DateTime.parse(
                                                  _dateController.text)
                                              .copyWith(
                                                  hour: picked.hour,
                                                  minute: picked.minute);
                                          ts['timestamp'] = localDate
                                              .toUtc()
                                              .toIso8601String();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      editableLogs.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList()
                      else
                        const Text('لا توجد سجلات حضور مسجلة لهذا اليوم.'),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة سجل جديد'),
                          onPressed: () {
                            setState(() {
                              editableLogs.add({
                                'status': 'check_in',
                                'timestamp':
                                    DateTime.now().toUtc().toIso8601String(),
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Mybutton(
                    text: 'حفظ التغييرات',
                    onPressed: () {
                      final updatedModel = log.copyWith(
                        attendance_logs: editableLogs,
                      );

                      debugPrint('Updated AttendanceLogsModel:');
                      debugPrint(updatedModel.toMap().toString());

                      context.read<HrBloc>().add(
                            UpdateAttendanceLog(
                                date: _dateController.text,
                                attendanceLogsModel: updatedModel),
                          );

                      Navigator.of(dialogStateContext).pop();

                      showSnackBar(
                        context: context,
                        content:
                            'تم حفظ ${editableLogs.length} سجل${editableLogs.length == 1 ? '' : 'ات'}',
                        failure: false,
                      );
                    },
                  ),
                  TextButton(
                    child: const Text('إغلاق'),
                    onPressed: () => Navigator.of(dialogStateContext).pop(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline,
                  size: 48, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'لا توجد سجلات حضور',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'يبدو أنه لا توجد سجلات حضور متاحة للعرض حاليًا. '
              'يمكنك التحقق من التاريخ أو محاولة استيراد البيانات.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _importFromFingerprint,
              child: const Text('استيراد البيانات'),
            ),
          ],
        ),
      ),
    );
  }
}
