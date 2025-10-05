import 'dart:convert';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/Inventory/models/account_statement_model.dart';
import 'package:gmcappclean/features/Inventory/models/accounts_model.dart';
import 'package:gmcappclean/features/Inventory/models/balance_model.dart';
import 'package:gmcappclean/features/Inventory/models/bill_model.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_tree_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/brief_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/main_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/movement_model.dart';
import 'package:gmcappclean/features/Inventory/models/brief_bills_model.dart';
import 'package:gmcappclean/features/Inventory/models/payment_model.dart';
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
            'page_size': 10,
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
            'page_size': 40,
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
          queryParams: {
            'page': page,
            'transfer_type': transfer_type,
            'page_size': 20,
          },
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

  Future<bool?> deleteOneTransferID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'transfers', id: id);
        return response;
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
          queryParams: {"transfer_type": transfer_type, "serial": serial},
        );

        if (response == null) {
          return null;
        }

        return TransferModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<TransferModel?> transfersNavigation(
      {required int serial,
      required int transfer_type,
      required String action}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
            user: success,
            endPoint: 'transfers_navigation',
            queryParams: {
              "transfer_type": transfer_type,
              "serial": serial,
              'action': action
            });

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
    int? group_id,
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
        if (group_id != null) {
          queryParams['group_id'] = group_id;
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

  Future<Either<Uint8List, Failure>> exportExcelBalance({
    required String date_1,
    required String date_2,
    int? warehouse_id,
    int? item_id,
    int? group_id,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            // Build query parameters conditionally
            final queryParameters = {
              'date_1': date_1,
              'date_2': date_2,
            };

            // Add warehouse_id only if provided
            if (warehouse_id != null) {
              queryParameters['warehouse_id'] = warehouse_id.toString();
            }

            // Add item_id only if provided
            if (item_id != null) {
              queryParameters['item_id'] = item_id.toString();
            }
            if (group_id != null) {
              queryParameters['group_id'] = group_id.toString();
            }
            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'balance_excel',
              queryParameters: queryParameters,
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

  Future<List<MovementModel>?> getItemActivity({
    required int page,
    required String date_1,
    required String date_2,
    int? warehouse_id,
    int? item_id,
    int? group_id,
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
        if (item_id != null) {
          queryParams['item_id'] = item_id;
        }
        if (group_id != null) {
          queryParams['group_id'] = group_id;
        }

        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'item_activity',
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

  //Manufacturing
  Future<List<BriefManufacturingModel>?> manufacturingBrief(
      {required int page, String? search}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'brief_manufacturing',
          queryParams: {
            'page': page,
            'search': search,
            'page_size': 20,
          },
        );
        return List.generate(response.length, (index) {
          return BriefManufacturingModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<MainManufacturingModel?> getOneManufacturingID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'manufacturing-operations',
          id: id,
        );
        return MainManufacturingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOneManufacturingID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'manufacturing-operations', id: id);
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<MainManufacturingModel?> addManufacturing(
      Map<String, dynamic> data) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'manufacturing-operations',
          data: jsonEncode(data),
        );
        return MainManufacturingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<MainManufacturingModel?> updateManufacturing(
      int id, Map<String, dynamic> data) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'manufacturing-operations',
          data: jsonEncode(data),
          id: id,
        );
        return MainManufacturingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<MainManufacturingModel?> getOneManufacturingBySerial(
      {required int id}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'manufacturing', id: id);
        return MainManufacturingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  // Bills

  Future<List<BriefBillsModel>?> getBills(
      {required int page, required String bill_type}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'bills',
          queryParams: {
            'bill_type': bill_type,
            'page': page,
            'page_size': 20,
          },
        );
        return List.generate(response.length, (index) {
          return BriefBillsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<BriefBillsModel>?> getBillsOfCustomer(
      {required int page, required int customer}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'bills',
          queryParams: {'page': page, 'page_size': 20, 'customer': customer},
        );
        return List.generate(response.length, (index) {
          return BriefBillsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<BillModel?> getOneBillByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'bills',
          id: id,
        );
        return BillModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOneBillByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'bills',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<BillModel?> addBill(BillModel billModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'bills',
          data: billModel.toJson(),
        );
        return BillModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<BillModel?> updateBill(
    int id,
    BillModel billModel,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'bills',
          data: billModel.toJson(),
          id: id,
        );
        return BillModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<BillModel?> getOneBillBySerialAndID(
      {required int serial, required int transfer_type}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
            user: success,
            endPoint: 'bills_by_serial',
            queryParams: {
              "transfer_type": transfer_type,
              "serial": serial,
            });

        if (response == null) {
          return null;
        }

        return BillModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<BillModel?> billNavigation(
      {required int serial,
      required int transfer_type,
      required String action}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
            user: success,
            endPoint: 'bills_navigation',
            queryParams: {
              "transfer_type": transfer_type,
              "serial": serial,
              'action': action
            });

        if (response == null) {
          return null;
        }

        return BillModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  //Accounts
  Future<List<AccountsModel>?> searchAccounts(
      {required String search, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'accounts',
          queryParams: {
            'search': search,
            'page': page,
            'page_size': 40,
            'is_customer': true,
          },
        );
        return List.generate(response.length, (index) {
          return AccountsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<AccountsModel?> getOneAccountByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'accounts',
          id: id,
        );
        return AccountsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOneAccountByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'accounts',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<AccountsModel?> addAccount(AccountsModel accountModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'accounts',
          data: accountModel.toJson(),
        );
        return AccountsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<AccountsModel?> updateAccount(
      int id, AccountsModel accountModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'accounts',
          data: accountModel.toJson(),
          id: id,
        );
        return AccountsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<AccountStatementModel>?> getAccountStatement({
    required int customer,
    required int page,
    String? date1,
    String? date2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'customer_statement',
          queryParams: {
            'customer': customer,
            'page': page,
            'page_size': 40,
            if (date1 != null) 'date_1': date1,
            if (date2 != null) 'date_2': date2,
          },
        );
        return List.generate(response.length, (index) {
          return AccountStatementModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  //Payments
  Future<PaymentModel?> addPayment(PaymentModel paymentModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'payments',
          data: paymentModel.toJson(),
        );
        return PaymentModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<PaymentModel>?> getPayments({required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'payments',
          queryParams: {
            'page': page,
            'page_size': 40,
          },
        );
        return List.generate(response.length, (index) {
          return PaymentModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<PaymentModel>?> getPaymentsForCustomer(
      {required int customer, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'payments',
          queryParams: {
            'customer': customer,
            'page': page,
            'page_size': 40,
          },
        );
        return List.generate(response.length, (index) {
          return PaymentModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<PaymentModel?> updatePayment(int id, PaymentModel paymentModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'payments',
          data: paymentModel.toJson(),
          id: id,
        );
        return PaymentModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PaymentModel?> getOnePaymentByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'payments',
          id: id,
        );
        return PaymentModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOnePaymentByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'payments',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }
}
