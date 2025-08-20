import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/maintenance/Models/machine_maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Models/maintenance_model.dart';
import 'package:gmcappclean/features/maintenance/Services/maintenance_services.dart';
import 'package:meta/meta.dart';

part 'maintenance_event.dart';
part 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final MaintenanceServices _maintenanceServices;
  MaintenanceBloc(this._maintenanceServices) : super(MaintenanceInitial()) {
    on<MaintenanceEvent>((event, emit) {
      emit(MaintenanceInitial());
    });
    on<GetAllMaintenance>(
      (event, emit) async {
        emit(MaintenanceLoading());
        var result = await _maintenanceServices.getAllMaintenance(
          page: event.page,
          status: event.status,
          department: event.department,
        );
        if (result == null) {
          emit(MaintenanceError(errorMessage: 'Error'));
        } else {
          emit(MaintenanceSuccess(result: result));
        }
      },
    );
    on<GetOneMaintenance>(
      (event, emit) async {
        emit(MaintenanceLoading());
        var result = await _maintenanceServices.getOneMaintenanceByID(event.id);
        if (result == null) {
          emit(MaintenanceError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(MaintenanceSuccess(result: result));
        }
      },
    );
    on<AddMaintenance>(
      (event, emit) async {
        emit(MaintenanceLoading());
        var result =
            await _maintenanceServices.addMaintenance(event.maintenanceModel);
        if (result == null) {
          emit(MaintenanceError(errorMessage: 'Error'));
        } else {
          emit(MaintenanceSuccess(result: result));
        }
      },
    );
    on<UpdateMaintenance>(
      (event, emit) async {
        emit(MaintenanceLoading());
        var result = await _maintenanceServices.updateMaintenance(
            event.id, event.maintenanceModel);
        if (result == null) {
          emit(MaintenanceError(errorMessage: 'Error'));
        } else {
          emit(MaintenanceSuccess(result: result));
        }
      },
    );
    on<GetAllMachines>((event, emit) async {
      emit(MaintenanceLoading());
      try {
        final machines = await _maintenanceServices.getAllMachines();
        emit(MachinesLoaded(machines));
      } catch (e) {
        emit(MaintenanceError(errorMessage: e.toString()));
      }
    });
    on<GetSearchMachines>((event, emit) async {
      emit(MaintenanceLoading());
      try {
        final machines = await _maintenanceServices.searchMachine(
          search: event.search,
          page: event.page,
        );
        emit(MaintenanceSuccess(result: machines));
      } catch (e) {
        emit(MaintenanceError(errorMessage: e.toString()));
      }
    });
    on<GetMachineLog>((event, emit) async {
      emit(MaintenanceLoading());
      try {
        final log = await _maintenanceServices.machineLog(
          page: event.page,
          id: event.machineId,
        );
        emit(MaintenanceSuccess(result: log));
      } catch (e) {
        emit(MaintenanceError(errorMessage: e.toString()));
      }
    });
    on<GetMaintenanceFilter>(
      (event, emit) async {
        emit(MaintenanceLoading());
        var result = await _maintenanceServices.getMaintenanceFilter(
          page: event.page,
          status: event.status,
          date_1: event.date_1,
          date_2: event.date_2,
        );
        if (result == null) {
          emit(MaintenanceError(errorMessage: 'Error'));
        } else {
          emit(MaintenanceSuccess(result: result));
        }
      },
    );
  }
}
