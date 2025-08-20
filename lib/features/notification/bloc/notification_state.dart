part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class SuccessNotification<T> extends NotificationState {
  final T result;

  SuccessNotification({required this.result});
}

final class LoadingNotification extends NotificationState {}

final class ErrorNotification extends NotificationState {
  final String errorMessage;

  ErrorNotification({required this.errorMessage});
}
