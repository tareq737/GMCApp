part of 'product_efficiency_bloc.dart';

@immutable
sealed class ProductEfficiencyEvent {}

class GetAllProducts extends ProductEfficiencyEvent {
  final int page;
  final String search;
  GetAllProducts({
    required this.page,
    required this.search,
  });
}

class GetOneProduct extends ProductEfficiencyEvent {
  final int id;
  GetOneProduct({required this.id});
}
