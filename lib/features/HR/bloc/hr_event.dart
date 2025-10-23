part of 'hr_bloc.dart';

@immutable
sealed class HrEvent {}

class GetOnEemployee extends HrEvent {
  final int id;
  GetOnEemployee({required this.id});
}

class AddEmployee extends HrEvent {
  final EmployeeModel employeeModel;

  AddEmployee({required this.employeeModel});
}

class UpdateEmployee extends HrEvent {
  final int id;
  final EmployeeModel employeeModel;

  UpdateEmployee({required this.employeeModel, required this.id});
}

class SearchEmployee extends HrEvent {
  final int page;
  final String? search;
  final String? department;
  final bool? is_working;
  SearchEmployee({
    required this.page,
    this.search,
    this.department,
    this.is_working,
  });
}

class ExportExcelEmployees extends HrEvent {
  final bool? isWorking;

  ExportExcelEmployees({required this.isWorking});
}

class GetDepartmentEmployees extends HrEvent {}

class GetOnWorkLeave extends HrEvent {
  final int id;
  GetOnWorkLeave({required this.id});
}

class GetWorkLeaves extends HrEvent {
  final int page;
  final int? progress;
  final int? employee_id;
  final String? date1;
  final String? date2;

  GetWorkLeaves(
      {required this.page,
      required this.progress,
      required this.employee_id,
      required this.date1,
      required this.date2});
}

class AddWorkLeave extends HrEvent {
  final WorkleavesModel workleavesModel;
  AddWorkLeave({required this.workleavesModel});
}

class UpdateWorkLeave extends HrEvent {
  final int id;
  final WorkleavesModel workleavesModel;
  UpdateWorkLeave({required this.id, required this.workleavesModel});
}

class AddWorkLeavesReportImage extends HrEvent {
  final int id;
  final File image;

  AddWorkLeavesReportImage({required this.image, required this.id});
}

class GetWorkLeavesReportImage extends HrEvent {
  final int id;
  GetWorkLeavesReportImage({required this.id});
}

class DeleteWorkLeavesReportImage extends HrEvent {
  final int id;
  DeleteWorkLeavesReportImage({required this.id});
}

class WorkLeaveApprove extends HrEvent {
  final int id;
  final String? role;
  final String? approve;
  final String? notes;

  WorkLeaveApprove(
      {required this.id,
      required this.role,
      required this.approve,
      required this.notes});
}

class ExportExcelWorksLeaves extends HrEvent {
  final String date1;
  final String date2;
  final int? employee_id;
  ExportExcelWorksLeaves(
      {required this.date1, required this.date2, this.employee_id});
}

class GetAttendanceAbsentReport extends HrEvent {
  final String date;

  GetAttendanceAbsentReport({required this.date});
}

class AddIDImage extends HrEvent {
  final int id;
  final File image;

  AddIDImage({required this.image, required this.id});
}

class GetIDImage extends HrEvent {
  final int id;
  GetIDImage({required this.id});
}

class DeleteIDImage extends HrEvent {
  final int id;
  DeleteIDImage({required this.id});
}

class AddInsImage extends HrEvent {
  final int id;
  final File image;

  AddInsImage({required this.image, required this.id});
}

class GetInsImage extends HrEvent {
  final int id;
  GetInsImage({required this.id});
}

class DeleteInsImage extends HrEvent {
  final int id;
  DeleteInsImage({required this.id});
}

class AddEmpImage extends HrEvent {
  final int id;
  final File image;

  AddEmpImage({required this.image, required this.id});
}

class GetEmpImage extends HrEvent {
  final int id;
  GetEmpImage({required this.id});
}

class DeleteEmpImage extends HrEvent {
  final int id;
  DeleteEmpImage({required this.id});
}
