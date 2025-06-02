import 'dart:convert';

import 'package:gmcappclean/core/error/exceptions.dart';

class ProdPlanModel {
  int id;
  String? type;
  String? tier;
  String? color;
  String? insertDate;
  List<PackageBreakdownModel>? packagingBreakdown;
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

  ProdPlanModel({
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
    this.rawMaterialNote,
    this.packagingNote,
    this.manufacturingNote,
    this.labNote,
    this.emptyPackagingNote,
    this.finishedGoodsNote,
    this.preparedByNotes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'tier': tier,
      'color': color,
      'insert_date': insertDate,
      'packaging_breakdowns':
          packagingBreakdown?.map((x) => x.toMap()).toList(),
      'total_weight': totalWeight,
      'total_volume': totalVolume,
      'density': density,
      'raw_material_check': rawMaterialCheck,
      'packaging_check': packagingCheck,
      'manufacturing_check': manufacturingCheck,
      'lab_check': labCheck,
      'emptyPackaging_check': emptyPackagingCheck,
      'finishedGoods_check': finishedGoodsCheck,
      'raw_material_notes': rawMaterialNote,
      'packaging_notes': packagingNote,
      'manufacturing_notes': manufacturingNote,
      'lab_notes': labNote,
      'emptyPackaging_notes': emptyPackagingNote,
      'finishedGoods_notes': finishedGoodsNote,
      'prepared_by_notes': preparedByNotes,
    };
  }

  Map<String, dynamic> toNoNullMap() {
    return <String, dynamic>{
      'id': id,
      if (type != null) 'type': type,
      if (tier != null) 'tier': tier,
      if (color != null) 'color': color,
      if (insertDate != null) 'insert_date': insertDate,
      if (packagingBreakdown != null)
        'packaging_breakdowns':
            packagingBreakdown!.map((x) => x.toMap()).toList(),
      if (totalWeight != null) 'total_weight': totalWeight,
      if (totalVolume != null) 'total_volume': totalVolume,
      if (density != null) 'density': density,
      if (rawMaterialCheck != null) 'raw_material_check': rawMaterialCheck,
      if (packagingCheck != null) 'packaging_check': packagingCheck,
      if (manufacturingCheck != null) 'manufacturing_check': manufacturingCheck,
      if (labCheck != null) 'lab_check': labCheck,
      if (emptyPackagingCheck != null)
        'emptyPackaging_check': emptyPackagingCheck,
      if (finishedGoodsCheck != null) 'finishedGoods_check': finishedGoodsCheck,
      if (rawMaterialNote != null) 'raw_material_notes': rawMaterialNote,
      if (packagingNote != null) 'packaging_notes': packagingNote,
      if (manufacturingNote != null) 'manufacturing_notes': manufacturingNote,
      if (labNote != null) 'lab_notes': labNote,
      if (emptyPackagingNote != null)
        'emptyPackaging_notes': emptyPackagingNote,
      if (finishedGoodsNote != null) 'finishedGoods_notes': finishedGoodsNote,
      if (preparedByNotes != null) 'prepared_by_notes': preparedByNotes,
    };
  }

