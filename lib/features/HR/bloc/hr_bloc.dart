import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:meta/meta.dart';

part 'hr_event.dart';
part 'hr_state.dart';

class HrBloc extends Bloc<HrEvent, HrState> {
  final HrServices _hrServices;
  HrBloc(this._hrServices) : super(HrInitial()) {
    on<HrEvent>((event, emit) {
      emit(HrInitial());
    });
    on<GetAttendanceAbsentReport>(
      (event, emit) async {
        emit(LoadingHR());
        var result =
            await _hrServices.getAttendanceAbsentReport(date: event.date);
        if (result == null) {
          emit(ErrorHR(errorMessage: 'Error'));
        } else {
          emit(SuccessHR(result: result));
        }
      },
    );
  }
}
