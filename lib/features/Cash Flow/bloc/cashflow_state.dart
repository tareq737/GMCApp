part of 'cashflow_bloc.dart';

@immutable
sealed class CashflowState {}

final class CashflowInitial extends CashflowState {}

class CashflowLoading extends CashflowState {}

class CashflowSuccess<T> extends CashflowState {
  final T result;

  CashflowSuccess({required this.result});
}

class CashflowSuccessSync<T> extends CashflowState {
  final T result;

  CashflowSuccessSync({required this.result});
}

class CashflowError extends CashflowState {
  final String errorMessage;

  CashflowError({required this.errorMessage});
}
