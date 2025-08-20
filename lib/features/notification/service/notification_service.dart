import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';

class NotificationService {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  NotificationService(
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

  Future<Map?> notify({
    String? username,
    String? group,
    required String message,
  }) async {
    try {
      final userEntity = await getCredentials();

      return await userEntity.fold(
        (failure) => null,
        (success) async {
          // Build endpoint with query parameters
          String endpoint = 'notify';
          Map<String, String> queryParams = {};

          if (username != null && username.isNotEmpty) {
            queryParams['username'] = username;
          } else if (group != null && group.isNotEmpty) {
            queryParams['group'] = group;
          }

          // Append query parameters if any
          if (queryParams.isNotEmpty) {
            final queryString = Uri(queryParameters: queryParams).query;
            endpoint += '?$queryString';
          }

          final response = await _apiClient.add(
            userTokens: success,
            endPoint: endpoint,
            data: jsonEncode({"message": message}),
          );

          return response;
        },
      );
    } catch (e) {
      return null;
    }
  }
}
