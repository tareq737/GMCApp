import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/production_management/additional_operations/models/additional_operations_model.dart';

class AdditionalOperationsServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  AdditionalOperationsServices({
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

  Future<List<AdditionalOperationsModel>?> getAllAdditionalOperations({
    required int page,
    String? department,
    required bool done,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Initialize query parameters with default values
        final Map<String, dynamic> queryParams = {
          'page_size': 15,
          'page': page,
          'done': done
        };

        // Add department only if it's not null or empty
        if (department != null && department.isNotEmpty) {
          queryParams['department'] = department;
        }

        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'additionalops',
          queryParams: queryParams,
        );

        return List.generate(response.length, (index) {
          return AdditionalOperationsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<AdditionalOperationsModel?> addAdditionalOperation(
      AdditionalOperationsModel additionalOperationsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'additionalops',
          data: additionalOperationsModel.toJson(),
        );
        return AdditionalOperationsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<AdditionalOperationsModel?> updateAdditionalOperation(
      {required int id,
      required AdditionalOperationsModel additionalOperationsModel}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'additionalops',
          data: additionalOperationsModel.toJson(),
          id: id,
        );
        return AdditionalOperationsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<AdditionalOperationsModel?> getOneAdditionalOperationByID(
      {required int id}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'additionalops', id: id);
        return AdditionalOperationsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }
}
