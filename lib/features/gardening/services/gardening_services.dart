import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/gardening/models/garden_activities_model.dart';
import 'package:gmcappclean/features/gardening/models/garden_tasks_model.dart';
import 'package:gmcappclean/features/gardening/models/worker_hour_model.dart';

class GardeningServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  GardeningServices(
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

  Future<List?> getAllGardenActivities() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneList(
          user: success,
          endPoint: 'garden_activities/names',
        );
        if (response == null) {
          return null;
        }
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<GardenActivitiesModel>?> getAllGardenActivitiesDetails(
    String name,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
            user: success,
            endPoint: 'garden_activities/get_details',
            queryParams: {'name': name});
        return List.generate(response.length, (index) {
          return GardenActivitiesModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      return null;
    }
  }

  Future<GardenTasksModel?> addGardenTasks(
      GardenTasksModel gardenTasksModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'garden_tasks',
          data: gardenTasksModel.toJson(),
        );
        return GardenTasksModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<GardenTasksModel?> updateGardenTasks(
      int id, GardenTasksModel gardenTasksModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'garden_tasks',
          data: gardenTasksModel.toJson(),
          id: id,
        );
        return GardenTasksModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<GardenTasksModel?> getOneGardenTask(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'garden_tasks',
          id: id,
        );
        return GardenTasksModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<GardenTasksModel>?> getAllGardenTasks({
    required int page,
    required String date1,
    required String date2,
    String? activity_details,
    String? worker,
    String? activity_name,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'garden_tasks',
          queryParams: {
            'page_size': 10,
            'page': page,
            'date_1': date1,
            'date_2': date2,
            if (worker != null) 'worker': worker,
            if (activity_name != null) 'activity_name': activity_name,
            if (activity_details != null) 'activity_details': activity_details,
          },
        );
        return List.generate(response.length, (index) {
          return GardenTasksModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List?> getAllGardeningWorkers({
    required String department,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneList(
          user: success,
          endPoint: 'workers',
          queryParams: {
            'department': department,
          },
        );
        return response;
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelGardenTasks(
      {required String date}) async {
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
              'date': date,
            };
            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'garden_tasks_excel',
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

  Future<Map<String, dynamic>?> getMailOfTasks({
    required String date,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
          user: success,
          endPoint: 'garden_tasks_email',
          queryParams: {
            'date': date,
          },
        );
        return response;
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<WorkerHourModel>?> getWorkerHour({required String date}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
            user: success,
            endPoint: 'worker_hours',
            queryParams: {'date': date});
        return List.generate(response.length, (index) {
          return WorkerHourModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      return null;
    }
  }

  Future<GardenActivitiesModel?> addGardenActivity(
      GardenActivitiesModel gardenActivitiesModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'garden_activities',
          data: gardenActivitiesModel.toJson(),
        );
        return GardenActivitiesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOneGardenTask(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'garden_tasks',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }
}
