// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'production_bloc.dart';

@immutable
sealed class ProductionEvent {}

class GetBriefProductionPagainted extends ProductionEvent {
  final int page;
  final String? type;
  final String? tier;
  final String? color;
  final String? search;
  final String? date1;
  final String? date2;

  GetBriefProductionPagainted(
      {required this.page,
      this.type,
      this.tier,
      this.color,
      this.search,
      this.date1,
      this.date2});
}

class GetOneProductionByID extends ProductionEvent {
  final int id;

  GetOneProductionByID({required this.id});
}

class SearchProductionArchivePagainted extends ProductionEvent {
  final int page;
  final String? type;
  final String? tier;
  final String? color;
  final String? search;
  final String? date1;
  final String? date2;
  SearchProductionArchivePagainted(
      {required this.page,
      this.date1,
      this.date2,
      this.type,
      this.tier,
      this.search,
      this.color});
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

final class SaveQualityControl<T> extends ProductionEvent {
  final QualityControlModel qualityControlModel;

  SaveQualityControl({required this.qualityControlModel});
}

class Archive extends ProductionEvent {
  final int id;

  Archive({
    required this.id,
  });
}

class UnArchive extends ProductionEvent {
  final int id;

  UnArchive({
    required this.id,
  });
}

class RevertToProdplanning extends ProductionEvent {
  final int id;

  RevertToProdplanning({
    required this.id,
  });
}

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

class GenerateLoyaltyQr extends ProductionEvent {
  int id;
  GenerateLoyaltyQr({
    required this.id,
  });
}

class GenrateLabelPdf extends ProductionEvent {
  double length;
  double width;
  String content;
  String paper_size;
  GenrateLabelPdf({
    required this.length,
    required this.width,
    required this.content,
    required this.paper_size,
  });
}
