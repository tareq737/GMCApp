part of 'production_bloc.dart';

@immutable
sealed class ProdState {}

final class ProdInitial extends ProdState {}

final class ProdOpSuccess<T> extends ProdState {
  final T opResult;

  ProdOpSuccess({required this.opResult});
}

final class ProdOpFailure extends ProdState {
  final String message;

  ProdOpFailure({required this.message});
}

final class ProdOpLoading extends ProdState {}
