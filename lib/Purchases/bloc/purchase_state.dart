part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseState {}

final class PurchaseInitial extends PurchaseState {}

class PurchaseSuccess<T> extends PurchaseState {
  final T result;

  PurchaseSuccess({required this.result});
}

class PurchaseLoading extends PurchaseState {}

class PurchaseError extends PurchaseState {
  final String errorMessage;

  PurchaseError({required this.errorMessage});
}
