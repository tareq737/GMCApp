part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseEvent {}

class GetBriefPurchase extends PurchaseEvent {
  final String? section;
  final String? status;

  GetBriefPurchase({required this.section, required this.status});
}

class GetDetailsPurchase extends PurchaseEvent {
  final int pur_id;

  GetDetailsPurchase({required this.pur_id});
}
