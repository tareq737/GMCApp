// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maintenance_bloc.dart';

@immutable
sealed class MaintenanceEvent {}

class GetAllMaintenance extends MaintenanceEvent {
  final int page;
  final int status;
  final String department;
  GetAllMaintenance({
    required this.page,
    required this.status,
    required this.department,
  });
}

class GetOneMaintenance extends MaintenanceEvent {
  final int id;
  GetOneMaintenance({required this.id});
}

class AddMaintenance extends MaintenanceEvent {
  final MaintenanceModel maintenanceModel;

  AddMaintenance({required this.maintenanceModel});
}

class UpdateMaintenance extends MaintenanceEvent {
  final int id;
  final MaintenanceModel maintenanceModel;

  UpdateMaintenance({required this.maintenanceModel, required this.id});
}

class GetAllMachines extends MaintenanceEvent {}

class GetSearchMachines extends MaintenanceEvent {
  final String search;
  final int page;

  GetSearchMachines({
    required this.search,
    required this.page,
  });
}

class GetMachineLog extends MaintenanceEvent {
  final int machineId;
  final int page;
  GetMachineLog({
    required this.machineId,
    required this.page,
  });
}

class GetMaintenanceFilter extends MaintenanceEvent {
  final int page;
  final String status;
  final String date_1;
  final String date_2;

  GetMaintenanceFilter(
      {required this.page,
      required this.status,
      required this.date_1,
      required this.date_2});
}
