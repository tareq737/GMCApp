import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/maintenance/Models/brief_maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Models/machine_maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Models/machine_model.dart';
import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';

class MaintenanceServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  MaintenanceServices(
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

  Future<MaintenanceModel?> getOneMaintenanceByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'maintenance', id: id);
        return MaintenanceModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<BriefMaintenanceModel>?> getAllMaintenance({
    required int page,
    required int status,
    required String department,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'briefmaintenance',
          queryParams: {
            'page_size': 20,
            'page': page,
            'status': status,
            'department': department,
          },
        );

        return List.generate(response.length, (index) {
          return BriefMaintenanceModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<MaintenanceModel?> addMaintenance(
      MaintenanceModel maintenanceModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'maintenance',
          data: maintenanceModel.toJson(),
        );
        return MaintenanceModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<MaintenanceModel?> updateMaintenance(
      int id, MaintenanceModel maintenanceModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'maintenance',
          data: maintenanceModel.toJson(),
          id: id,
        );
        return MaintenanceModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<MachineMaintenanceModel?> getAllMachines() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
          user: success,
          endPoint: 'machines',
        );
        if (response == null) {
          return null;
        }
        return MachineMaintenanceModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<MachineModel>?> searchMachine(
      {required String search, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'machine',
          queryParams: {
            'search': search,
            'page': page,
          },
        );
        return List.generate(response.length, (index) {
          return MachineModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<BriefMaintenanceModel>?> machineLog(
      {required int id, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'machine_log',
          queryParams: {
            'machine_id': id,
            'page': page,
          },
        );
        return List.generate(response.length, (index) {
          return BriefMaintenanceModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<BriefMaintenanceModel>?> getMaintenanceFilter({
    required int page,
    required String status,
    required String date_1,
    required String date_2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'maintenance_filter',
          queryParams: {
            'page_size': 20,
            'page': page,
            'status': status,
            'date_1': date_1,
            'date_2': date_2,
          },
        );

        return List.generate(response.length, (index) {
          return BriefMaintenanceModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }
}
