import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/Exchange%20Rate/services/rate_service.dart';
import 'package:meta/meta.dart';

part 'exchange_rate_event.dart';
part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  final RateService _ratesServices;
  ExchangeRateBloc(
    this._ratesServices,
  ) : super(ExchangeRateInitial()) {
    on<ExchangeRateEvent>((event, emit) {});
    on<GetAllRatesForDate>(
      (event, emit) async {
        emit(RatesLoading());
        var result = await _ratesServices.getRatesOnDate(
          page: event.page,
          start: event.start,
          end: event.end,
          details: event.details,
        );

        if (result == null) {
          emit(RatesError(errorMessage: 'خطأ'));
        } else {
          emit(RatesSuccess(result: result));
        }
      },
    );
    on<GetAllRatesOnlyUSD>(
      (event, emit) async {
        emit(RatesLoading());
        var result = await _ratesServices.getRatesOnlyUSD(
          start: event.start,
          end: event.end,
          usd: true,
          ounce: true,
        );
        if (result == null) {
          emit(RatesError(errorMessage: 'خطأ'));
        } else {
          emit(RatesSuccess(result: result));
        }
      },
    );
    on<GetNewRates>(
      (event, emit) async {
        emit(NewRatesLoading());
        var result = await _ratesServices.getNewRates();
        if (result == null) {
          emit(RatesError(errorMessage: 'خطأ'));
        } else if (result is Map && result.containsKey('detail')) {
          emit(RatesSuccess<String>(result: result['detail']));
        } else {
          emit(RatesSuccess(result: result));
        }
      },
    );
  }
}
