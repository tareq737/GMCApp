import 'package:bloc/bloc.dart';
import 'package:gmc/Auth/model/auth_model.dart';
import 'package:gmc/Auth/service/auth_service.dart';
import 'package:gmc/core/model/handling_models.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          var result = await loginService(
            Username: event.Username ?? '',
            Password: event.password ?? '',
          );

          if (result is Single<AuthModel>) {
            emit(AuthSuccess(result: result.data));
          } else if (result is ErrorModel) {
            emit(AuthError(errorMessage: result.message));
          }
        } catch (e) {
          emit(AuthError(errorMessage: 'خطأ في اسم المستخدم أو كلمة المرور'));
        }
      },
    );
  }
}
