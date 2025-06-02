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
