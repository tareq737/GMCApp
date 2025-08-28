// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Cash%20Flow/bloc/cashflow_bloc.dart';
import 'package:gmcappclean/features/Cash%20Flow/models/cashflow_balance_model.dart';
import 'package:gmcappclean/features/Cash%20Flow/models/cashflow_model.dart';
import 'package:gmcappclean/features/Cash%20Flow/services/cashflow_service.dart';
import 'package:gmcappclean/init_dependencies.dart';

class CashflowPage extends StatelessWidget {
  String currency;
  CashflowPage({
    super.key,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    return BlocProvider(
      create: (context) => CashflowBloc(CashflowService(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      ))
        ..add(
          GetCashflow(
            page: 1,
            date_1: formattedDate,
            date_2: formattedDate,
            currency: currency,
          ),
        )
        ..add(GetCashflowBalance(currency: currency)),
      child: Builder(builder: (context) {
        return CashflowPageChild(
          currency: currency,
        );
      }),
    );
  }
}

class CashflowPageChild extends StatefulWidget {
  String currency;
  CashflowPageChild({
    super.key,
    required this.currency,
  });

  @override
  State<CashflowPageChild> createState() => _CashflowPageChildState();
}

class _CashflowPageChildState extends State<CashflowPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<CashflowModel> _model = [];
  final _dateController = TextEditingController();
  double width = 0;
  double? _latestBalance;
  List<String>? groups;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.5 &&
        !isLoadingMore) {
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
    context.read<CashflowBloc>().add(
          GetCashflow(
            page: currentPage,
            date_1: _dateController.text,
            date_2: _dateController.text,
            currency: widget.currency,
          ),
        );
    context
        .read<CashflowBloc>()
        .add(GetCashflowBalance(currency: widget.currency));
  }

  void _fetchTasksWithNewDate() {
    setState(() {
      currentPage = 1;
      _model = [];
      isLoadingMore = false;
    });

    context.read<CashflowBloc>().add(
          GetCashflow(
            page: 1,
            date_1: _dateController.text,
            date_2: _dateController.text,
            currency: widget.currency,
          ),
        );
    context
        .read<CashflowBloc>()
        .add(GetCashflowBalance(currency: widget.currency));
  }

  void _changeDate(int daysToAdd) {
    final currentDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    final newDate = currentDate.add(Duration(days: daysToAdd));

    setState(() {
      _dateController.text = DateFormat('yyyy-MM-dd').format(newDate);
    });
    _fetchTasksWithNewDate();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    width = MediaQuery.of(context).size.width;
    AppUserState appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      groups = appUserState.userEntity.groups;
    }
    const double wideScreenBreakpoint = 720.0;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            widget.currency == 'SP'
                ? 'حركة صندوق ليرة'
                : (widget.currency == 'USA'
                    ? 'حركة صندوق دولار'
                    : 'حركة الصندوق'),
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CashflowPage(
                        currency: 'SP',
                      );
                    },
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.moneyBill,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CashflowPage(
                        currency: 'USA',
                      );
                    },
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.dollarSign,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'رصيد الصندوق:  ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _latestBalance == null
                          ? const SizedBox(
                              height: 18, width: 18, child: Loader())
                          : TweenAnimationBuilder<num>(
                              tween: Tween<num>(
                                begin: 0,
                                end: _latestBalance ?? 0,
                              ),
                              duration: const Duration(milliseconds: 1000),
                              builder: (context, value, child) {
                                return Text(
                                  _formatBalance(value
                                      .toDouble()), // Use the new balance formatting method
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: (_latestBalance ?? 0) >= 0
                                        ? Colors.green.shade600
                                        : Colors.red.shade600,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
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
                      labelText: 'تاريخ الحركة',
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
              child: BlocConsumer<CashflowBloc, CashflowState>(
                listener: (context, state) {
                  if (state is CashflowError) {
                    showSnackBar(
                      context: context,
                      content: state.errorMessage,
                      failure: true,
                    );
                  } else if (state is CashflowSuccess<List<CashflowModel>>) {
                    setState(() {
                      if (currentPage == 1) {
                        _model = state.result;
                      } else {
                        _model.addAll(state.result);
                      }
                      isLoadingMore = false;
                    });
                  } else if (state is CashflowSuccess<CashflowBalanceModel>) {
                    setState(() {
                      _latestBalance = state.result.latest_balance;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is CashflowLoading && _model.isEmpty) {
                    return const Center(child: Loader());
                  }

                  if (state is CashflowError && _model.isEmpty) {
                    return const Center(child: Text('حدث خطأ ما'));
                  }

                  if (_model.isEmpty && state is! CashflowLoading) {
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
                            'لا توجد حركات لعرضها',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > wideScreenBreakpoint) {
                        return _buildWideLayout(_model, isDark);
                      } else {
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
                            final transaction = _model[index];
                            final hasInflow = transaction.inflow != null &&
                                transaction.inflow!.isNotEmpty;
                            return _buildTransactionItem(
                                transaction, hasInflow, isDark);
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      CashflowModel transaction, bool hasInflow, bool isDark) {
    if (transaction.note == null) {
      return const SizedBox.shrink();
    }
    final amount = hasInflow ? transaction.inflow : transaction.outflow;
    final isAmountPositive = hasInflow;

    return InkWell(
      onTap: () => _showTransactionDetailsDialog(transaction),
      borderRadius: BorderRadius.circular(12),
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
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isAmountPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            transaction.note!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            transaction.reciept_number ?? "-",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatNumberWithCurrency(amount),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isAmountPositive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(List<CashflowModel> transactions, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('البيان')),
            DataColumn(label: Text('رقم السند')),
            DataColumn(label: Text('مقبوضات'), numeric: true),
            DataColumn(label: Text('مدفوعات'), numeric: true),
          ],
          rows: transactions
              .map((transaction) {
                if (transaction.note == null) {
                  return null;
                }
                final hasInflow = transaction.inflow != null &&
                    transaction.inflow!.isNotEmpty;
                return DataRow(
                  cells: [
                    DataCell(
                      Text(transaction.note ?? '-'),
                      onTap: () => _showTransactionDetailsDialog(transaction),
                    ),
                    DataCell(
                      Text(transaction.reciept_number ?? '-'),
                      onTap: () => _showTransactionDetailsDialog(transaction),
                    ),
                    DataCell(
                      Text(
                        _formatNumberWithCurrency(
                            hasInflow ? transaction.inflow : '-'),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _showTransactionDetailsDialog(transaction),
                    ),
                    DataCell(
                      Text(
                        _formatNumberWithCurrency(
                            !hasInflow ? transaction.outflow : '-'),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _showTransactionDetailsDialog(transaction),
                    ),
                  ],
                );
              })
              .whereType<DataRow>()
              .toList(),
        ),
      ),
    );
  }

  String _formatNumberWithCurrency(String? value) {
    if (value == null || value.isEmpty || value == "-") return "-";
    try {
      String cleanValue = value.replaceAll(',', '');
      double number = double.parse(cleanValue);
      final formatter = NumberFormat("#,##0.##"); // Flexible decimal places
      String formattedNumber = formatter.format(number);

      // Add currency symbol based on the selected currency
      if (widget.currency == 'USA') {
        return '\$$formattedNumber';
      } else if (widget.currency == 'SP') {
        return '$formattedNumber S.P';
      } else {
        return formattedNumber;
      }
    } catch (e) {
      return value;
    }
  }

  void _showTransactionDetailsDialog(CashflowModel transaction) {
    final hasInflow =
        transaction.inflow != null && transaction.inflow!.isNotEmpty;
    final amount = hasInflow ? transaction.inflow : transaction.outflow;
    final amountColor = hasInflow ? Colors.green : Colors.red;
    final amountLabel = hasInflow ? 'مقبوضات' : 'مدفوعات';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تفاصيل الحركة'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  _buildDetailRow('البيان:', transaction.note ?? '-'),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                      'رقم السند:', transaction.reciept_number ?? '-'),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    '$amountLabel:',
                    _formatNumberWithCurrency(amount),
                    valueColor: amountColor, // Pass color for styling
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('إغلاق'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight:
                  valueColor != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  String _formatBalance(double value) {
    if (widget.currency == 'USA') {
      // Format with two decimal places for USD
      final formatter = NumberFormat("#,##0.00");
      return '\$${formatter.format(value)}';
    } else if (widget.currency == 'SP') {
      // Format without decimal places for SP
      final formatter = NumberFormat("#,##0");
      return '${formatter.format(value)} S.P';
    } else {
      // Default formatting
      final formatter = NumberFormat("#,##0");
      return formatter.format(value);
    }
  }
}
