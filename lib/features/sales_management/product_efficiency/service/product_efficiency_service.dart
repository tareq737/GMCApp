import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/model/product_efficiency_model.dart';

class ProductEfficiencyService {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;
  ProductEfficiencyService(
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

  Future<ProductEfficiencyModel?> getOneProduct(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'product_eff',
          id: id,
        );
        return ProductEfficiencyModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductEfficiencyModel>?> getAllProducts({
    required int page,
    required String search,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'product_eff',
          queryParams: {
            'page_size': 20,
            'page': page,
            'search': search,
          },
        );

        return List.generate(response.length, (index) {
          return ProductEfficiencyModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }
}
