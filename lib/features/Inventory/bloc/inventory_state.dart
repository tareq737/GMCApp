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
