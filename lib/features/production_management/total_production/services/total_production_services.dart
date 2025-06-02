import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/production_management/total_production/models/total_production_model.dart';

class TotalProductionServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  TotalProductionServices(
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

  Future<List<TotalProductionModel>?> getAllOperations({
    required int page,
    required String? department,
    required String? worker,
    required String? date1,
    required String? date2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        bool isNotNullOrEmpty(String? value) =>
            value != null && value.trim().isNotEmpty;

        // Build query parameters
        final queryParams = <String, dynamic>{
          'page_size': 15,
          'page': page,
          if (isNotNullOrEmpty(department)) 'department': department,
          if (isNotNullOrEmpty(worker)) 'worker': worker,
          if (isNotNullOrEmpty(date1)) 'date1': date1,
          if (isNotNullOrEmpty(date2)) 'date2': date2,
        };
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'additionalops/combined',
          queryParams: queryParams,
        );

        return List.generate(response.length, (index) {
          return TotalProductionModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelTasks(
      {required String department}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            // Define the query parameters
            final Map<String, dynamic> queryParams = {
              'department': department,
            };

            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'ExportExcelTasks',
              queryParameters: queryParams,
            );
            return left(response);
          } catch (e) {
            print('Error exporting Excel tasks: $e');
            return right(
                Failure(message: 'Failed to export Excel: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportExcelTasks service: $e');
      return right(Failure(
          message: 'Unexpected error during Excel export: ${e.toString()}'));
    }
  }
}
