// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:gmcappclean/features/HR/models/employee_absent_model.dart';

class AttendanceAbsentReportModel {
  String report_date;
  int total_employees;
  int present;
  int absent;
  List<EmployeeAbsentModel> absent_employees;
  AttendanceAbsentReportModel({
    required this.report_date,
    required this.total_employees,
    required this.present,
    required this.absent,
    required this.absent_employees,
  });

  AttendanceAbsentReportModel copyWith({
    String? report_date,
    int? total_employees,
    int? present,
    int? absent,
    List<EmployeeAbsentModel>? absent_employees,
  }) {
    return AttendanceAbsentReportModel(
      report_date: report_date ?? this.report_date,
      total_employees: total_employees ?? this.total_employees,
      present: present ?? this.present,
      absent: absent ?? this.absent,
      absent_employees: absent_employees ?? this.absent_employees,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'report_date': report_date,
      'total_employees': total_employees,
      'present': present,
      'absent': absent,
      'absent_employees': absent_employees.map((x) => x.toMap()).toList(),
    };
  }

  factory AttendanceAbsentReportModel.fromMap(Map<String, dynamic> map) {
    return AttendanceAbsentReportModel(
      report_date: map['report_date'] as String,
      total_employees: map['total_employees'] as int,
      present: map['present'] as int,
      absent: map['absent'] as int,
      absent_employees: List<EmployeeAbsentModel>.from(
        (map['absent_employees'] as List<dynamic>).map<EmployeeAbsentModel>(
          (item) => EmployeeAbsentModel.fromMap(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceAbsentReportModel.fromJson(String source) =>
      AttendanceAbsentReportModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceAbsentReportModel(report_date: $report_date, total_employees: $total_employees, present: $present, absent: $absent, absent_employees: $absent_employees)';
  }

  @override
  bool operator ==(covariant AttendanceAbsentReportModel other) {
    if (identical(this, other)) return true;

    return other.report_date == report_date &&
        other.total_employees == total_employees &&
        other.present == present &&
        other.absent == absent &&
        listEquals(other.absent_employees, absent_employees);
  }

  @override
  int get hashCode {
    return report_date.hashCode ^
        total_employees.hashCode ^
        present.hashCode ^
        absent.hashCode ^
        absent_employees.hashCode;
  }
}
