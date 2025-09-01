import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/Cash%20Flow/services/cashflow_service.dart';
import 'package:meta/meta.dart';

part 'cashflow_event.dart';
part 'cashflow_state.dart';

class CashflowBloc extends Bloc<CashflowEvent, CashflowState> {
  final CashflowService _cashflowService;
  CashflowBloc(this._cashflowService) : super(CashflowInitial()) {
    on<CashflowEvent>((event, emit) {});
    on<GetCashflow>(
      (event, emit) async {
        emit(CashflowLoading());
        var result = await _cashflowService.getCashflow(
          page: event.page,
          date_1: event.date_1,
          date_2: event.date_2,
          currency: event.currency,
        );

        if (result == null) {
          emit(CashflowError(errorMessage: 'خطأ'));
        } else {
          emit(CashflowSuccess(result: result));
        }
      },
    );
    on<GetCashflowBalance>(
      (event, emit) async {
        emit(CashflowLoading());
        var result =
            await _cashflowService.getCashflowBalance(currency: event.currency);

        if (result == null) {
          emit(CashflowError(errorMessage: 'خطأ'));
        } else {
          emit(CashflowSuccess(result: result));
        }
      },
    );
    on<CashSync>(
      (event, emit) async {
        emit(CashflowLoading());
        var result = await _cashflowService.cashSync();
        if (result == null) {
          emit(CashflowError(errorMessage: 'خطأ'));
        } else {
          emit(CashflowSuccessSync(result: result));
        }
      },
    );
  }
}
