// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'gardening_bloc.dart';

@immutable
sealed class GardeningEvent {}

class GetAllGardenTasks extends GardeningEvent {
  final int page;
  final String date1;
  final String date2;
  final String? activity_details;
  final String? worker;
  final String? activity_name;

  GetAllGardenTasks({
    required this.page,
    required this.date1,
    required this.date2,
    this.activity_details,
    this.worker,
    this.activity_name,
  });
}

class GetOneGardenTask extends GardeningEvent {
  final int id;
  GetOneGardenTask({required this.id});
}

class AddGardenTask extends GardeningEvent {
  final GardenTasksModel gardenTasksModel;

  AddGardenTask({required this.gardenTasksModel});
}

class AddGardenTasksDuplicate extends GardeningEvent {
  final Map data;

  AddGardenTasksDuplicate({required this.data});
}

class UpdateGardenTask extends GardeningEvent {
  final int id;
  final GardenTasksModel gardenTasksModel;

  UpdateGardenTask({required this.gardenTasksModel, required this.id});
}

class GetAllGardenActivities extends GardeningEvent {}

class GetAllGardenActivitiesDetails extends GardeningEvent {
  final String name;
  GetAllGardenActivitiesDetails({
    required this.name,
  });
}

class GetAllGardeningWorkers extends GardeningEvent {
  final String department;

  GetAllGardeningWorkers({required this.department});
}

class GetWorkerHours extends GardeningEvent {
  final String date;

  GetWorkerHours({required this.date});
}

class GetMailOfTasks extends GardeningEvent {
  final String date;

  GetMailOfTasks({required this.date});
}

class ExportExcelGardenTasks extends GardeningEvent {
  final String date;

  ExportExcelGardenTasks({required this.date});
}

class AddGardenActivity extends GardeningEvent {
  final GardenActivitiesModel gardenActivitiesModel;

  AddGardenActivity({required this.gardenActivitiesModel});
}

class DeleteOneGardenTask extends GardeningEvent {
  final int id;
  DeleteOneGardenTask({required this.id});
}

class CheckListGardenTasks extends GardeningEvent {
  final List IDs;

  CheckListGardenTasks({required this.IDs});
}
