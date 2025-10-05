part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}

//Items Event
class GetAllItems extends InventoryEvent {
  final int page;

  GetAllItems({
    required this.page,
  });
}

class GetOneItem extends InventoryEvent {
  final int id;
  GetOneItem({required this.id});
}

class AddItem extends InventoryEvent {
  final ItemsModel itemsModel;

  AddItem({required this.itemsModel});
}

class UpdateItem extends InventoryEvent {
  final int id;
  final ItemsModel itemsModel;

  UpdateItem({required this.itemsModel, required this.id});
}

class SearchItems extends InventoryEvent {
  final String search;
  final int page;
  SearchItems({
    required this.search,
    required this.page,
  });
}

//Groups Event
class GetAllGroups extends InventoryEvent {
  final int page;

  GetAllGroups({
    required this.page,
  });
}

class GetOneGroup extends InventoryEvent {
  final int id;
  GetOneGroup({required this.id});
}

class AddGroup extends InventoryEvent {
  final GroupsModel groupsModel;

  AddGroup({required this.groupsModel});
}

class UpdateGroup extends InventoryEvent {
  final int id;
  final GroupsModel groupsModel;

  UpdateGroup({required this.groupsModel, required this.id});
}

class SearchGroups extends InventoryEvent {
  final String search;
  final int page;
  SearchGroups({
    required this.search,
    required this.page,
  });
}

//Warehouses Event
class GetAllWarehouses extends InventoryEvent {
  final int page;

  GetAllWarehouses({
    required this.page,
  });
}

class GetOneWarehouse extends InventoryEvent {
  final int id;
  GetOneWarehouse({required this.id});
}

class AddWarehouse extends InventoryEvent {
  final WarehousesModel warehouseModel;

  AddWarehouse({required this.warehouseModel});
}

class UpdateWarehouse extends InventoryEvent {
  final int id;
  final WarehousesModel warehousesModel;

  UpdateWarehouse({required this.warehousesModel, required this.id});
}

class SearchWarehouse extends InventoryEvent {
  final String search;
  final int page;
  final int? transfer_type;
  SearchWarehouse({
    required this.search,
    required this.page,
    this.transfer_type,
  });
}

//Items tree
class GetItemsTree extends InventoryEvent {}

//transfers
class GetListBriefTransfers extends InventoryEvent {
  final int transfer_type;
  final int page;
  GetListBriefTransfers({
    required this.transfer_type,
    required this.page,
  });
}

class GetOneTransfer extends InventoryEvent {
  final int id;
  GetOneTransfer({required this.id});
}

class DeleteOneTransfer extends InventoryEvent {
  final int id;
  DeleteOneTransfer({required this.id});
}

class AddTransfer extends InventoryEvent {
  final TransferModel transferModel;

  AddTransfer({required this.transferModel});
}

class UpdateTransfer extends InventoryEvent {
  final int id;
  final TransferModel transferModel;

  UpdateTransfer({required this.transferModel, required this.id});
}

class GetOneTransferBySerial extends InventoryEvent {
  final int serial;
  final int transfer_type;
  GetOneTransferBySerial({required this.serial, required this.transfer_type});
}

class TransfersNavigation extends InventoryEvent {
  final int serial;
  final int transfer_type;
  final String action;
  TransfersNavigation({
    required this.serial,
    required this.transfer_type,
    required this.action,
  });
}

class GetWarehouseBalance extends InventoryEvent {
  final int page;

  final String date_1;
  final String date_2;
  final int? warehouse_id;
  final int? item_id;
  final int? group_id;
  GetWarehouseBalance(
      {required this.date_1,
      required this.date_2,
      required this.page,
      this.warehouse_id,
      this.item_id,
      this.group_id});
}

class ExportExcelBalance extends InventoryEvent {
  final int? warehouse_id;
  final int? item_id;
  final String date_1;
  final String date_2;
  final int? group_id;
  ExportExcelBalance(
      {required this.date_1,
      required this.date_2,
      this.warehouse_id,
      this.item_id,
      this.group_id});
}

