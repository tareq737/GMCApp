import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/maintenance/UI/list_maintenance_filtered.dart';
import 'package:gmcappclean/features/production_management/production/ui/list_production_filtered.dart';
import 'package:gmcappclean/features/purchases/UI/list_purchase_filtered.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/operations_date_page.dart';
import 'package:gmcappclean/features/statistics/bloc/statistics_bloc.dart';
import 'package:gmcappclean/features/statistics/models/statistics_model.dart';
import 'package:intl/intl.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({
    super.key,
  });
  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final MaterialColor _primaryColor = Colors.blue;
  final MaterialColor _infoColor = Colors.cyan;
  final MaterialColor _successColor = Colors.green;
  final MaterialColor _warningColor = Colors.orange;
  final MaterialColor _dangerColor = Colors.red;
  final MaterialColor _neutralColor = Colors.grey;
  bool expanded = true;
  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfPreviousMonth =
        firstDayOfCurrentMonth.subtract(const Duration(days: 1));
    final firstDayOfPreviousMonth =
        DateTime(lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

    _toDateController.text =
        DateFormat('yyyy-MM-dd').format(lastDayOfPreviousMonth);
    _fromDateController.text =
        DateFormat('yyyy-MM-dd').format(firstDayOfPreviousMonth);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        runBloc();
      }
    });
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void runBloc() {
    context.read<StatisticsBloc>().add(
          GetStatistics(
            date_1: _fromDateController.text,
            date_2: _toDateController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color color = isDark ? Colors.tealAccent : Colors.teal;

    return BlocConsumer<StatisticsBloc, StatisticsState>(
      listener: (context, state) {
        if (state is StatisticsError) {
          showSnackBar(
            context: context,
            content: 'حدث خطأ ما',
            failure: true,
          );
        }
      },
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Loader();
        } else if (state is StatisticsSuccess<StatisticsModel>) {
          // Use OrientationBuilder to switch layouts
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                return _buildLandscapeLayout(state, color);
              } else {
                return _buildPortraitLayout(state, color);
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  /// ## Portrait Layout
  /// Displays all statistics sections in a single vertical column.
  Widget _buildPortraitLayout(
      StatisticsSuccess<StatisticsModel> state, Color color) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePickers(),
                const SizedBox(height: 10),
                _buildSalesSection(state, color),
                const SizedBox(height: 20),
                _buildProductionSection(state, color),
                const SizedBox(height: 20),
                _buildPurchasesSection(state, color),
                const SizedBox(height: 20),
                _buildMaintenanceSection(state, color),
              ].animate(interval: 200.ms).fade(duration: 200.ms),
            ),
          ),
        ),
      ),
    );
  }

  /// ## Landscape Layout
  /// Displays statistics in two columns for wider screens.
  Widget _buildLandscapeLayout(
      StatisticsSuccess<StatisticsModel> state, Color color) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDatePickers(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildSalesSection(state, color),
                          const SizedBox(height: 20),
                          _buildPurchasesSection(state, color),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildProductionSection(state, color),
                          const SizedBox(height: 20),
                          _buildMaintenanceSection(state, color),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ## UI Section: Date Pickers
  Widget _buildDatePickers() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: MyTextField(
            readOnly: true,
            controller: _fromDateController,
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
                  _fromDateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                });
                runBloc();
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: MyTextField(
            readOnly: true,
            controller: _toDateController,
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
                  _toDateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                });
                runBloc();
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: IconButton.filledTonal(
            onPressed: runBloc,
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
          ),
        ),
      ],
    );
  }

  /// ## UI Section: Sales Statistics
  Widget _buildSalesSection(
      StatisticsSuccess<StatisticsModel> state, Color color) {
    return ExpansionTile(
      initiallyExpanded: expanded,
      leading: AvatarGlow(
          glowColor: color, child: Icon(Icons.bar_chart, color: color)),
      title: Text('إحصائيات المبيعات',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: 22)),
      children: [
        const SizedBox(height: 16),
        Text('إحصائيات الزيارات',
            style: Theme.of(context).textTheme.titleMedium),
        _buildStatRow(
          context,
          'إجمالي الزيارات',
          state.result.sales!.total_visits ?? 0,
          Icons.groups_outlined,
          _primaryColor,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OperationsDatePage(
                fromDate: _fromDateController.text,
                toDate: _toDateController.text,
                type: 'visits',
              );
            }));
          },
        ),
        _buildStatRow(
          context,
          'زيارات مع تسجيل فاتورة',
          state.result.sales!.visits_with_bill ?? 0,
          Icons.receipt_long_outlined,
          _infoColor,
          total: state.result.sales!.total_visits ?? 0,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OperationsDatePage(
                fromDate: _fromDateController.text,
                toDate: _toDateController.text,
                bill: true,
              );
            }));
          },
        ),
        _buildStatRow(
          context,
          'زيارات مع جلب مبلغ',
          state.result.sales!.visits_with_paid_money ?? 0,
          Icons.payments_outlined,
          _successColor,
          total: state.result.sales!.total_visits ?? 0,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OperationsDatePage(
                fromDate: _fromDateController.text,
                toDate: _toDateController.text,
                paid_money: true,
              );
            }));
          },
        ),
        const Divider(height: 32),
        Text('إحصائيات الاستقبال',
            style: Theme.of(context).textTheme.titleMedium),
        Row(children: [
          Expanded(
              child: _buildStatRow(
            context,
            'ممتاز',
            state.result.sales!.reception_great ?? 0,
            Icons.sentiment_very_satisfied,
            _successColor,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => OperationsDatePage(
                        fromDate: _fromDateController.text,
                        toDate: _toDateController.text,
                        reception: 'ممتازة'))),
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _buildStatRow(
            context,
            'جيد',
            state.result.sales!.reception_good ?? 0,
            Icons.sentiment_satisfied,
            Colors.lightGreen,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => OperationsDatePage(
                        fromDate: _fromDateController.text,
                        toDate: _toDateController.text,
                        reception: 'جيدة'))),
          )),
        ]),
        Row(children: [
          Expanded(
              child: _buildStatRow(
            context,
            'عادي',
            state.result.sales!.reception_normal ?? 0,
            Icons.sentiment_neutral,
            _warningColor,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => OperationsDatePage(
                        fromDate: _fromDateController.text,
                        toDate: _toDateController.text,
                        reception: 'عادية'))),
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _buildStatRow(
            context,
            'سيء',
            state.result.sales!.reception_bad ?? 0,
            Icons.sentiment_dissatisfied,
            _dangerColor,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => OperationsDatePage(
                        fromDate: _fromDateController.text,
                        toDate: _toDateController.text,
                        reception: 'سيئة'))),
          )),
        ]),
        Row(children: [
          Expanded(
              child: _buildStatRow(
            context,
            'غير موجود',
            state.result.sales!.reception_unavailable ?? 0,
            Icons.not_interested_outlined,
            _neutralColor,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => OperationsDatePage(
                        fromDate: _fromDateController.text,
                        toDate: _toDateController.text,
                        reception: 'غير موجود'))),
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _buildStatRow(
            context,
            'مغلق',
            state.result.sales!.reception_closed ?? 0,
            Icons.lock_outline,
            _dangerColor,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => OperationsDatePage(
                        fromDate: _fromDateController.text,
                        toDate: _toDateController.text,
                        reception: 'مغلق'))),
          )),
        ]),
      ],
    );
  }

  /// ## UI Section: Production Statistics
  Widget _buildProductionSection(
      StatisticsSuccess<StatisticsModel> state, Color color) {
    return ExpansionTile(
      initiallyExpanded: expanded,
      leading: AvatarGlow(
          glowColor: color, child: Icon(Icons.factory_outlined, color: color)),
      title: Text('إحصائيات الإنتاج',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: 22)),
      children: [
        _buildStatRow(
          context,
          'الطبخات المدرجة',
          state.result.production!.total_productions ?? 0,
          Icons.list_alt_outlined,
          _primaryColor,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: '',
                      type: '',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'الطبخات المنفذة',
          state.result.production!.finished_productions ?? 0,
          Icons.check_circle_outline,
          _successColor,
          total: state.result.production!.total_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished',
                      type: '',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'الطبخات قيد التنفيذ',
          state.result.production!.pending_productions ?? 0,
          Icons.schedule_outlined,
          _warningColor,
          total: state.result.production!.total_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'pending',
                      type: '',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'طبخات الزياتي المنفذة',
          state.result.production!.productions_oil_based ?? 0,
          Icons.oil_barrel_outlined,
          Colors.amber,
          total: state.result.production!.total_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished',
                      type: 'oil_based',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'طبخات الطرش المنفذة',
          state.result.production!.productions_water_based ?? 0,
          Icons.water_outlined,
          Colors.blue,
          total: state.result.production!.total_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished',
                      type: 'water_based',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'طبخات الأكرليك المنفذة',
          state.result.production!.productions_acrylic ?? 0,
          Icons.format_paint_outlined,
          Colors.purple,
          total: state.result.production!.total_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished',
                      type: 'acrylic',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'طبخات أخرى منفذة',
          state.result.production!.productions_other ?? 0,
          Icons.scatter_plot_outlined,
          _neutralColor,
          total: state.result.production!.total_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished',
                      type: 'other',
                      timeliness: ''))),
        ),
        _buildStatRow(
          context,
          'طبخات منفذة خلال 3 أيام',
          state.result.production!.productions_done_in_3_days ?? 0,
          Icons.check_circle_outline,
          _successColor,
          total: state.result.production!.finished_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: '',
                      type: '',
                      timeliness: 'on_time'))),
        ),
        _buildStatRow(
          context,
          'طبخات متأخرة',
          state.result.production!.late_productions ?? 0,
          Icons.timer_off_outlined,
          _dangerColor,
          total: state.result.production!.finished_productions ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListProductionFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: '',
                      type: '',
                      timeliness: 'late'))),
        ),
        _buildStatRow(
          context,
          'متوسط زمن الطبخة',
          state.result.production!.average_duration_days ?? 0,
          Icons.access_time_outlined,
          Colors.blueGrey,
        ),
      ],
    );
  }

  /// ## UI Section: Purchases Statistics
  Widget _buildPurchasesSection(
      StatisticsSuccess<StatisticsModel> state, Color color) {
    return ExpansionTile(
      initiallyExpanded: expanded,
      leading: AvatarGlow(
          glowColor: color,
          child: Icon(Icons.shopping_cart_outlined, color: color)),
      title: Text('إحصائيات المشتريات',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: 22)),
      children: [
        _buildStatRow(
          context,
          'إجمالي طلبات المشتريات',
          state.result.purchases!.total_purchases ?? 0,
          Icons.shopping_bag_outlined,
          _primaryColor,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListPurchaseFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: ''))),
        ),
        _buildStatRow(
          context,
          'طلبات الشراء المنفذة',
          state.result.purchases!.purchases_received_true ?? 0,
          Icons.check_circle_outline,
          Colors.green,
          total: state.result.purchases!.total_purchases ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListPurchaseFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished'))),
        ),
        _buildStatRow(
          context,
          'طلبات شراء قيد التنفيذ',
          state.result.purchases!.purchases_pending ?? 0,
          Icons.hourglass_bottom_outlined,
          _neutralColor,
          total: state.result.purchases!.total_purchases ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListPurchaseFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'pending'))),
        ),
        _buildStatRow(
          context,
          'طلبات الشراء المنتهية خلال 7 أيام',
          state.result.purchases!.purchases_within_7_days ?? 0,
          Icons.calendar_today_outlined,
          Colors.blue,
          total: state.result.purchases!.purchases_received_true ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListPurchaseFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'on_time'))),
        ),
        _buildStatRow(
          context,
          'طلبات الشراء المتأخرة',
          state.result.purchases!.purchases_received_after_7_days ?? 0,
          Icons.warning_amber_outlined,
          Colors.red,
          total: state.result.purchases!.purchases_received_true ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListPurchaseFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'late'))),
        ),
      ],
    );
  }

  /// ## UI Section: Maintenance Statistics
  Widget _buildMaintenanceSection(
      StatisticsSuccess<StatisticsModel> state, Color color) {
    return ExpansionTile(
      initiallyExpanded: expanded,
      leading: AvatarGlow(
          glowColor: color, child: Icon(Icons.build_outlined, color: color)),
      title: Text('إحصائيات الصيانة',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: 22)),
      children: [
        _buildStatRow(
          context,
          'إجمالي طلبات الصيانة',
          state.result.maintenance!.total_maintenance ?? 0,
          Icons.miscellaneous_services_outlined,
          _primaryColor,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListMaintenanceFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: ''))),
        ),
        _buildStatRow(
          context,
          'طلبات الصيانة المنفذة',
          state.result.maintenance!.maintenance_received_true ?? 0,
          Icons.check_circle_outline,
          Colors.green,
          total: state.result.maintenance!.total_maintenance ?? 0,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ListMaintenanceFiltered(
                      date_1: _fromDateController.text,
                      date_2: _toDateController.text,
                      status: 'finished'))),
        ),
      ],
    );
  }
}

/// ## Reusable Widget for a single statistic row
Widget _buildStatRow(
  BuildContext context,
  String label,
  num value, // Changed to num to support doubles from average calculation
  IconData icon,
  MaterialColor baseColor, {
  int? total,
  VoidCallback? onTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final backgroundColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
  final iconColor = isDark ? baseColor.shade200 : baseColor.shade800;
  final valueColor = isDark ? baseColor.shade100 : baseColor.shade900;
  final pillBackground = isDark ? baseColor.shade900 : baseColor.shade100;

  String? percentageText;
  if (total != null && total > 0) {
    final percentage = (value / total * 100).toStringAsFixed(0);
    percentageText = '$percentage%';
  }

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black12,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: iconColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (percentageText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: pillBackground.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                percentageText,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: valueColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: pillBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              // Format value to show one decimal place if it's not a whole number
              value is double && value % 1 != 0
                  ? value.toStringAsFixed(1)
                  : value.toStringAsFixed(0),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: valueColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
