import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';

import 'package:meta/meta.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryServices _inventoryServices;

  InventoryBloc(
    this._inventoryServices,
  ) : super(InventoryInitial()) {
    on<InventoryEvent>((event, emit) {
      emit(InventoryInitial());
    });
    on<GetAllItems>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getAllItems(
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneItem>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneItemByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<AddItem>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.addItem(event.itemsModel);
        //The argument type 'AddItem' can't be assigned to the parameter type 'ItemsModel'.
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<UpdateItem>(
      (event, emit) async {
        emit(InventoryLoading());
        var result =
            await _inventoryServices.updateItem(event.id, event.itemsModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<SearchItems>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.searchItem(
          search: event.search,
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetAllGroups>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getAllGroups(
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneGroup>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneGroupByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<AddGroup>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.addGroup(event.groupsModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<UpdateGroup>(
      (event, emit) async {
        emit(InventoryLoading());
        var result =
            await _inventoryServices.updateGroup(event.id, event.groupsModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<SearchGroups>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.searchGroup(
          search: event.search,
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetAllWarehouses>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getAllWarehouses(
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneWarehouse>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneWarehouseByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<AddWarehouse>(
      (event, emit) async {
        emit(InventoryLoading());
        var result =
            await _inventoryServices.addWarehouse(event.warehouseModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<UpdateWarehouse>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.updateWarehouse(
            event.id, event.warehousesModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<SearchWarehouse>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.searchWarehouse(
          search: event.search,
          page: event.page,
          transfer_type: event.transfer_type,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetItemsTree>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getItemsTree();
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );

    //transfers
    on<GetListBriefTransfers>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.transfersBrief(
          transfer_type: event.transfer_type,
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneTransfer>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneTransferID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<AddTransfer>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.addTransfer(event.transferModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<UpdateTransfer>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.updateTransfer(
            event.id, event.transferModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
  }
}
