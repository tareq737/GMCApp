part of 'sales_bloc.dart';

@immutable
sealed class SalesState {}

final class SalesInitial extends SalesState {}

final class SalesOpSuccess<T> extends SalesState {
  final T opResult;

  SalesOpSuccess({required this.opResult});
}

final class SalesOpFailure extends SalesState {
  final String message;

  SalesOpFailure({required this.message});
}

final class SalesOpLoading extends SalesState {}
