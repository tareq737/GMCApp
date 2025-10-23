// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WorkleavesModel {
  int id;
  int? employee;
  String? employee_full_name;
  String? kind;
  String? start_date;
  String? start_time;
  String? duration;
  String? duration_unit;
  bool? dep_head_approve;
  bool? hr_approve;
  bool? manager_approve;
  int? progress;
  String? current_progress_step;
  String? dep_head_notes;
  String? hr_notes;
  String? manager_notes;
  String? medical_report;
  String? reason;
  WorkleavesModel({
    required this.id,
    this.employee,
    this.employee_full_name,
    this.kind,
    this.start_date,
    this.start_time,
    this.duration,
    this.duration_unit,
    this.dep_head_approve,
    this.hr_approve,
    this.manager_approve,
    this.progress,
    this.current_progress_step,
    this.dep_head_notes,
    this.hr_notes,
    this.manager_notes,
    this.medical_report,
    this.reason,
  });

  WorkleavesModel copyWith({
    int? id,
    int? employee,
    String? employee_full_name,
    String? kind,
    String? start_date,
    String? start_time,
    String? duration,
    String? duration_unit,
    bool? dep_head_approve,
    bool? hr_approve,
    bool? manager_approve,
    int? progress,
    String? current_progress_step,
    String? dep_head_notes,
    String? hr_notes,
    String? manager_notes,
    String? medical_report,
    String? reason,
  }) {
    return WorkleavesModel(
      id: id ?? this.id,
      employee: employee ?? this.employee,
      employee_full_name: employee_full_name ?? this.employee_full_name,
      kind: kind ?? this.kind,
      start_date: start_date ?? this.start_date,
      start_time: start_time ?? this.start_time,
      duration: duration ?? this.duration,
      duration_unit: duration_unit ?? this.duration_unit,
      dep_head_approve: dep_head_approve ?? this.dep_head_approve,
      hr_approve: hr_approve ?? this.hr_approve,
      manager_approve: manager_approve ?? this.manager_approve,
      progress: progress ?? this.progress,
      current_progress_step:
          current_progress_step ?? this.current_progress_step,
      dep_head_notes: dep_head_notes ?? this.dep_head_notes,
      hr_notes: hr_notes ?? this.hr_notes,
      manager_notes: manager_notes ?? this.manager_notes,
      medical_report: medical_report ?? this.medical_report,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'employee': employee,
      'kind': kind,
      'start_date': start_date,
      'start_time': start_time,
      'duration': duration,
      'duration_unit': duration_unit,
      'reason': reason,
    };
  }

  factory WorkleavesModel.fromMap(Map<String, dynamic> map) {
    return WorkleavesModel(
      id: map['id'] as int,
      employee: map['employee'] != null ? map['employee'] as int : null,
      employee_full_name: map['employee_full_name'] != null
          ? map['employee_full_name'] as String
          : null,
      kind: map['kind'] != null ? map['kind'] as String : null,
      start_date:
          map['start_date'] != null ? map['start_date'] as String : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      duration_unit:
          map['duration_unit'] != null ? map['duration_unit'] as String : null,
      dep_head_approve: map['dep_head_approve'] != null
          ? map['dep_head_approve'] as bool
          : null,
      hr_approve: map['hr_approve'] != null ? map['hr_approve'] as bool : null,
      manager_approve: map['manager_approve'] != null
          ? map['manager_approve'] as bool
          : null,
      progress: map['progress'] != null ? map['progress'] as int : null,
      current_progress_step: map['current_progress_step'] != null
          ? map['current_progress_step'] as String
          : null,
      dep_head_notes: map['dep_head_notes'] != null
          ? map['dep_head_notes'] as String
          : null,
      hr_notes: map['hr_notes'] != null ? map['hr_notes'] as String : null,
      manager_notes:
          map['manager_notes'] != null ? map['manager_notes'] as String : null,
      medical_report: map['medical_report'] != null
          ? map['medical_report'] as String
          : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkleavesModel.fromJson(String source) =>
      WorkleavesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkleavesModel(id: $id, employee: $employee, employee_full_name: $employee_full_name, kind: $kind, start_date: $start_date, start_time: $start_time, duration: $duration, duration_unit: $duration_unit, dep_head_approve: $dep_head_approve, hr_approve: $hr_approve, manager_approve: $manager_approve, progress: $progress, current_progress_step: $current_progress_step, dep_head_notes: $dep_head_notes, hr_notes: $hr_notes, manager_notes: $manager_notes, medical_report: $medical_report, reason: $reason)';
  }

  @override
  bool operator ==(covariant WorkleavesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.employee == employee &&
        other.employee_full_name == employee_full_name &&
        other.kind == kind &&
        other.start_date == start_date &&
        other.start_time == start_time &&
        other.duration == duration &&
        other.duration_unit == duration_unit &&
        other.dep_head_approve == dep_head_approve &&
        other.hr_approve == hr_approve &&
        other.manager_approve == manager_approve &&
        other.progress == progress &&
        other.current_progress_step == current_progress_step &&
        other.dep_head_notes == dep_head_notes &&
        other.hr_notes == hr_notes &&
        other.manager_notes == manager_notes &&
        other.medical_report == medical_report &&
        other.reason == reason;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        employee.hashCode ^
        employee_full_name.hashCode ^
        kind.hashCode ^
        start_date.hashCode ^
        start_time.hashCode ^
        duration.hashCode ^
        duration_unit.hashCode ^
        dep_head_approve.hashCode ^
        hr_approve.hashCode ^
        manager_approve.hashCode ^
        progress.hashCode ^
        current_progress_step.hashCode ^
        dep_head_notes.hashCode ^
        hr_notes.hashCode ^
        manager_notes.hashCode ^
        medical_report.hashCode ^
        reason.hashCode;
  }
}
