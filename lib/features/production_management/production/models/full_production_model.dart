// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// import 'package:gmcappclean/features/production_management/production/models/empty_packaging_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/finished_goods_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/lab_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/manufacturing_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/packaging_breakdown_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/packaging_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/production_model.dart';
// import 'package:gmcappclean/features/production_management/production/models/raw_materials_model.dart';

// class FullProductionModel {
//   final ProductionModel productions;
//   final List<PackagingBreakdownModel> packagingBreakdowns;
//   final RawMaterialsModel rawMaterials;
//   final ManufacturingModel manufacturing;
//   final LabModel lab;
//   final EmptyPackagingModel emptyPackaging;
//   final PackagingModel packaging;
//   final FinishedGoodsModel finishedGoods;
//   FullProductionModel({
//     required this.productions,
//     required this.packagingBreakdowns,
//     required this.rawMaterials,
//     required this.manufacturing,
//     required this.lab,
//     required this.emptyPackaging,
//     required this.packaging,
//     required this.finishedGoods,
//   });

//   FullProductionModel copyWith({
//     ProductionModel? productions,
//     List<PackagingBreakdownModel>? packagingBreakdowns,
//     RawMaterialsModel? rawMaterials,
//     ManufacturingModel? manufacturing,
//     LabModel? lab,
//     EmptyPackagingModel? emptyPackaging,
//     PackagingModel? packaging,
//     FinishedGoodsModel? finishedGoods,
//   }) {
//     return FullProductionModel(
//       productions: productions ?? this.productions,
//       packagingBreakdowns: packagingBreakdowns ?? this.packagingBreakdowns,
//       rawMaterials: rawMaterials ?? this.rawMaterials,
//       manufacturing: manufacturing ?? this.manufacturing,
//       lab: lab ?? this.lab,
//       emptyPackaging: emptyPackaging ?? this.emptyPackaging,
//       packaging: packaging ?? this.packaging,
//       finishedGoods: finishedGoods ?? this.finishedGoods,
//     );
//   }

//   factory FullProductionModel.fromMapArchive(Map<String, dynamic> map) {
//     return FullProductionModel(
//       productions: ProductionModel.fromMap(map),
//       packagingBreakdowns: List<PackagingBreakdownModel>.from(
//         (map['packaging_breakdown'] as List<dynamic>)
//             .map<PackagingBreakdownModel>(
//           (x) => PackagingBreakdownModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//       rawMaterials: RawMaterialsModel.fromMap(map['raw_materials']
//           as Map<String, dynamic>), // Changed from raw_materials_data
//       manufacturing: ManufacturingModel.fromMap(map['manufacturing']
//           as Map<String, dynamic>), // Changed from manufacturing_data
//       lab: LabModel.fromMap(
//           map['lab'] as Map<String, dynamic>), // Changed from lab_data
//       emptyPackaging: EmptyPackagingModel.fromMap(map['empty_packaging']
//           as Map<String, dynamic>), // Changed from empty_packaging_data
//       packaging: PackagingModel.fromMap(map['packaging']
//           as Map<String, dynamic>), // Changed from packaging_data
//       finishedGoods: FinishedGoodsModel.fromMap(map['finished_goods']
//           as Map<String, dynamic>), // Changed from finished_goods_data
//     );
//   }
//   factory FullProductionModel.fromMap(Map<String, dynamic> map) {
//     return FullProductionModel(
//       productions: ProductionModel.fromMap(map),
//       packagingBreakdowns: List<PackagingBreakdownModel>.from(
//         (map['packaging_breakdown'] as List<dynamic>)
//             .map<PackagingBreakdownModel>(
//           (x) => PackagingBreakdownModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//       rawMaterials: RawMaterialsModel.fromMap(
//           map['raw_materials'] as Map<String, dynamic>),
//       manufacturing: ManufacturingModel.fromMap(
//           map['manufacturing'] as Map<String, dynamic>),
//       lab: LabModel.fromMap(map['lab'] as Map<String, dynamic>),
//       emptyPackaging: EmptyPackagingModel.fromMap(
//           map['empty_packaging'] as Map<String, dynamic>),
//       packaging:
//           PackagingModel.fromMap(map['packaging'] as Map<String, dynamic>),
//       finishedGoods: FinishedGoodsModel.fromMap(
//           map['finished_goods'] as Map<String, dynamic>),
//     );
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:gmcappclean/features/production_management/production/models/empty_packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/finished_goods_model.dart';
import 'package:gmcappclean/features/production_management/production/models/lab_model.dart';
import 'package:gmcappclean/features/production_management/production/models/manufacturing_model.dart';
import 'package:gmcappclean/features/production_management/production/models/packaging_breakdown_model.dart';
import 'package:gmcappclean/features/production_management/production/models/packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/raw_materials_model.dart';
import 'package:gmcappclean/features/production_management/production/models/quality_control_model.dart';

