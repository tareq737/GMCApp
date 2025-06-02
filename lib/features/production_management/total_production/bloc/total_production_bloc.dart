// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:gmcappclean/features/production_management/total_production/services/total_production_services.dart';

part 'total_production_event.dart';
part 'total_production_state.dart';

class TotalProductionBloc
    extends Bloc<TotalProductionEvent, TotalProductionState> {
  final TotalProductionServices _totalProductionServices;
  TotalProductionBloc(
    this._totalProductionServices,
  ) : super(TotalProductionInitial()) {
    on<TotalProductionEvent>((event, emit) async {
      emit(TotalProductionLoading());
    });
    on<GetTotalProductionPagainted>(
      (event, emit) async {
        var result = await _totalProductionServices.getAllOperations(
            page: event.page,
            department: event.department,
            worker: event.worker,
            date1: event.date1,
            date2: event.date2);
        if (result == null) {
          emit(TotalProductionError(errorMessage: 'Error'));
        } else {
          emit(TotalProductionSuccess(result: result));
        }
      },
    );
    on<ExportExcelTasks>(
      (event, emit) async {
        // Call the service function
        var result = await _totalProductionServices.exportExcelTasks(
          department: event.department,
        );

        // Use .fold to handle either success (left) or failure (right)
        result.fold(
          (successBytes) {
            // This block is executed if result is Left (Uint8List)
            emit(TotalProductionSuccess(result: successBytes));
          },
          (failure) {
            // This block is executed if result is Right (a Failure)
            emit(TotalProductionError(errorMessage: 'Error'));
          },
        );
      },
    );
  }
}
