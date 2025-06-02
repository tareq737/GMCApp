import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/production_management/additional_operations/models/additional_operations_model.dart';
import 'package:gmcappclean/features/production_management/additional_operations/services/additional_operations_services.dart';
import 'package:meta/meta.dart';

part 'additional_operations_event.dart';
part 'additional_operations_state.dart';

class AdditionalOperationsBloc
    extends Bloc<AdditionalOperationsEvent, AdditionalOperationsState> {
  final AdditionalOperationsServices _additionalOperationsServices;
  AdditionalOperationsBloc(this._additionalOperationsServices)
      : super(AdditionalOperationsInitial()) {
    on<AdditionalOperationsEvent>((event, emit) async {
      emit(AdditionalOperationsLoading());
    });

    on<GetAdditionalOperationsPagainted>(
      (event, emit) async {
        var result =
            await _additionalOperationsServices.getAllAdditionalOperations(
          page: event.page,
          department: event.department,
          done: event.done,
        );
        if (result == null) {
          emit(AdditionalOperationsError(errorMessage: 'Error'));
        } else {
          emit(AdditionalOperationsSuccess(result: result));
        }
      },
    );
    on<AddAdditionalOperation>(
      (event, emit) async {
        var result = await _additionalOperationsServices
            .addAdditionalOperation(event.additionalOperationsModel);
        if (result == null) {
          emit(AdditionalOperationsError(errorMessage: 'Error'));
        } else {
          emit(AdditionalOperationsSuccess(result: result));
        }
      },
    );
    on<UpdateAdditionalOperation>(
      (event, emit) async {
        var result =
            await _additionalOperationsServices.updateAdditionalOperation(
                id: event.id,
                additionalOperationsModel: event.additionalOperationsModel);
        if (result == null) {
          emit(AdditionalOperationsError(errorMessage: 'Error'));
        } else {
          emit(AdditionalOperationsSuccess(result: result));
        }
      },
    );

    on<GetOneAdditionalOperations>(
      (event, emit) async {
        var result = await _additionalOperationsServices
            .getOneAdditionalOperationByID(id: event.id);
        if (result == null) {
          emit(AdditionalOperationsError(
              errorMessage: 'Error fetching purchase with ID: ${event.id}'));
        } else {
          emit(AdditionalOperationsSuccess(result: result));
        }
      },
    );
  }
}
