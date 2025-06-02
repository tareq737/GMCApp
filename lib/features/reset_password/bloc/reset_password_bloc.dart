import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/reset_password/models/change_password_model.dart';
import 'package:gmcappclean/features/reset_password/models/reset_password_model.dart';
import 'package:gmcappclean/features/reset_password/services/reset_password_service.dart';
import 'package:meta/meta.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordService _resetPasswordService;
  ResetPasswordBloc(this._resetPasswordService)
      : super(ResetPasswordInitial()) {
    on<ResetPasswordEvent>((event, emit) {
      emit(ResetPasswordInitial());
    });
    on<ResetPassword>(
      (event, emit) async {
        emit(ResetPasswordLoading());
        var result = await _resetPasswordService.resetPassword(
            resetPassword: event.resetPasswordModel, username: event.username);
        if (result == null) {
          emit(ResetPasswordError(errorMessage: 'Error'));
        } else {
          emit(ResetPasswordSuccess(result: result));
        }
      },
    );
    on<ChangePassword>(
      (event, emit) async {
        emit(ResetPasswordLoading());
        var result = await _resetPasswordService
            .changePassword(event.changePasswordModel);
        if (result == null) {
          emit(ResetPasswordError(errorMessage: 'Error'));
        } else {
          emit(ResetPasswordSuccess(result: result));
        }
      },
    );
  }
}
