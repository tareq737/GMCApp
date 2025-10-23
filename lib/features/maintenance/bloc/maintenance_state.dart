part of 'maintenance_bloc.dart';

@immutable
sealed class MaintenanceState {}

final class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceError extends MaintenanceState {
  final String errorMessage;

  MaintenanceError({required this.errorMessage});
}

class MaintenanceSuccess<T> extends MaintenanceState {
  final T result;

  MaintenanceSuccess({required this.result});
}

class MachinesLoaded extends MaintenanceState {
  final MachineMaintenanceModel? machines;
  MachinesLoaded(this.machines);
}

final class ImageSavedSuccess<T> extends MaintenanceState {
  final T result;

  ImageSavedSuccess({required this.result});
}
