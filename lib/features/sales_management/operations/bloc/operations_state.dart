part of 'operations_bloc.dart';

@immutable
sealed class OperationsState {}

final class OperationsInitial extends OperationsState {}

class OperationsLoading extends OperationsState {}

class OperationsError extends OperationsState {
  final String errorMessage;

  OperationsError({required this.errorMessage});
}

class OperationsSuccess<T> extends OperationsState {
  final T result;

  OperationsSuccess({required this.result});
}
