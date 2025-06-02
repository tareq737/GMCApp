// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProdPlanEntity {
  int id;
  String? type;
  String? tier;
  String? color;
  String? insertDate;
  List<PackageBreakdownEntity>? packagingBreakdown;
  double? totalWeight;
  double? totalVolume;
  double? density;
  bool? rawMaterialCheck;
  bool? packagingCheck;
  bool? manufacturingCheck;
  bool? labCheck;
  bool? emptyPackagingCheck;
  bool? finishedGoodsCheck;
  String? rawMaterialNote;
  String? packagingNote;
  String? manufacturingNote;
  String? labNote;
  String? emptyPackagingNote;
  String? finishedGoodsNote;
  String? preparedByNotes;

  ProdPlanEntity({
    required this.id,
    this.type,
    this.tier,
    this.color,
    this.insertDate,
    this.packagingBreakdown,
    this.totalWeight,
    this.totalVolume,
    this.density,
    this.rawMaterialCheck,
    this.packagingCheck,
    this.manufacturingCheck,
    this.labCheck,
    this.emptyPackagingCheck,
    this.finishedGoodsCheck,
    this.labNote,
    this.emptyPackagingNote,
    this.finishedGoodsNote,
    this.manufacturingNote,
    this.packagingNote,
    this.rawMaterialNote,
    this.preparedByNotes,
  });
}

class PackageBreakdownEntity {
  String brand;
  String packageType;
  double? packageWeight;
  double? packageVolume;
  int quantity;
  double? sumWeight;
  double? sumVolume;
  PackageBreakdownEntity({
    required this.brand,
    required this.packageType,
    this.packageWeight,
    this.packageVolume,
    required this.quantity,
    this.sumWeight,
    this.sumVolume,
  });
}
