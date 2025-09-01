import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/Cash%20Flow/models/cashflow_balance_model.dart';
import 'package:gmcappclean/features/Cash%20Flow/models/cashflow_model.dart';

class CashflowService {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  CashflowService(
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

  Future<List<CashflowModel>?> getCashflow({
    required String date_1,
    required String date_2,
    required int page,
    required String currency,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'cashflow',
          queryParams: {
            'date_1': date_1,
            'date_2': date_2,
            'page': page,
            'currency': currency
          },
        );
        return List.generate(response.length, (index) {
          return CashflowModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<CashflowBalanceModel?> getCashflowBalance({
    required String currency,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
            user: success,
            endPoint: 'cashflow/latest-balance',
            queryParams: {'currency': currency});
        if (response == null) {
          return null;
        }

        return CashflowBalanceModel.fromMap(response);
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future cashSync() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'cash_sync',
          data: '',
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }
}
