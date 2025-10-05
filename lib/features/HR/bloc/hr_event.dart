part of 'hr_bloc.dart';

@immutable
sealed class HrEvent {}

class GetAttendanceAbsentReport extends HrEvent {
  final String date;

  GetAttendanceAbsentReport({required this.date});
}
