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
