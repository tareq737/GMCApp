import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/statistics/models/statistics_model.dart';

class StatisticsServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  StatisticsServices(
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

  Future<StatisticsModel?> getStatistics({
    required String date_1,
    required String date_2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
          user: success,
          endPoint: 'statistics',
          queryParams: {
            'date_1': date_1,
            'date_2': date_2,
          },
        );
        return StatisticsModel.fromMap(response!);
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }
}
