part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryError extends InventoryState {
  final String errorMessage;

  InventoryError({required this.errorMessage});
}

class InventorySuccess<T> extends InventoryState {
  final T result;

  InventorySuccess({required this.result});
}

class InventorySuccessDeleted<T> extends InventoryState {
  final T result;

  InventorySuccessDeleted({required this.result});
}

class InventorySuccessAddManufacturing<T> extends InventoryState {
  final T result;

  InventorySuccessAddManufacturing({required this.result});
}

class InventorySuccessUpdateManufacturing<T> extends InventoryState {
  final T result;

  InventorySuccessUpdateManufacturing({required this.result});
}
