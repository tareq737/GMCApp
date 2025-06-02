part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignIn extends AuthEvent {
  final String username;
  final String password;
  final String fcm_token;

  AuthSignIn({
    required this.username,
    required this.password,
    required this.fcm_token,
  });
}

final class AuthLogOut extends AuthEvent {}

final class AuthIsUserLoggedin extends AuthEvent {}
