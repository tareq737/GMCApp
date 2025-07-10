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

class GetWarehouseBalance extends InventoryEvent {
  final int page;

  final String date_1;
  final String date_2;
  final int? warehouse_id;
  final int? item_id;
  GetWarehouseBalance({
    required this.date_1,
    required this.date_2,
    required this.page,
    this.warehouse_id,
    this.item_id,
  });
}

class GetItemActivity extends InventoryEvent {
  final int page;

  final String date_1;
  final String date_2;
  final int? warehouse_id;
  final int? item_id;
  GetItemActivity({
    required this.date_1,
    required this.date_2,
    required this.page,
    this.warehouse_id,
    this.item_id,
  });
}
