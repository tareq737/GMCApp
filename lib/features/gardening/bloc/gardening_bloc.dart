// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/gardening/models/garden_activities_model.dart';
import 'package:meta/meta.dart';

import 'package:gmcappclean/features/gardening/models/garden_tasks_model.dart';
import 'package:gmcappclean/features/gardening/services/gardening_services.dart';

part 'gardening_event.dart';
part 'gardening_state.dart';

class GardeningBloc extends Bloc<GardeningEvent, GardeningState> {
  final GardeningServices _gardeningServices;
  GardeningBloc(
    this._gardeningServices,
  ) : super(GardeningInitial()) {
    on<GardeningEvent>((event, emit) {
      emit(GardeningInitial());
    });
    on<GetAllGardenTasks>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getAllGardenTasks(
            page: event.page,
            date1: event.date1,
            date2: event.date2,
            activity_details: event.activity_details,
            activity_name: event.activity_name,
            worker: event.worker);
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<GetOneGardenTask>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getOneGardenTask(
          event.id,
        );
        if (result == null) {
          emit(GardeningError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<AddGardenTask>(
      (event, emit) async {
        emit(GardeningLoading());
        var result =
            await _gardeningServices.addGardenTasks(event.gardenTasksModel);
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<UpdateGardenTask>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.updateGardenTasks(
            event.id, event.gardenTasksModel);
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<GetAllGardenActivities>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getAllGardenActivities();
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<GetAllGardenActivitiesDetails>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getAllGardenActivitiesDetails(
          event.name,
        );
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<GetAllGardeningWorkers>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getAllGardeningWorkers(
            department: 'الزراعة');
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GetWorkerSuccess(result: result));
        }
      },
    );
    on<ExportExcelGardenTasks>(
      (event, emit) async {
        var result =
            await _gardeningServices.exportExcelGardenTasks(date: event.date);
        result.fold(
          (successBytes) {
            emit(GardeningExcelSuccess(result: successBytes));
          },
          (failure) {
            emit(GardeningError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<GetMailOfTasks>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getMailOfTasks(date: event.date);
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningMailSuccess(result: result));
        }
      },
    );
    on<GetWorkerHours>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.getWorkerHour(date: event.date);
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningWorkerHoursSuccess(result: result));
        }
      },
    );
    on<AddGardenActivity>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices
            .addGardenActivity(event.gardenActivitiesModel);
        if (result == null) {
          emit(GardeningError(errorMessage: 'Error'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
    on<DeleteOneGardenTask>(
      (event, emit) async {
        emit(GardeningLoading());
        var result = await _gardeningServices.deleteOneGardenTask(
          event.id,
        );
        if (result == null) {
          emit(GardeningError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(GardeningSuccess(result: result));
        }
      },
    );
  }
}
