import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';

import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';

import 'package:gmcappclean/features/Exchange%20Rate/models/rate_model.dart';
import 'package:gmcappclean/features/Exchange%20Rate/models/char_model.dart';

class RateService {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;
  RateService({
    required ApiClient apiClient,
    required AuthInteractor authInteractor,
  })  : _apiClient = apiClient,
        _authInteractor = authInteractor;

  Future<Either<Failure, UserEntity>> getCredentials() async {
    var user = await _authInteractor.getSession();
    if (user is UserEntity) {
      return right(user);
    } else {
      return left(Failure(message: 'no user'));
    }
  }

  Future<List<RateModel>?> getRatesOnDate({
    required String start,
    required String end,
    required bool details,
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'rates',
          queryParams: {
            'start': start,
            'end': end,
            'details': details,
            'page': page,
            'page_size': 50
          },
        );
        return List.generate(response.length, (index) {
          return RateModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<CharModel>?> getRatesOnlyUSD({
    required String start,
    required String end,
    required bool usd,
    required bool ounce,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
          user: success,
          endPoint: 'rates',
          queryParams: {
            'start': start,
            'end': end,
            'usd': usd,
            'ounce': ounce,
          },
        );
        return List.generate(response.length, (index) {
          return CharModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future getNewRates() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'scrape',
          data: '',
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }
}
