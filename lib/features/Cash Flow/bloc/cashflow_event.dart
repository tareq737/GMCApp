part of 'cashflow_bloc.dart';

@immutable
sealed class CashflowEvent {}

class GetCashflow extends CashflowEvent {
  final int page;
  final String date_1;
  final String date_2;
  final String currency;
  GetCashflow(
      {required this.page,
      required this.date_1,
      required this.date_2,
      required this.currency});
}

class GetCashflowBalance extends CashflowEvent {
  final String currency;

  GetCashflowBalance({required this.currency});
}
