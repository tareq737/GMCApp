import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_tree_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';

class InventoryServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  InventoryServices(
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

  Future<ItemsModel?> getOneItemByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response =
            await _apiClient.getById(user: success, endPoint: 'items', id: id);
        return ItemsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<ItemsModel>?> getAllItems({
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'items/',
          queryParams: {
            'page_size': 20,
            'page': page,
          },
        );

        return List.generate(response.length, (index) {
          return ItemsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<ItemsModel?> addItem(ItemsModel itemsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'items',
          data: itemsModel.toJson(),
        );
        return ItemsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<ItemsModel?> updateItem(int id, ItemsModel itemsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'ItemsModel',
          data: itemsModel.toJson(),
          id: id,
        );
        return ItemsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<GroupsModel?> getOneGroupByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response =
            await _apiClient.getById(user: success, endPoint: 'groups', id: id);
        return GroupsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<GroupsModel>?> getAllGroups({
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'groups/',
          queryParams: {
            'page_size': 20,
            'page': page,
          },
        );

        return List.generate(response.length, (index) {
          return GroupsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<GroupsModel?> addGroup(GroupsModel groupsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'groups',
          data: groupsModel.toJson(),
        );
        return GroupsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<GroupsModel?> updateGroup(int id, GroupsModel groupsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'groups',
          data: groupsModel.toJson(),
          id: id,
        );
        return GroupsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<WarehousesModel?> getOneWarehouseByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'warehouses', id: id);
        return WarehousesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<WarehousesModel>?> getAllWarehouses({
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'warehouses/',
          queryParams: {
            'page_size': 20,
            'page': page,
          },
        );

        return List.generate(response.length, (index) {
          return WarehousesModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<WarehousesModel?> addWarehouse(WarehousesModel warehouseModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'warehouses',
          data: warehouseModel.toJson(),
        );
        return WarehousesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<WarehousesModel?> updateWarehouse(
      int id, WarehousesModel warehousesModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'warehouses',
          data: warehousesModel.toJson(),
          id: id,
        );
        return WarehousesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<ItemsTreeModel>?> getItemsTree() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
          user: success,
          endPoint: 'items-tree/',
        );
        return List.generate(response.length, (index) {
          return ItemsTreeModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }
}
