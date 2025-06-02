part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}

class ResetPassword extends ResetPasswordEvent {
  final ResetPasswordModel resetPasswordModel;
  final String username;

  ResetPassword({required this.resetPasswordModel, required this.username});
}

class ChangePassword extends ResetPasswordEvent {
  final ChangePasswordModel changePasswordModel;

  ChangePassword({required this.changePasswordModel});
}
