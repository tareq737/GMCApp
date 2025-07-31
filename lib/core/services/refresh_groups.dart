import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshGroups {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  RefreshGroups(
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

  Future<Map<String, dynamic>?> refreshUserGroup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEntity = await getCredentials();
      return await userEntity.fold((failure) async {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
          user: success,
          endPoint: 'groups',
        );

        // Check and extract 'groups' from the response
        final List<String>? groups =
            (response?['groups'] as List?)?.map((e) => e.toString()).toList();

        if (groups != null) {
          await prefs.setStringList('groups', groups);
        }

        return response;
      });
    } catch (e) {
      return null;
    }
  }
}
