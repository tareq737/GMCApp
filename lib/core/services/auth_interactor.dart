import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';

class AuthInteractor {
  final CheckUserSessionStatus _currentUser;
  final AppUserCubit _appUserCubit;

  AuthInteractor(
      {required CheckUserSessionStatus currentUser,
      required AppUserCubit appUserCubit})
      : _currentUser = currentUser,
        _appUserCubit = appUserCubit;
  Future<UserEntity?> getSession() async {
    var result = await _currentUser(
      NoParams(),
    );
    return result.fold(
      (failure) {
        _appUserCubit.updateUser();
        return null;
      },
      (user) {
        return user;
      },
    );
  }
}
