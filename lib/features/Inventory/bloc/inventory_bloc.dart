import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:gmcappclean/features/Inventory/models/accounts_model.dart';
import 'package:gmcappclean/features/Inventory/models/bill_model.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/main_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/brief_bills_model.dart';
import 'package:gmcappclean/features/Inventory/models/payment_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/Accounts/account_list_page.dart';

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
          emit(InventorySuccessDeleted(result: result));
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
    on<TransfersNavigation>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices.transfersNavigation(
            serial: event.serial,
            transfer_type: event.transfer_type,
            action: event.action,
          );

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
          group_id: event.group_id,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<ExportExcelBalance>(
      (event, emit) async {
        emit(InventoryLoading()); // Add loading state if needed

        var result = await _inventoryServices.exportExcelBalance(
          date_1: event.date_1,
          date_2: event.date_2,
          warehouse_id: event.warehouse_id,
          item_id: event.item_id,
          group_id: event.group_id,
        );

        result.fold(
          (successBytes) {
            emit(InventorySuccess(result: successBytes));
          },
          (failure) {
            // Use the actual failure message
            emit(InventoryError(errorMessage: failure.message));
          },
        );
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
          group_id: event.group_id,
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
        try {
          var result = await _inventoryServices.getOneManufacturingID(event.id);

          if (result == null) {
            emit(
                InventoryError(errorMessage: 'لا يوجد عملية تصنيع بهذا الرقم'));
          } else {
            emit(InventorySuccess(result: result));
          }
        } catch (e) {
          if (e is DioException && e.response?.statusCode == 404) {
            emit(
                InventoryError(errorMessage: 'لا يوجد عملية تصنيع بهذا الرقم'));
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ أثناء جلب البيانات'));
          }
        }
      },
    );
    on<DeleteOneManufacturing>(
      (event, emit) async {
        emit(InventoryLoading());
        var result =
            await _inventoryServices.deleteOneManufacturingID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error delete with ID: ${event.id}'));
        } else {
          emit(InventorySuccessDeleted(result: result));
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
              id: event.id);

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
    //Sales Bill
    on<GetListBills>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getBills(
          page: event.page,
          bill_type: event.bill_type,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetListBillsOfCustomer>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getBillsOfCustomer(
          page: event.page,
          customer: event.customer,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneBillByID>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneBillByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<DeleteOneBill>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.deleteOneBillByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error delete with ID: ${event.id}'));
        } else {
          emit(InventorySuccessDeleted(result: result));
        }
      },
    );
    on<AddBill>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.addBill(event.billModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<UpdateBill>(
      (event, emit) async {
        emit(InventoryLoading());
        var result =
            await _inventoryServices.updateBill(event.id, event.billModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOneBillBySerial>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices.getOneBillBySerialAndID(
              serial: event.serial, transfer_type: event.transfer_type);

          if (result == null) {
            emit(InventoryError(errorMessage: 'لا يوجد فاتورة بهذا الرقم'));
          } else {
            emit(InventorySuccess(result: result));
          }
        } catch (e) {
          if (e is DioException && e.response?.statusCode == 404) {
            emit(InventoryError(errorMessage: 'لا يوجد فاتورة بهذا الرقم'));
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ أثناء جلب البيانات'));
          }
        }
      },
    );
    on<BillNavigation>(
      (event, emit) async {
        emit(InventoryLoading());
        try {
          var result = await _inventoryServices.billNavigation(
            serial: event.serial,
            transfer_type: event.transfer_type,
            action: event.action,
          );

          if (result == null) {
            emit(InventoryError(errorMessage: 'لا يوجد فاتورة بهذا الرقم'));
          } else {
            emit(InventorySuccess(result: result));
          }
        } catch (e) {
          if (e is DioException && e.response?.statusCode == 404) {
            emit(InventoryError(errorMessage: 'لا يوجد فاتورة بهذا الرقم'));
          } else {
            emit(InventoryError(errorMessage: 'حدث خطأ أثناء جلب البيانات'));
          }
        }
      },
    );
    //Accounts
    on<SearchAccounts>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.searchAccounts(
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
    on<GetOneAccountByID>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOneAccountByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<DeleteOneAccount>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.deleteOneAccountByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error delete with ID: ${event.id}'));
        } else {
          emit(InventorySuccessDeleted(result: result));
        }
      },
    );
    on<AddAccount>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.addAccount(event.accountsModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<UpdateAccount>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.updateAccount(
            event.id, event.accountsModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetAccountStatement>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getAccountStatement(
          customer: event.customer,
          page: event.page,
          date1: event.date_1,
          date2: event.date_2,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );

    //Payments
    on<AddPayment>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.addPayment(event.paymentModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetPaymentsForCustomer>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getPaymentsForCustomer(
          page: event.page,
          customer: event.customer,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetPayments>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getPayments(
          page: event.page,
        );
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<GetOnePaymentByID>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.getOnePaymentByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
    on<DeleteOnePayment>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.deleteOnePaymentByID(event.id);
        if (result == null) {
          emit(InventoryError(
              errorMessage: 'Error delete with ID: ${event.id}'));
        } else {
          emit(InventorySuccessDeleted(result: result));
        }
      },
    );
    on<UpdatePayment>(
      (event, emit) async {
        emit(InventoryLoading());
        var result = await _inventoryServices.updatePayment(
            event.id, event.paymentModel);
        if (result == null) {
          emit(InventoryError(errorMessage: 'Error'));
        } else {
          emit(InventorySuccess(result: result));
        }
      },
    );
  }
}
