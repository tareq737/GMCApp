part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String? Username;
  final String? password;

  LoginEvent({required this.Username, required this.password});
}
