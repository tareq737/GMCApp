part of 'production_bloc.dart';

@immutable
sealed class ProductionState {}

final class ProductionInitial extends ProductionState {}

class ProductionLoading extends ProductionState {}

class ProductionError extends ProductionState {
  final String errorMessage;

  ProductionError({required this.errorMessage});
}

class ProductionSuccess<T> extends ProductionState {
  final T result;

  ProductionSuccess({required this.result});
}
