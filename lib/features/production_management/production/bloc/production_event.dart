part of 'production_bloc.dart';

@immutable
sealed class ProductionEvent {}

class GetBriefProductionPagainted extends ProductionEvent {
  final int page;

  GetBriefProductionPagainted({required this.page});
}

class GetOneProductionByID extends ProductionEvent {
  final int id;

  GetOneProductionByID({required this.id});
}

class SearchProductionArchivePagainted extends ProductionEvent {
  final int page;
  final String search;

  SearchProductionArchivePagainted({required this.page, required this.search});
}

class GetOneProductionArchiveByID extends ProductionEvent {
  final int id;

  GetOneProductionArchiveByID({required this.id});
}

final class SaveRawMaterial<T> extends ProductionEvent {
  final RawMaterialsModel rawMaterialsModel;

  SaveRawMaterial({required this.rawMaterialsModel});
}

final class SaveManufacturing<T> extends ProductionEvent {
  final ManufacturingModel manufacturingModel;

  SaveManufacturing({required this.manufacturingModel});
}

final class SaveLab<T> extends ProductionEvent {
  final LabModel labModel;

  SaveLab({required this.labModel});
}

final class SaveEmptyPackaging<T> extends ProductionEvent {
  final EmptyPackagingModel emptyPackagingModel;

  SaveEmptyPackaging({required this.emptyPackagingModel});
}

final class SavePackaging<T> extends ProductionEvent {
  final PackagingModel packagingModel;

  SavePackaging({required this.packagingModel});
}

final class SaveFinishedGoods<T> extends ProductionEvent {
  final FinishedGoodsModel finishedGoodsModel;

  SaveFinishedGoods({required this.finishedGoodsModel});
}

class Archive extends ProductionEvent {
  final int id;

  Archive({
    required this.id,
  });
}

// class SeachArchive extends ProductionEvent {
//   final String lexum;

//   SeachArchive({required this.lexum});
// }
class AllProduction extends ProductionEvent {
  final int page;
  final String search;

  AllProduction({required this.page, required this.search});
}

class GetProductionFilter extends ProductionEvent {
  final int page;
  final String status;
  final String type;
  final String date_1;
  final String date_2;
  final String timeliness;

  GetProductionFilter(
      {required this.page,
      required this.status,
      required this.type,
      required this.date_1,
      required this.date_2,
      required this.timeliness});
}
