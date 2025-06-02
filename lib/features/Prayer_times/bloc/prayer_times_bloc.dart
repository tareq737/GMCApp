import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/Prayer_times/models/prayer_times_model.dart';
import 'package:gmcappclean/features/Prayer_times/services/prayer_times_service.dart';
import 'package:meta/meta.dart';

part 'prayer_times_event.dart';
part 'prayer_times_state.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  final PrayerTimesService _prayerTimesService;
  PrayerTimesBloc({required PrayerTimesService prayerTimesService})
      : _prayerTimesService = prayerTimesService,
        super(PrayerTimesInitial()) {
    on<PrayerTimesEvent>((event, emit) {
      emit(PrayerTimesLoading());
    });

    on<GetPrayerTimes>((event, emit) async {
      PrayerTimesModel? prayerModel =
          await _prayerTimesService.getPrayerTimes(event.date);
      if (prayerModel is PrayerTimesModel) {
        emit(PrayerTimesGetSuccess(opResult: prayerModel));
      } else {
        emit(PrayerTimesGetFailure(
            errorMessage: 'خطأ في الحصول على مواقيت الصلاة'));
      }
    });
  }
}
