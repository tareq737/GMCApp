part of 'product_efficiency_bloc.dart';

@immutable
sealed class ProductEfficiencyState {}

final class ProductEfficiencyInitial extends ProductEfficiencyState {}

class ProductEfficiencyLoading extends ProductEfficiencyState {}

class ProductEfficiencyError extends ProductEfficiencyState {
  final String errorMessage;

  ProductEfficiencyError({required this.errorMessage});
}

class ProductEfficiencySuccess<T> extends ProductEfficiencyState {
  final T result;

  ProductEfficiencySuccess({required this.result});
}
