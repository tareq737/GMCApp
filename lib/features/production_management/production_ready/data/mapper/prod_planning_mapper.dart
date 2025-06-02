import 'package:gmcappclean/features/production_management/production_ready/data/models/check_model.dart';
import 'package:gmcappclean/features/production_management/production_ready/data/models/prod_planning_model.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/check_entity.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';

class ProdPlanDataMapper {
  static ProdPlanEntity toEntity({required ProdPlanModel model}) {
    return ProdPlanEntity(
      id: model.id,
      type: model.type,
      tier: model.tier,
      color: model.color,
      insertDate: model.insertDate,
      packagingBreakdown: _toPackagingEntity(model: model.packagingBreakdown),
      totalVolume: model.totalVolume,
      totalWeight: model.totalWeight,
      density: model.density,
      rawMaterialCheck: model.rawMaterialCheck,
      manufacturingCheck: model.manufacturingCheck,
      labCheck: model.labCheck,
      packagingCheck: model.packagingCheck,
      finishedGoodsCheck: model.finishedGoodsCheck,
      emptyPackagingCheck: model.emptyPackagingCheck,
      labNote: model.labNote,
      packagingNote: model.packagingNote,
      rawMaterialNote: model.rawMaterialNote,
      manufacturingNote: model.manufacturingNote,
      finishedGoodsNote: model.finishedGoodsNote,
      emptyPackagingNote: model.emptyPackagingNote,
      preparedByNotes: model.preparedByNotes,
    );
  }

  static ProdPlanModel toModel({required ProdPlanEntity entity}) {
    return ProdPlanModel(
      id: entity.id,
      type: entity.type,
      tier: entity.tier,
      color: entity.color,
      insertDate: entity.insertDate,
      packagingBreakdown: _toPackagingModel(entity: entity.packagingBreakdown),
      totalVolume: entity.totalVolume,
      totalWeight: entity.totalWeight,
      density: entity.density,
      rawMaterialCheck: entity.rawMaterialCheck,
      manufacturingCheck: entity.manufacturingCheck,
      labCheck: entity.labCheck,
      packagingCheck: entity.packagingCheck,
      finishedGoodsCheck: entity.finishedGoodsCheck,
      emptyPackagingCheck: entity.emptyPackagingCheck,
      labNote: entity.labNote,
      packagingNote: entity.packagingNote,
      rawMaterialNote: entity.rawMaterialNote,
      manufacturingNote: entity.manufacturingNote,
      finishedGoodsNote: entity.finishedGoodsNote,
      emptyPackagingNote: entity.emptyPackagingNote,
      preparedByNotes: entity.preparedByNotes,
    );
  }

  static List<PackageBreakdownEntity>? _toPackagingEntity(
      {List<PackageBreakdownModel>? model}) {
    if (model is List<PackageBreakdownModel>) {
      return List.generate(
        model.length,
        (index) {
          return PackageBreakdownEntity(
            brand: model[index].brand,
            packageType: model[index].packageType,
            packageWeight: model[index].packageWeight,
            packageVolume: model[index].packageVolume,
            quantity: model[index].quantity,
            sumVolume: model[index].sumVolume,
            sumWeight: model[index].sumWeight,
          );
        },
      );
    } else {
      return null;
    }
  }

  static List<PackageBreakdownModel>? _toPackagingModel(
      {List<PackageBreakdownEntity>? entity}) {
    if (entity is List<PackageBreakdownEntity>) {
      return List.generate(
        entity.length,
        (index) {
          return PackageBreakdownModel(
            brand: entity[index].brand,
            packageType: entity[index].packageType,
            packageWeight: entity[index].packageWeight,
            packageVolume: entity[index].packageVolume,
            quantity: entity[index].quantity,
            sumVolume: entity[index].sumVolume,
            sumWeight: entity[index].sumWeight,
          );
        },
      );
    } else {
      return null;
    }
  }

  static CheckModel toCheckModel({required CheckEntity entity}) {
    return CheckModel(
      depId: entity.depId,
      planId: entity.planId,
      notes: entity.notes,
      check: entity.check,
      density: entity.density,
    );
  }

  static CheckEntity toCheckEntity({required CheckModel model}) {
    return CheckEntity(
      check: model.check,
      notes: model.notes,
      depId: model.depId,
      planId: model.planId,
      density: model.density,
    );
  }
}
