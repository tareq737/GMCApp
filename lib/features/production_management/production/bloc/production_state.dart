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
  final int? totalCount;

  ProductionSuccess({required this.result, this.totalCount});
}

class ProductionSuccessReverted<T> extends ProductionState {
  final T result;

  ProductionSuccessReverted({required this.result});
}

class ProductionSuccessUnArchive<T> extends ProductionState {
  final T result;

  ProductionSuccessUnArchive({required this.result});
}

class GenrateSuccess<T> extends ProductionState {
  final T result;

  GenrateSuccess({required this.result});
}

class ExportLoading extends ProductionState {}
