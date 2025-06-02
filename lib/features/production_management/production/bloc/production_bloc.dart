import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gmcappclean/features/production_management/production/models/brief_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/empty_packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/finished_goods_model.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/lab_model.dart';
import 'package:gmcappclean/features/production_management/production/models/manufacturing_model.dart';
import 'package:gmcappclean/features/production_management/production/models/packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/raw_materials_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:meta/meta.dart';

part 'production_event.dart';
part 'production_state.dart';

class ProductionBloc extends Bloc<ProductionEvent, ProductionState> {
  final ProductionServices _productionServices;
  ProductionBloc(this._productionServices) : super(ProductionInitial()) {
    on<ProductionEvent>((event, emit) async {
      emit(ProductionLoading());
    });
    on<GetBriefProductionPagainted>(
      (event, emit) async {
        var result = await _productionServices.getAllProduction(
          page: event.page,
        );
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess(result: result));
        }
      },
    );
    on<SearchProductionArchivePagainted>(
      (event, emit) async {
        var result = await _productionServices.searchProductionArchive(
          page: event.page,
          search: event.search,
        );
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess(result: result));
        }
      },
    );
    on<GetOneProductionByID>(
      (event, emit) async {
        var result = await _productionServices.getOneProductionByID(event.id);
        if (result == null) {
          emit(ProductionError(
              errorMessage: 'Error fetching purchase with ID: ${event.id}'));
        } else {
          emit(ProductionSuccess(result: result));
        }
      },
    );
    on<GetOneProductionArchiveByID>(
      (event, emit) async {
        var result =
            await _productionServices.getOneProductionByIDArchive(event.id);
        if (result == null) {
          emit(ProductionError(
              errorMessage: 'Error fetching purchase with ID: ${event.id}'));
        } else {
          emit(ProductionSuccess(result: result));
        }
      },
    );
    on<SaveRawMaterial>(
      (event, emit) async {
        var result = await _productionServices.saveRawMaterial(
            event.rawMaterialsModel.id!, event.rawMaterialsModel);
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess<RawMaterialsModel>(result: result));
        }
      },
    );
    on<SaveManufacturing>(
      (event, emit) async {
        var result = await _productionServices.saveManufacturing(
            event.manufacturingModel.id!, event.manufacturingModel);
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess<ManufacturingModel>(result: result));
        }
      },
    );
    on<SaveLab>(
      (event, emit) async {
        var result = await _productionServices.saveLab(
            event.labModel.id!, event.labModel);
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess<LabModel>(result: result));
        }
      },
    );
    on<SaveEmptyPackaging>(
      (event, emit) async {
        var result = await _productionServices.saveEmptyPackaging(
            event.emptyPackagingModel.id!, event.emptyPackagingModel);
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess<EmptyPackagingModel>(result: result));
        }
      },
    );
    on<SavePackaging>(
      (event, emit) async {
        var result = await _productionServices.savePackaging(
            event.packagingModel.id!, event.packagingModel);
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess<PackagingModel>(result: result));
        }
      },
    );
    on<SaveFinishedGoods>(
      (event, emit) async {
        var result = await _productionServices.saveFinishedGoods(
            event.finishedGoodsModel.id!, event.finishedGoodsModel);
        if (result == null) {
          emit(ProductionError(errorMessage: 'Error'));
        } else {
          emit(ProductionSuccess<FinishedGoodsModel>(result: result));
        }
      },
    );
    on<Archive>(
      (event, emit) async {
        var result = await _productionServices.archive(event.id);
        result.fold((failure) {
          emit(ProductionError(errorMessage: failure.message));
        }, (success) {
          emit(ProductionSuccess<String>(result: success));
        });
      },
    );
  }
}
