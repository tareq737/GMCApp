part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class Notify extends NotificationEvent {
  final String? username;
  final String? group;
  final String message;

  Notify({this.username, this.group, required this.message});
}
