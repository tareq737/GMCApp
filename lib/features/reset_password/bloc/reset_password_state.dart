part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String errorMessage;

  ResetPasswordError({required this.errorMessage});
}

class ResetPasswordSuccess<T> extends ResetPasswordState {
  final T result;

  ResetPasswordSuccess({required this.result});
}
