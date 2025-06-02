part of 'total_production_bloc.dart';

@immutable
sealed class TotalProductionState {}

final class TotalProductionInitial extends TotalProductionState {}

class TotalProductionLoading extends TotalProductionState {}

class TotalProductionError extends TotalProductionState {
  final String errorMessage;

  TotalProductionError({required this.errorMessage});
}

class TotalProductionSuccess<T> extends TotalProductionState {
  final T result;

  TotalProductionSuccess({required this.result});
}
