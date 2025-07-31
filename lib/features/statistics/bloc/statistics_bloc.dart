import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/statistics/services/statistics_services.dart';
import 'package:meta/meta.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsServices _statisticsServices;
  StatisticsBloc(this._statisticsServices) : super(StatisticsInitial()) {
    on<StatisticsEvent>((event, emit) {});
    on<GetStatistics>(
      (event, emit) async {
        emit(StatisticsLoading());
        var result = await _statisticsServices.getStatistics(
          date_1: event.date_1,
          date_2: event.date_2,
        );
        if (result == null) {
          emit(StatisticsError(errorMessage: 'خطأ'));
        } else {
          emit(StatisticsSuccess(result: result));
        }
      },
    );
  }
}
