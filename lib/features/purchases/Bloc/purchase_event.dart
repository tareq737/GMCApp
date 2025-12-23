part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseEvent {}

class GetAllPurchases extends PurchaseEvent {
  final int page;
  final int status;
  final String department;
  GetAllPurchases({
    required this.page,
    required this.status,
    required this.department,
  });
}

class SearchPurchases extends PurchaseEvent {
  final String search;
  final int page;
  SearchPurchases({
    required this.search,
    required this.page,
  });
}

class GetAllProductionPurchases extends PurchaseEvent {
  final int page;
  final int status;
  GetAllProductionPurchases({
    required this.page,
    required this.status,
  });
}

class SearchProductionPurchases extends PurchaseEvent {
  final String search;
  final int page;
  SearchProductionPurchases({
    required this.search,
    required this.page,
  });
}

class GetOnePurchase extends PurchaseEvent {
  final int id;
  GetOnePurchase({required this.id});
}

class AddPurchases extends PurchaseEvent {
  final PurchasesModel purchasesModel;

  AddPurchases({required this.purchasesModel});
}

class UpdatePurchases extends PurchaseEvent {
  final int id;
  final PurchasesModel purchaseModel;

  UpdatePurchases({required this.purchaseModel, required this.id});
}

class AddPurchaseImage extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseImage({required this.image, required this.id});
}

class GetPurchaseImage extends PurchaseEvent {
  final int id;
  GetPurchaseImage({required this.id});
}

class DeletePurchaceImage extends PurchaseEvent {
  final int id;
  DeletePurchaceImage({required this.id});
}

class AddPurchaseOffer1Image extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseOffer1Image({required this.image, required this.id});
}

class AddPurchaseOffer2Image extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseOffer2Image({required this.image, required this.id});
}

class AddPurchaseOffer3Image extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseOffer3Image({required this.image, required this.id});
}

class GetPurchaseOffer1Image extends PurchaseEvent {
  final int id;
  GetPurchaseOffer1Image({required this.id});
}

class GetPurchaseOffer2Image extends PurchaseEvent {
  final int id;
  GetPurchaseOffer2Image({required this.id});
}

class GetPurchaseOffer3Image extends PurchaseEvent {
  final int id;
  GetPurchaseOffer3Image({required this.id});
}

class DeletePurchaceOffer1Image extends PurchaseEvent {
  final int id;
  DeletePurchaceOffer1Image({required this.id});
}

class DeletePurchaceOffer2Image extends PurchaseEvent {
  final int id;
  DeletePurchaceOffer2Image({required this.id});
}

class DeletePurchaceOffer3Image extends PurchaseEvent {
  final int id;
  DeletePurchaceOffer3Image({required this.id});
}

class AddPurchaseDatasheet1Image extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseDatasheet1Image({required this.image, required this.id});
}

class AddPurchaseDatasheet2Image extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseDatasheet2Image({required this.image, required this.id});
}

class AddPurchaseDatasheet3Image extends PurchaseEvent {
  final int id;
  final File image;

  AddPurchaseDatasheet3Image({required this.image, required this.id});
}

class GetPurchaseDatasheet1Image extends PurchaseEvent {
  final int id;
  GetPurchaseDatasheet1Image({required this.id});
}

class GetPurchaseDatasheet2Image extends PurchaseEvent {
  final int id;
  GetPurchaseDatasheet2Image({required this.id});
}

class GetPurchaseDatasheet3Image extends PurchaseEvent {
  final int id;
  GetPurchaseDatasheet3Image({required this.id});
}

class DeletePurchaceDatasheet1Image extends PurchaseEvent {
  final int id;
  DeletePurchaceDatasheet1Image({required this.id});
}

class DeletePurchaceDatasheet2Image extends PurchaseEvent {
  final int id;
  DeletePurchaceDatasheet2Image({required this.id});
}

class DeletePurchaceDatasheet3Image extends PurchaseEvent {
  final int id;
  DeletePurchaceDatasheet3Image({required this.id});
}

class ResetPurchaseState extends PurchaseEvent {}

class ExportExcelReadyToBuy extends PurchaseEvent {}

class ExportExcelPendingOffers extends PurchaseEvent {}

class GetListForPayment extends PurchaseEvent {
  final int page;

  GetListForPayment({required this.page});
}

class ExportExcelForPayment extends PurchaseEvent {
  final List ids;

  ExportExcelForPayment({required this.ids});
}

class ArchiveList extends PurchaseEvent {
  final List ids;

  ArchiveList({required this.ids});
}

class GetPurchasesFilter extends PurchaseEvent {
  final int page;
  final String status;
  final String date_1;
  final String date_2;
  GetPurchasesFilter({
    required this.page,
    required this.status,
    required this.date_1,
    required this.date_2,
  });
}

class MarkNonCompliant extends PurchaseEvent {
  final int id;
  MarkNonCompliant({required this.id});
}