  factory ProdPlanModel.fromMap(Map<String, dynamic> map) {
    return ProdPlanModel(
      id: map['id'] as int,
      type: map['type'] != null ? map['type'] as String : null,
      tier: map['tier'] != null ? map['tier'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      insertDate:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      packagingBreakdown: map['packaging_breakdowns'] is List
          ? List<PackageBreakdownModel>.from(
              (map['packaging_breakdowns'] as List).map(
                (item) {
                  if (item is Map<String, dynamic>) {
                    return PackageBreakdownModel.fromMap(item);
                  } else {
                    throw const ServerException(
                        'Invalid item in packaging breakdown list, expceted Map<String, dynamic>');
                  }
                },
              ),
            )
          : null,
      totalWeight:
          map['total_weight'] != null ? map['total_weight'] as double : null,
      totalVolume:
          map['total_volume'] != null ? map['total_volume'] as double : null,
      density: map['density'] != null ? map['density'] as double : null,
      rawMaterialCheck: map['raw_material_check'] != null
          ? map['raw_material_check'] as bool
          : null,
      packagingCheck: map['packaging_check'] != null
          ? map['packaging_check'] as bool
          : null,
      manufacturingCheck: map['manufacturing_check'] != null
          ? map['manufacturing_check'] as bool
          : null,
      labCheck: map['lab_check'] != null ? map['lab_check'] as bool : null,
      emptyPackagingCheck: map['emptyPackaging_check'] != null
          ? map['emptyPackaging_check'] as bool
          : null,
      finishedGoodsCheck: map['finishedGoods_check'] != null
          ? map['finishedGoods_check'] as bool
          : null,
      rawMaterialNote: map['raw_material_notes'] != null
          ? map['raw_material_notes'] as String
          : null,
      packagingNote: map['packaging_notes'] != null
          ? map['packaging_notes'] as String
          : null,
      manufacturingNote: map['manufacturing_notes'] != null
          ? map['manufacturing_notes'] as String
          : null,
      labNote: map['lab_notes'] != null ? map['lab_notes'] as String : null,
      emptyPackagingNote: map['emptyPackaging_notes'] != null
          ? map['emptyPackaging_notes'] as String
          : null,
      finishedGoodsNote: map['finishedGoods_notes'] != null
          ? map['finishedGoods_notes'] as String
          : null,
      preparedByNotes: map['prepared_by_notes'] != null
          ? map['prepared_by_notes'] as String
          : null,
    );
  }

  String toJson() => json.encode(toNoNullMap());

  factory ProdPlanModel.fromJson(String source) =>
      ProdPlanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProdPlanModel(id: $id, type: $type, tier: $tier, color: $color, insertDate: $insertDate, packagingBreakdown: $packagingBreakdown, totalWeight: $totalWeight, totalVolume: $totalVolume, density: $density, rawMaterialCheck: $rawMaterialCheck, packagingCheck: $packagingCheck, manufacturingCheck: $manufacturingCheck, labCheck: $labCheck, emptyPackagingCheck: $emptyPackagingCheck, finishedGoodsCheck: $finishedGoodsCheck, rawMaterialNote: $rawMaterialNote, packagingNote: $packagingNote, manufacturingNote: $manufacturingNote, labNote: $labNote, emptyPackagingNote: $emptyPackagingNote, finishedGoodsNote: $finishedGoodsNote, preparedByNotes: $preparedByNotes)';
  }
}

class PackageBreakdownModel {
  String brand;
  String packageType;
  double? packageWeight;
  double? packageVolume;
  int quantity;
  double? sumWeight;
  double? sumVolume;
  PackageBreakdownModel({
    required this.brand,
    required this.packageType,
    this.packageWeight,
    this.packageVolume,
    required this.quantity,
    this.sumWeight,
    this.sumVolume,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brand': brand,
      'package_type': packageType,
      'package_weight': packageWeight,
      'package_volume': packageVolume,
      'quantity': quantity,
      'sum_weight': sumWeight,
      'sum_volume': sumVolume,
    };
  }

  factory PackageBreakdownModel.fromMap(Map<String, dynamic> map) {
    return PackageBreakdownModel(
      brand: map['brand'] as String,
      packageType: map['package_type'] as String,
      packageWeight: map['package_weight'] != null
          ? map['package_weight'] as double
          : null,
      packageVolume: map['package_volume'] != null
          ? map['package_volume'] as double
          : null,
      quantity: map['quantity'] as int,
      sumWeight: map['sum_weight'] != null ? map['sum_weight'] as double : null,
      sumVolume: map['sum_volume'] != null ? map['sum_volume'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageBreakdownModel.fromJson(String source) =>
      PackageBreakdownModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
