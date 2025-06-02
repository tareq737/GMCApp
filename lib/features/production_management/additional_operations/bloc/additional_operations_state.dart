part of 'additional_operations_bloc.dart';

@immutable
sealed class AdditionalOperationsState {}

final class AdditionalOperationsInitial extends AdditionalOperationsState {}

class AdditionalOperationsLoading extends AdditionalOperationsState {}

class AdditionalOperationsError extends AdditionalOperationsState {
  final String errorMessage;

  AdditionalOperationsError({required this.errorMessage});
}

class AdditionalOperationsSuccess<T> extends AdditionalOperationsState {
  final T result;

  AdditionalOperationsSuccess({required this.result});
}
