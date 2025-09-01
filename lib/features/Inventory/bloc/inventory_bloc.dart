import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/main_manufacturing_model.dart';
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
    on<DeleteOneTransfer>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.deleteOneTransferID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error delete with ID: ${event.id}'));
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
    on<GetOneTransferBySerial>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices.getOneTransferBySerialAndID(
              serial: event.serial, transfer_type: event.transfer_type);

          if (result == null) {
            emit(InventoryError(errorMessage: 'لا يوجد مناقلة بهذا الرقم'));
          } else {
            emit(InventorySuccess(result: result));
          }
        } catch (e) {
          if (e is DioException && e.response?.statusCode == 404) {
            emit(InventoryError(errorMessage: 'لا يوجد مناقلة بهذا الرقم'));
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ أثناء جلب البيانات'));
          }
        }
      },
    );
    on<GetWarehouseBalance>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getWarehouseBalance(
          page: event.page,
          date_1: event.date_1,
          date_2: event.date_2,
          warehouse_id: event.warehouse_id,
          item_id: event.item_id,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetItemActivity>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getItemActivity(
          page: event.page,
          date_1: event.date_1,
          date_2: event.date_2,
          warehouse_id: event.warehouse_id,
          item_id: event.item_id,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );

    //Manufacturing
    on<GetListBriefManufacturing>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.manufacturingBrief(
            page: event.page, search: event.search);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneManufacturing>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneManufacturingID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<AddManufacturing>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices
              .addManufacturing(event.manufacturingData);

          if (result == null) {
            emit(InventoryError(errorMessage: 'فشل في إضافة التصنيع'));
          } else {
            emit(InventorySuccessAddManufacturing(result: result));
          }
        } catch (e) {
          if (e is DioException) {
            if (e.response?.statusCode == 400) {
              emit(InventoryError(errorMessage: 'بيانات غير صالحة'));
            } else {
              emit(InventoryError(errorMessage: 'حدث خطأ أثناء إضافة التصنيع'));
            }
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ غير متوقع'));
          }
        }
      },
    );

    on<UpdateManufacturing>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices.updateManufacturing(
              event.id, event.manufacturingData);

          if (result == null) {
            emit(InventoryError(errorMessage: 'فشل في تحديث التصنيع'));
          } else {
            emit(InventorySuccessUpdateManufacturing(result: result));
          }
        } catch (e) {
          if (e is DioException) {
            if (e.response?.statusCode == 404) {
              emit(InventoryError(errorMessage: 'التصنيع غير موجود'));
            } else if (e.response?.statusCode == 400) {
              emit(InventoryError(errorMessage: 'بيانات غير صالحة'));
            } else {
              emit(InventoryError(errorMessage: 'حدث خطأ أثناء تحديث التصنيع'));
            }
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ غير متوقع'));
          }
        }
      },
    );
    on<GetOneManufacturingBySerial>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices.getOneManufacturingBySerial(
              serial: event.serial);

          if (result == null) {
            emit(
                InventoryError(errorMessage: 'لا يوجد عملية تصنيع بهذا الرقم'));
          } else {
            emit(InventorySuccess(result: result));
          }
        } catch (e) {
          if (e is DioException && e.response?.statusCode == 404) {
            emit(InventoryError(errorMessage: 'لا يوجد تصنيع بهذا الرقم'));
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ أثناء جلب البيانات'));
          }
        }
      },
    );
  }
}
