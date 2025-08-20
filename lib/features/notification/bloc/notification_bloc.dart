import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/notification/service/notification_service.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;
  NotificationBloc(this._notificationService) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      emit(NotificationInitial());
    });
    on<Notify>(
      (event, emit) async {
        emit(LoadingNotification());
        var result = await _notificationService.notify(
            message: event.message,
            group: event.group,
            username: event.username);
        if (result == null) {
          emit(ErrorNotification(errorMessage: 'Error'));
        } else {
          emit(SuccessNotification(result: result));
        }
      },
    );
  }
}
