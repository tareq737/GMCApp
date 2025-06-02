import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/reset_password/models/change_password_model.dart';
import 'package:gmcappclean/features/reset_password/models/reset_password_model.dart';

class ResetPasswordService {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  ResetPasswordService(
      {required ApiClient apiClient, required AuthInteractor authInteractor})
      : _apiClient = apiClient,
        _authInteractor = authInteractor;

  Future<Either<Failure, UserEntity>> getCredentials() async {
    var user = await _authInteractor.getSession();
    if (user is UserEntity) {
      return right(user);
    } else {
      return left(Failure(message: 'no user'));
    }
  }

  Future<ResetPasswordModel?> resetPassword({
    required ResetPasswordModel resetPassword,
    required String username,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'password-reset/$username',
          data: resetPassword.toJson(),
        );
        return ResetPasswordModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<ChangePasswordModel?> changePassword(
      ChangePasswordModel changePassword) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'change-password',
          data: changePassword.toJson(),
        );
        return ChangePasswordModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }
}