class GetItemActivity extends InventoryEvent {
  final int page;
  final String date_1;
  final String date_2;
  final int? warehouse_id;
  final int? item_id;
  final int? group_id;
  GetItemActivity(
      {required this.date_1,
      required this.date_2,
      required this.page,
      this.warehouse_id,
      this.item_id,
      this.group_id});
}

//Manufacturing
class GetListBriefManufacturing extends InventoryEvent {
  final int page;
  final String? search;
  GetListBriefManufacturing({
    required this.page,
    this.search,
  });
}

class DeleteOneManufacturing extends InventoryEvent {
  final int id;
  DeleteOneManufacturing({required this.id});
}

class GetOneManufacturing extends InventoryEvent {
  final int id;
  GetOneManufacturing({required this.id});
}

class AddManufacturing extends InventoryEvent {
  final Map<String, dynamic> manufacturingData;

  AddManufacturing({required this.manufacturingData});
}

class UpdateManufacturing extends InventoryEvent {
  final int id;
  final Map<String, dynamic> manufacturingData;

  UpdateManufacturing({required this.manufacturingData, required this.id});
}

class GetOneManufacturingBySerial extends InventoryEvent {
  final int id;
  GetOneManufacturingBySerial({required this.id});
}

// Bill
class GetListBills extends InventoryEvent {
  final int page;
  final String bill_type;
  GetListBills({
    required this.page,
    required this.bill_type,
  });
}

class GetListBillsOfCustomer extends InventoryEvent {
  final int page;
  final int customer;
  GetListBillsOfCustomer({
    required this.page,
    required this.customer,
  });
}

class GetOneBillByID extends InventoryEvent {
  final int id;

  GetOneBillByID({required this.id});
}

class DeleteOneBill extends InventoryEvent {
  final int id;
  DeleteOneBill({required this.id});
}

class AddBill extends InventoryEvent {
  final BillModel billModel;

  AddBill({required this.billModel});
}

class UpdateBill extends InventoryEvent {
  final int id;
  final BillModel billModel;

  UpdateBill({required this.billModel, required this.id});
}

class GetOneBillBySerial extends InventoryEvent {
  final int serial;
  final int transfer_type;
  GetOneBillBySerial({required this.serial, required this.transfer_type});
}

class BillNavigation extends InventoryEvent {
  final int serial;
  final int transfer_type;
  final String action;
  BillNavigation({
    required this.serial,
    required this.transfer_type,
    required this.action,
  });
}

//Accounts
class SearchAccounts extends InventoryEvent {
  final String search;
  final int page;

  SearchAccounts({
    required this.search,
    required this.page,
  });
}

class GetOneAccountByID extends InventoryEvent {
  final int id;

  GetOneAccountByID({required this.id});
}

class DeleteOneAccount extends InventoryEvent {
  final int id;
  DeleteOneAccount({required this.id});
}

class AddAccount extends InventoryEvent {
  final AccountsModel accountsModel;

  AddAccount({required this.accountsModel});
}

class UpdateAccount extends InventoryEvent {
  final int id;
  final AccountsModel accountsModel;

  UpdateAccount({required this.accountsModel, required this.id});
}

class GetAccountStatement extends InventoryEvent {
  final int customer;
  final int page;
  final String? date_1;
  final String? date_2;

  GetAccountStatement(
      {required this.customer, required this.page, this.date_1, this.date_2});
}

//Payments
class AddPayment extends InventoryEvent {
  final PaymentModel paymentModel;

  AddPayment({required this.paymentModel});
}

class GetPaymentsForCustomer extends InventoryEvent {
  final int customer;
  final int page;

  GetPaymentsForCustomer({required this.customer, required this.page});
}

class GetPayments extends InventoryEvent {
  final int page;

  GetPayments({required this.page});
}

class UpdatePayment extends InventoryEvent {
  final int id;
  final PaymentModel paymentModel;

  UpdatePayment({required this.paymentModel, required this.id});
}

class GetOnePaymentByID extends InventoryEvent {
  final int id;

  GetOnePaymentByID({required this.id});
}

class DeleteOnePayment extends InventoryEvent {
  final int id;
  DeleteOnePayment({required this.id});
}
