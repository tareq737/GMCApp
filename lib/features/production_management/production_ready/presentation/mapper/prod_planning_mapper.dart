import 'package:gmcappclean/features/production_management/production_ready/domain/entities/check_entity.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/check_view_model.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/prod_planning_viewmodel.dart';

class ProdPlanPresentationMapper {
  static ProdPlanEntity toEntity({required ProdPlanViewModel viewModel}) {
    return ProdPlanEntity(
      id: viewModel.id,
      type: viewModel.type,
      tier: viewModel.tier,
      color: viewModel.color,
      insertDate: viewModel.insertDate,
      packagingBreakdown:
          _toPackagingEntity(viewModel: viewModel.packagingBreakdown),
      totalVolume: viewModel.totalVolume,
      totalWeight: viewModel.totalWeight,
      density: viewModel.density,
      rawMaterialCheck: viewModel.depChecks['rawMaterial'],
      manufacturingCheck: viewModel.depChecks['manufacturing'],
      labCheck: viewModel.depChecks['lab'],
      packagingCheck: viewModel.depChecks['packaging'],
      finishedGoodsCheck: viewModel.depChecks['finishedGoods'],
      emptyPackagingCheck: viewModel.depChecks['emptyPackaging'],
      labNote: viewModel.depNotes['lab'],
      packagingNote: viewModel.depNotes['packaging'],
      rawMaterialNote: viewModel.depNotes['rawMaterial'],
      manufacturingNote: viewModel.depNotes['manufacturing'],
      finishedGoodsNote: viewModel.depNotes['finishedGoods'],
      emptyPackagingNote: viewModel.depNotes['emptyPackaging'],
      preparedByNotes: viewModel.preparedByNotes,
    );
  }

  static ProdPlanViewModel toViewModel({required ProdPlanEntity entity}) {
    return ProdPlanViewModel(
      id: entity.id,
      type: entity.type ?? '',
      tier: entity.tier ?? '',
      color: entity.color ?? '',
      insertDate: entity.insertDate,
      totalVolume: entity.totalVolume,
      totalWeight: entity.totalWeight,
      density: entity.density,
      depChecks: {
        'lab': entity.labCheck,
        'rawMaterial': entity.rawMaterialCheck,
        'manufacturing': entity.manufacturingCheck,
        'emptyPackaging': entity.emptyPackagingCheck,
        'packaging': entity.packagingCheck,
        'finishedGoods': entity.finishedGoodsCheck,
      },
      depNotes: {
        'lab': entity.labNote,
        'rawMaterial': entity.rawMaterialNote,
        'manufacturing': entity.manufacturingNote,
        'emptyPackaging': entity.emptyPackagingNote,
        'packaging': entity.packagingNote,
        'finishedGoods': entity.finishedGoodsNote,
      },
      preparedByNotes: entity.preparedByNotes,
      packagingBreakdown:
          _toPackagingViewModel(entity: entity.packagingBreakdown),
    );
  }

  static List<PackageBreakdownEntity>? _toPackagingEntity(
      {List<PackageBreakdownViewModel>? viewModel}) {
    if (viewModel is List<PackageBreakdownViewModel>) {
      return List.generate(
        viewModel.length,
        (index) {
          return PackageBreakdownEntity(
            brand: viewModel[index].brand,
            packageType: viewModel[index].packageType,
            packageWeight: viewModel[index].packageWeight,
            packageVolume: viewModel[index].packageVolume,
            quantity: viewModel[index].quantity,
            sumVolume: viewModel[index].sumVolume,
            sumWeight: viewModel[index].sumWeight,
          );
        },
      );
    } else {
      return null;
    }
  }

  static List<PackageBreakdownViewModel>? _toPackagingViewModel(
      {List<PackageBreakdownEntity>? entity}) {
    if (entity is List<PackageBreakdownEntity>) {
      return List.generate(
        entity.length,
        (index) {
          return PackageBreakdownViewModel(
            brand: entity[index].brand,
            packageType: entity[index].packageType,
            packageWeight: entity[index].packageWeight ?? 0.0,
            packageVolume: entity[index].packageVolume ?? 0.0,
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

  static CheckEntity toCheckEntity({required CheckViewModel viewmodel}) {
    return CheckEntity(
      check: viewmodel.check,
      notes: viewmodel.notes,
      depId: viewmodel.depId,
      planId: viewmodel.planId,
      density: viewmodel.density,
    );
  }

  static CheckViewModel toCheckViewModel({required CheckEntity entity}) {
    return CheckViewModel(
      density: entity.density,
      planId: entity.planId,
      check: entity.check,
      notes: entity.notes,
      depId: entity.depId,
    );
  }
}
