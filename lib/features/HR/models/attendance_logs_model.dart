// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AttendanceLogsModel {
  int employee_id;
  String? employee_full_name;
  List<Map<String, dynamic>>? attendance_logs;
  int? late;
  bool? absent;
  String? overtime;
  int? overtime_id;
  bool? has_leave;
  int? workleave_id;
  AttendanceLogsModel({
    required this.employee_id,
    this.employee_full_name,
    this.attendance_logs,
    this.late,
    this.absent,
    this.overtime,
    this.overtime_id,
    this.has_leave,
    this.workleave_id,
  });

  AttendanceLogsModel copyWith({
    int? employee_id,
    String? employee_full_name,
    List<Map<String, dynamic>>? attendance_logs,
    int? late,
    bool? absent,
    String? overtime,
    int? overtime_id,
    bool? has_leave,
    int? workleave_id,
  }) {
    return AttendanceLogsModel(
      employee_id: employee_id ?? this.employee_id,
      employee_full_name: employee_full_name ?? this.employee_full_name,
      attendance_logs: attendance_logs ?? this.attendance_logs,
      late: late ?? this.late,
      absent: absent ?? this.absent,
      overtime: overtime ?? this.overtime,
      overtime_id: overtime_id ?? this.overtime_id,
      has_leave: has_leave ?? this.has_leave,
      workleave_id: workleave_id ?? this.workleave_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employee_id': employee_id,
      'employee_full_name': employee_full_name,
      'attendance_logs': attendance_logs,
      'late': late,
      'absent': absent,
      'overtime': overtime,
      'overtime_id': overtime_id,
      'has_leave': has_leave,
      'workleave_id': workleave_id,
    };
  }

  factory AttendanceLogsModel.fromMap(Map<String, dynamic> map) {
    return AttendanceLogsModel(
      employee_id: map['employee_id'] as int,
      employee_full_name: map['employee_full_name'] != null
          ? map['employee_full_name'] as String
          : null,
      attendance_logs: map['attendance_logs'] != null
          ? List<Map<String, dynamic>>.from(map['attendance_logs'] as List)
          : null,
      late: map['late'] != null ? map['late'] as int : null,
      absent: map['absent'] != null ? map['absent'] as bool : null,
      overtime: map['overtime'] != null ? map['overtime'] as String : null,
      overtime_id:
          map['overtime_id'] != null ? map['overtime_id'] as int : null,
      has_leave: map['has_leave'] != null ? map['has_leave'] as bool : null,
      workleave_id:
          map['workleave_id'] != null ? map['workleave_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceLogsModel.fromJson(String source) =>
      AttendanceLogsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceLogsModel(employee_id: $employee_id, employee_full_name: $employee_full_name, attendance_logs: $attendance_logs, late: $late, absent: $absent, overtime: $overtime, overtime_id: $overtime_id, has_leave: $has_leave, workleave_id: $workleave_id)';
  }

  @override
  bool operator ==(covariant AttendanceLogsModel other) {
    if (identical(this, other)) return true;

    return other.employee_id == employee_id &&
        other.employee_full_name == employee_full_name &&
        listEquals(other.attendance_logs, attendance_logs) &&
        other.late == late &&
        other.absent == absent &&
        other.overtime == overtime &&
        other.overtime_id == overtime_id &&
        other.has_leave == has_leave &&
        other.workleave_id == workleave_id;
  }

  @override
  int get hashCode {
    return employee_id.hashCode ^
        employee_full_name.hashCode ^
        attendance_logs.hashCode ^
        late.hashCode ^
        absent.hashCode ^
        overtime.hashCode ^
        overtime_id.hashCode ^
        has_leave.hashCode ^
        workleave_id.hashCode;
  }
}
