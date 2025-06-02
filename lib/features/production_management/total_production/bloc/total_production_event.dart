// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'total_production_bloc.dart';

@immutable
sealed class TotalProductionEvent {}

class GetTotalProductionPagainted extends TotalProductionEvent {
  final int page;
  final String department;
  final String worker;
  final String date1;
  final String date2;

  GetTotalProductionPagainted({
    required this.page,
    required this.department,
    required this.worker,
    required this.date1,
    required this.date2,
  });
}

class ExportExcelTasks extends TotalProductionEvent {
  final String department;

  ExportExcelTasks({required this.department});
}
