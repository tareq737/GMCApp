import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/usecases/usecases_barrel.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/mapper/prod_planning_mapper.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/check_view_model.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/prod_planning_viewmodel.dart';

part 'production_event.dart';
part 'production_state.dart';

class ProdPlanBloc extends Bloc<ProdEvent, ProdState> {
  final AddProdPlanning _addProdPlanningUnit;
  final DeleteProdPlan _deleteProdPlan;
  final GetAllProdPlan _getAllProdPlan;
  final GetProdPlan _getProdPlan;
  final SearchProdPlan _searchProdPlan;
  final UpdateProdPlan _updateProdPlan;
  final DepCheckProdPlan _checkProdPlan;
  final TransferProdPlanToProd _transferProdPlanToProd;

  ProdPlanBloc({
    required AddProdPlanning addProdPlanningUnit,
    required DeleteProdPlan deleteProdPlan,
    required GetAllProdPlan getAllProdPlan,
    required GetProdPlan getProdPlan,
    required SearchProdPlan searchProdPlan,
    required UpdateProdPlan updateProdPlan,
    required DepCheckProdPlan checkProdPlan,
    required TransferProdPlanToProd transferProdPlanToProd,
  })  : _addProdPlanningUnit = addProdPlanningUnit,
        _deleteProdPlan = deleteProdPlan,
        _getAllProdPlan = getAllProdPlan,
        _getProdPlan = getProdPlan,
        _searchProdPlan = searchProdPlan,
        _updateProdPlan = updateProdPlan,
        _checkProdPlan = checkProdPlan,
        _transferProdPlanToProd = transferProdPlanToProd,
        super(ProdInitial()) {
    on<ProdEvent>((event, emit) => emit(ProdOpLoading()));
    on<ProdAdd<ProdPlanViewModel>>(_onProdPlanAdd);
    on<ProdUpdate<ProdPlanViewModel>>(_onProdPlanUpdate);
    on<ProdDelete<ProdPlanViewModel>>(_onProdPlanDelete);
    on<ProdGetById<ProdPlanViewModel>>(_onProdPlanGetId);
    on<ProdSearch<ProdPlanViewModel>>(_onProdPlanSearch);
    on<ProdGetAll<ProdPlanViewModel>>(_onProdPlanGetAll);
    on<ProdPlanCheck>(_onProdPlanCheck);
    on<ProdPlanTransfer>(_onProdPlanTransfer);
  }

  void _onProdPlanTransfer(
      ProdPlanTransfer event, Emitter<ProdState> emit) async {
    final result = await _transferProdPlanToProd(event.id);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(ProdOpSuccess<String>(opResult: 'Plan moved to Prod Table'));
      },
    );
  }

  void _onProdPlanCheck(ProdPlanCheck event, Emitter<ProdState> emit) async {
    final result = await _checkProdPlan(event.check);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(ProdOpSuccess<String>(opResult: 'تم التشطيب'));
      },
    );
  }

  void _onProdPlanAdd(
      ProdAdd<ProdPlanViewModel> event, Emitter<ProdState> emit) async {
    final result = await _addProdPlanningUnit(event.item);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(
          ProdOpSuccess<ProdPlanViewModel>(
            opResult: ProdPlanPresentationMapper.toViewModel(entity: success),
          ),
        );
      },
    );
  }

  void _onProdPlanUpdate(
      ProdUpdate<ProdPlanViewModel> event, Emitter<ProdState> emit) async {
    final result = await _updateProdPlan(event.item);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(
          ProdOpSuccess<ProdPlanViewModel>(
            opResult: ProdPlanPresentationMapper.toViewModel(entity: success),
          ),
        );
      },
    );
  }

  void _onProdPlanDelete(
      ProdDelete<ProdPlanViewModel> event, Emitter<ProdState> emit) async {
    final result = await _deleteProdPlan(event.id);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(ProdOpSuccess<String>(opResult: 'Plan deleted successfully'));
      },
    );
  }

  void _onProdPlanGetId(
      ProdGetById<ProdPlanViewModel> event, Emitter<ProdState> emit) async {
    final result = await _getProdPlan(event.id);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(
          ProdOpSuccess<ProdPlanViewModel>(
            opResult: ProdPlanPresentationMapper.toViewModel(entity: success),
          ),
        );
      },
    );
  }

  void _onProdPlanSearch(
      ProdSearch<ProdPlanViewModel> event, Emitter<ProdState> emit) async {
    final result = await _searchProdPlan(event.lexum);
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(
          ProdOpSuccess<List<ProdPlanViewModel>>(
            opResult: List.generate(
              success.length,
              (index) {
                return ProdPlanPresentationMapper.toViewModel(
                    entity: success[index]);
              },
            ),
          ),
        );
      },
    );
  }

  void _onProdPlanGetAll(
      ProdGetAll<ProdPlanViewModel> event, Emitter<ProdState> emit) async {
    final result = await _getAllProdPlan(NoParams());
    result.fold(
      (failure) {
        emit(ProdOpFailure(message: failure.message));
      },
      (success) {
        emit(
          ProdOpSuccess<List<ProdPlanViewModel>>(
            opResult: List.generate(
              success.length,
              (index) {
                return ProdPlanPresentationMapper.toViewModel(
                    entity: success[index]);
              },
            ),
          ),
        );
      },
    );
  }
}
