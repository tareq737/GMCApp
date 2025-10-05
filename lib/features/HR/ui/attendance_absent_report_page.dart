import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/attendance_absent_report_model.dart';
import 'package:gmcappclean/features/HR/models/employee_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

// No changes needed in this widget
class AttendanceAbsentReportPage extends StatelessWidget {
  const AttendanceAbsentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    return BlocProvider(
      create: (context) => HrBloc(
        HrServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(
          GetAttendanceAbsentReport(
            date: formattedDate,
          ),
        ),
      child: const AttendanceAbsentReportPageChild(),
    );
  }
}

// FINAL WIDGET with UI improvements, animations, and Font Awesome Icons
class AttendanceAbsentReportPageChild extends StatefulWidget {
  const AttendanceAbsentReportPageChild({super.key});

  @override
  State<AttendanceAbsentReportPageChild> createState() =>
      _AttendanceAbsentReportPageChildState();
}

class _AttendanceAbsentReportPageChildState
    extends State<AttendanceAbsentReportPageChild> {
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  /// Changes the date by the given number of days and fetches the report.
  void _changeDate(int days) {
    try {
      final currentDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
      final newDate = currentDate.add(Duration(days: days));

      // Prevent navigating to a future date
      if (newDate.isAfter(DateTime.now())) {
        return;
      }

      final formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
      _dateController.text = formattedDate;
      context
          .read<HrBloc>()
          .add(GetAttendanceAbsentReport(date: formattedDate));
      // Call setState to rebuild the widget and update the button state
      setState(() {});
    } catch (e) {
      // Handle potential date parsing errors
      debugPrint("Error changing date: $e");
    }
  }

  /// Helper widget for the refined summary info cards with icons.
  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required String value,
      required Color color,
      required IconData icon}) {
    // Get the current orientation
    final orientation = MediaQuery.of(context).orientation;

    // Define the widgets to avoid repetition
    final iconWidget = FaIcon(icon, size: 22, color: color);
    final valueText = Text(
      value,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
    );
    final titleText = Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );

    return Expanded(
      child: Card(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          // Use a conditional layout based on orientation
          child: orientation == Orientation.landscape
              // ↔️ Landscape layout: Use a Row
              ? Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    iconWidget,
                    titleText,
                    valueText,
                  ],
                )
              // ↕️ Portrait layout: Use a Column
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconWidget,
                    const SizedBox(height: 8),
                    valueText,
                    const SizedBox(height: 4),
                    titleText,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmployeeItem(BuildContext context,
      {required EmployeeModel employee}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)), // slide up effect
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 1,
        child: Center(
          child: ListTile(
            visualDensity: VisualDensity.compact,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                employee.id.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            title: AutoSizeText(
              '${employee.name ?? ''} - ${employee.department ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              minFontSize: 8,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate =
        DateFormat('yyyy-MM-dd').tryParse(_dateController.text) ?? today;
    final isNextDayDisabled = !selectedDate.isBefore(today);

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تقرير غياب الموظفين'),
        ),
        body: BlocConsumer<HrBloc, HrState>(
          listener: (context, state) {
            if (state is ErrorHR) {
              showSnackBar(
                context: context,
                content: 'حدث خطأ ما: ${state.errorMessage}',
                failure: true,
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingHR) {
              return const Loader();
            } else if (state is SuccessHR<AttendanceAbsentReportModel>) {
              final report = state.result;
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Date Picker TextField ---
                      Row(
                        children: [
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.chevronRight),
                            onPressed: () => _changeDate(-1),
                            tooltip: 'اليوم السابق',
                          ),
                          Expanded(
                            child: MyTextField(
                              controller: _dateController,
                              style: const TextStyle(fontSize: 16.0),
                              readOnly: true,
                              textAlign: TextAlign.center,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateFormat('yyyy-MM-dd')
                                      .parse(_dateController.text),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  final formattedDate = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  _dateController.text = formattedDate;
                                  context.read<HrBloc>().add(
                                      GetAttendanceAbsentReport(
                                          date: formattedDate));
                                  setState(() {});
                                }
                              },
                              labelText: 'اختر التاريخ',
                              // ✨ ICON ADDED HERE
                              prefixIcon:
                                  const Icon(FontAwesomeIcons.calendarDay),
                            ),
                          ),
                          IconButton(
                            // ✨ ICON UPDATED (RTL friendly)
                            icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                            onPressed:
                                isNextDayDisabled ? null : () => _changeDate(1),
                            tooltip: 'اليوم التالي',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // --- Summary Cards ---
                      Row(
                        children: [
                          _buildInfoCard(
                            context,
                            title: 'الإجمالي',
                            value: report.total_employees.toString(),
                            color: Colors.blue.shade600,
                            icon: FontAwesomeIcons.users,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoCard(
                            context,
                            title: 'الحاضرون',
                            value: report.present.toString(),
                            color: Colors.green.shade600,
                            icon: FontAwesomeIcons.userCheck,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoCard(
                            context,
                            title: 'الغائبون',
                            value: report.absent.toString(),
                            color: Colors.red.shade600,
                            icon: FontAwesomeIcons.userXmark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),

                      // --- Absent Employees List Header ---
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'قائمة الغائبين (${report.absent_employees.length})',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      Expanded(
                        child: report.absent_employees.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.solidCircleCheck,
                                      size: 50,
                                      color: Colors.green.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'لا يوجد موظفين غائبين لهذا اليوم.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  const double mobileBreakpoint = 600.0;

                                  if (constraints.maxWidth < mobileBreakpoint) {
                                    // 📱 MOBILE: Use ListView for narrow screens
                                    return ListView.builder(
                                      itemCount: report.absent_employees.length,
                                      itemBuilder: (context, index) {
                                        final employee =
                                            report.absent_employees[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: _buildEmployeeItem(context,
                                              employee: employee),
                                        );
                                      },
                                    );
                                  } else {
                                    // 💻 PC: Use GridView for wider screens
                                    return GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 300,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 3.5,
                                      ),
                                      itemCount: report.absent_employees.length,
                                      itemBuilder: (context, index) {
                                        final employee =
                                            report.absent_employees[index];
                                        return _buildEmployeeItem(context,
                                            employee: employee);
                                      },
                                    );
                                  }
                                },
                              ),
                      ),
                    ],
                  ));
            } else {
              // Fallback for initial or error states
              return const Center(
                  child: Text('الرجاء اختيار تاريخ لعرض التقرير.'));
            }
          },
        ),
      ),
    );
  }
}