class FullProductionModel {
  final ProductionModel productions;
  final List<PackagingBreakdownModel> packagingBreakdowns;
  final RawMaterialsModel rawMaterials;
  final ManufacturingModel manufacturing;
  final LabModel lab;
  final EmptyPackagingModel emptyPackaging;
  final PackagingModel packaging;
  final FinishedGoodsModel finishedGoods;
  final QualityControlModel qualityControl;
  FullProductionModel({
    required this.productions,
    required this.packagingBreakdowns,
    required this.rawMaterials,
    required this.manufacturing,
    required this.lab,
    required this.emptyPackaging,
    required this.packaging,
    required this.finishedGoods,
    required this.qualityControl,
  });

  FullProductionModel copyWith({
    ProductionModel? productions,
    List<PackagingBreakdownModel>? packagingBreakdowns,
    RawMaterialsModel? rawMaterials,
    ManufacturingModel? manufacturing,
    LabModel? lab,
    EmptyPackagingModel? emptyPackaging,
    PackagingModel? packaging,
    FinishedGoodsModel? finishedGoods,
    QualityControlModel? qualityControl,
  }) {
    return FullProductionModel(
      productions: productions ?? this.productions,
      packagingBreakdowns: packagingBreakdowns ?? this.packagingBreakdowns,
      rawMaterials: rawMaterials ?? this.rawMaterials,
      manufacturing: manufacturing ?? this.manufacturing,
      lab: lab ?? this.lab,
      emptyPackaging: emptyPackaging ?? this.emptyPackaging,
      packaging: packaging ?? this.packaging,
      finishedGoods: finishedGoods ?? this.finishedGoods,
      qualityControl: qualityControl ?? this.qualityControl,
    );
  }

  factory FullProductionModel.fromMapArchive(Map<String, dynamic> map) {
    return FullProductionModel(
      productions: ProductionModel.fromMap(map),
      packagingBreakdowns: List<PackagingBreakdownModel>.from(
        (map['packaging_breakdown'] as List<dynamic>)
            .map<PackagingBreakdownModel>(
          (x) => PackagingBreakdownModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      rawMaterials: RawMaterialsModel.fromMap(map['raw_materials']
          as Map<String, dynamic>), // Changed from raw_materials_data
      manufacturing: ManufacturingModel.fromMap(map['manufacturing']
          as Map<String, dynamic>), // Changed from manufacturing_data
      lab: LabModel.fromMap(
          map['lab'] as Map<String, dynamic>), // Changed from lab_data
      emptyPackaging: EmptyPackagingModel.fromMap(map['empty_packaging']
          as Map<String, dynamic>), // Changed from empty_packaging_data
      packaging: PackagingModel.fromMap(map['packaging']
          as Map<String, dynamic>), // Changed from packaging_data
      finishedGoods: FinishedGoodsModel.fromMap(map['finished_goods']
          as Map<String, dynamic>), // Changed from finished_goods_data
      qualityControl: QualityControlModel.fromMap(map['quality_control']
          as Map<String, dynamic>), // Changed from quality_control_data
    );
  }

  factory FullProductionModel.fromMap(Map<String, dynamic> map) {
    return FullProductionModel(
      productions: ProductionModel.fromMap(map),
      packagingBreakdowns: List<PackagingBreakdownModel>.from(
        (map['packaging_breakdown'] as List<dynamic>)
            .map<PackagingBreakdownModel>(
          (x) => PackagingBreakdownModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      rawMaterials: RawMaterialsModel.fromMap(
          map['raw_materials'] as Map<String, dynamic>),
      manufacturing: ManufacturingModel.fromMap(
          map['manufacturing'] as Map<String, dynamic>),
      lab: LabModel.fromMap(map['lab'] as Map<String, dynamic>),
      emptyPackaging: EmptyPackagingModel.fromMap(
          map['empty_packaging'] as Map<String, dynamic>),
      packaging:
          PackagingModel.fromMap(map['packaging'] as Map<String, dynamic>),
      finishedGoods: FinishedGoodsModel.fromMap(
          map['finished_goods'] as Map<String, dynamic>),
      qualityControl: QualityControlModel.fromMap(
          map['quality_control'] as Map<String, dynamic>),
    );
  }
}
