import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/error/exceptions.dart';
import 'package:gmcappclean/features/auth/data/models/user_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String username,
    required String password,
    required String fcm_token,
  });
  Future<UserModel?> refreshCurrentUser({UserModel? userModel});
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImp(this.apiClient);

  @override
  Future<UserModel> signIn({
    required String username,
    required String password,
    required String fcm_token,
  }) async {
    try {
      var user = UserModel.fromMap(await apiClient.singIn(
          username: username, password: password, fcm_token: fcm_token));
      print(' The User is ${user.firstName}, user group is ${user.groups},');
      print('Access ${JwtDecoder.getExpirationDate(user.accessToken)}');
      print('refresh ${JwtDecoder.getExpirationDate(user.refreshToken)}');
      return user;
    } catch (e) {
      print('exception when parsing Usermodel from map');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> refreshCurrentUser({UserModel? userModel}) async {
    try {
      if (userModel is UserModel) {
        var data = await apiClient.refreshToken(userModel);

        String newAccess = data['access'];

        return UserModel(
          accessToken: newAccess,
          refreshToken: userModel.refreshToken,
          lastName: userModel.lastName,
          firstName: userModel.firstName,
          groups: userModel.groups,
        );
      } else {
        return null;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
