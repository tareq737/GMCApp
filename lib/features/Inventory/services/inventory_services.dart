import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/Inventory/models/balance_model.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_tree_model.dart';
import 'package:gmcappclean/features/Inventory/models/movement_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_brief_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';
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
          endPoint: 'items',
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
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'items',
          data: itemsModel.toJson(),
          id: id,
        );
        return ItemsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<ItemsModel>?> searchItem(
      {required String search, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'items',
          queryParams: {
            'search': search,
            'page': page,
            'page_size': 20,
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

  Future<GroupsModel?> getOneGroupByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response =
            await _apiClient.getById(user: success, endPoint: 'group', id: id);
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
          endPoint: 'group',
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
          endPoint: 'group',
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
          endPoint: 'group',
          data: groupsModel.toJson(),
          id: id,
        );
        return GroupsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<GroupsModel>?> searchGroup(
      {required String search, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'group',
          queryParams: {'search': search, 'page': page},
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
          endPoint: 'warehouses',
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

  Future<List<WarehousesModel>?> searchWarehouse(
      {required String search, required int page, int? transfer_type}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'warehouses',
          queryParams: {
            'search': search,
            'page': page,
            'transfer_type': transfer_type,
            'page_size': 50,
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

  Future<List<ItemsTreeModel>?> getItemsTree() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
          user: success,
          endPoint: 'items-tree',
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

  //Transfers
  Future<List<TransferBriefModel>?> transfersBrief(
      {required int transfer_type, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'transfers',
          queryParams: {'page': page, 'transfer_type': transfer_type},
        );
        return List.generate(response.length, (index) {
          return TransferBriefModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<TransferModel?> getOneTransferID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'transfers', id: id);
        return TransferModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<TransferModel?> addTransfer(TransferModel transferModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'transfers',
          data: transferModel.toJson(),
        );
        return TransferModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<TransferModel?> updateTransfer(
      int id, TransferModel transferModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'transfers',
          data: transferModel.toJson(),
          id: id,
        );
        return TransferModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<TransferModel?> getOneTransferBySerialAndID(
      {required int serial, required int transfer_type}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
            user: success,
            endPoint: 'transfer_by_serial',
            queryParams: {"transfer_type": transfer_type, "serial": serial});

        if (response == null) {
          return null;
        }

        return TransferModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<BalanceModel>?> getWarehouseBalance({
    required int page,
    int? warehouse_id,
    int? item_id,
    required String date_1,
    required String date_2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final Map<String, dynamic> queryParams = {
          'page': page,
          'date_1': date_1,
          'date_2': date_2,
        };

        if (warehouse_id != null) {
          queryParams['warehouse_id'] = warehouse_id;
        }
        if (item_id != null) {
          queryParams['item_id'] = item_id;
        }

        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'balance',
          queryParams: queryParams,
        );

        return List<BalanceModel>.from(
          response.map((item) => BalanceModel.fromMap(item)),
        );
      });
    } catch (e) {
      print('Exception caught in getWarehouseBalance: $e');
      return null;
    }
  }

  Future<List<MovementModel>?> getItemActivity({
    required int page,
    required String date_1,
    required String date_2,
    int? warehouse_id,
    int? item_id,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Build queryParams without null values
        final Map<String, dynamic> queryParams = {
          'page': page,
          'date_1': date_1,
          'date_2': date_2,
        };

        if (warehouse_id != null) {
          queryParams['warehouse_id'] = warehouse_id;
        }

        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'item_activity/$item_id',
          queryParams: queryParams,
        );

        return List.generate(response.length, (index) {
          return MovementModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }
}
