import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/auth/domain/usecases/on_start_check_login_status.dart';
import 'package:gmcappclean/features/auth/domain/usecases/user_log_out.dart';
import 'package:gmcappclean/features/auth/domain/usecases/user_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignIn _userSignIn;
  final CheckUserSessionStatus _checkUserSessionStatus;
  final AppUserCubit _appUserCubit;
  final UserLogOut _userLogOut;
  final OnStartCheckLoginStatus _onStartCheckLoginStatus;

  AuthBloc({
    required UserSignIn userSignIn,
    required CheckUserSessionStatus checkUserSessionStatus,
    required AppUserCubit appUserCubit,
    required UserLogOut userLogOut,
    required OnStartCheckLoginStatus onStartCheckLoginStatus,
  })  : _userLogOut = userLogOut,
        _userSignIn = userSignIn,
        _checkUserSessionStatus = checkUserSessionStatus,
        _appUserCubit = appUserCubit,
        _onStartCheckLoginStatus = onStartCheckLoginStatus,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      if (event is! AuthIsUserLoggedin) {
        emit(AuthLoading());
      }
    });
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedin>(_onStartCheckLoginStatusNoRefresh);
    on<AuthLogOut>(_onLogOut);
  }

  void _onLogOut(AuthLogOut event, Emitter<AuthState> emit) async {
    final result = await _userLogOut(NoParams());
    result.fold(
      (failure) {
        emit(AuthFailure(message: failure.message));
      },
      (success) {
        emit(AuthInitial());
        _appUserCubit.updateUser();
      },
    );
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final res = await _userSignIn(
      UserLoginParams(
        username: event.username,
        password: event.password,
        fcm_token: event.fcm_token,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    UserEntity user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user: user);
    emit(AuthSuccess(user: user));
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _checkUserSessionStatus(NoParams());
    res.fold(
      (failure) {
        emit(AuthUserIsNotLoggedIn(message: failure.message));
        _appUserCubit.updateUser();
      },
      (success) {
        _appUserCubit.updateUser(user: success);
        _emitAuthSuccess(success, emit);
      },
    );
  }

  void _onStartCheckLoginStatusNoRefresh(
    AuthIsUserLoggedin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _onStartCheckLoginStatus(NoParams());
    res.fold(
      (failure) {
        emit(AuthUserIsNotLoggedIn(message: failure.message));
        _appUserCubit.updateUser();
      },
      (success) {
        _appUserCubit.updateUser(user: success);
        _emitAuthSuccess(success, emit);
      },
    );
  }
}
