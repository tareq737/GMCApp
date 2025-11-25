import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/call_model.dart';
import 'package:gmcappclean/features/sales_management/operations/models/visit_mode.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:meta/meta.dart';

part 'operations_event.dart';
part 'operations_state.dart';

class OperationsBloc extends Bloc<OperationsEvent, OperationsState> {
  final OperationsServices _operationsServices;
  OperationsBloc(
    this._operationsServices,
  ) : super(OperationsInitial()) {
    on<OperationsEvent>((event, emit) {
      emit(OperationsLoading());
    });
    on<AddNewVisit>(
      (event, emit) async {
        var result = await _operationsServices.addNewVisit(event.visitModel);
        if (result == null) {
          emit(OperationsError(errorMessage: 'خطأ'));
        } else {
          emit(OperationsSuccess(result: result));
        }
      },
    );
    on<AddNewCall>(
      (event, emit) async {
        var result = await _operationsServices.addNewCall(event.callModel);
        if (result == null) {
          emit(OperationsError(errorMessage: 'خطأ'));
        } else {
          emit(OperationsSuccess(result: result));
        }
      },
    );
    on<GetAllOperationsForCustomer>(
      (event, emit) async {
        var result = await _operationsServices.getAllOperationsForCustomer(
            {"customer_id": event.customerID, "page_size": 30});

        if (result == null) {
          emit(OperationsError(errorMessage: 'خطأ'));
        } else {
          emit(OperationsSuccess(result: result));
        }
      },
    );

    on<GetAllOperationsForDate>(
      (event, emit) async {
        final Map<String, dynamic> request = {
          "date1": event.date1,
          "date2": event.date2,
          "page": event.page,
        };
        if (event.bill != null) {
          request["bill"] = event.bill;
        }
        if (event.paid_money != null) {
          request["paid_money"] = event.paid_money;
        }
        if (event.reception != null) {
          request["reception"] = event.reception;
        }
        if (event.type != null) {
          request["type"] = event.type;
        }

        var result = await _operationsServices.getAllOperationsForDate(request);

        if (result == null) {
          emit(OperationsError(errorMessage: 'خطأ'));
        } else {
          emit(OperationsSuccess(
            result: result,
            totalCount: result.totalCount,
          ));
        }
      },
    );

    on<EditCall>(
      (event, emit) async {
        var result = await _operationsServices.editCall(
            id: event.id, callModel: event.callModel);

        if (result == null) {
          emit(OperationsError(errorMessage: 'خطأ'));
        } else {
          emit(OperationsSuccess(result: result));
        }
      },
    );
    on<EditVisit>(
      (event, emit) async {
        var result = await _operationsServices.editVisit(
            id: event.id, visitModel: event.visitModel);

        if (result == null) {
          emit(OperationsError(errorMessage: 'خطأ'));
        } else {
          emit(OperationsSuccess(result: result));
        }
      },
    );

    on<ExportExcelOperations>(
      (event, emit) async {
        // Call the service function
        var result = await _operationsServices.exportExcelOperations(
          queryParamss: {
            'from_date': event.fromDate,
            'to_date': event.toDate,
            'type': event.type
          },
        );

        // Use .fold to handle either success (left) or failure (right)
        result.fold(
          (successBytes) {
            // This block is executed if result is Left (Uint8List)
            emit(OperationsSuccess(result: successBytes));
          },
          (failure) {
            // This block is executed if result is Right (a Failure)
            emit(OperationsError(errorMessage: 'Error'));
          },
        );
      },
    );
  }
}
