// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OvertimeModel {
  int id;
  String? employee_full_name;
  String? duration;
  String? insert_date;
  String? date;
  String? start_time;
  String? end_time;
  String? reason;
  String? notes;
  String? hr_notes;
  bool? hr_approve;
  String? hr_approve_date;
  int? employee;
  OvertimeModel({
    required this.id,
    this.employee_full_name,
    this.duration,
    this.insert_date,
    this.date,
    this.start_time,
    this.end_time,
    this.reason,
    this.notes,
    this.hr_notes,
    this.hr_approve,
    this.hr_approve_date,
    this.employee,
  });

  OvertimeModel copyWith({
    int? id,
    String? employee_full_name,
    String? duration,
    String? insert_date,
    String? date,
    String? start_time,
    String? end_time,
    String? reason,
    String? notes,
    String? hr_notes,
    bool? hr_approve,
    String? hr_approve_date,
    int? employee,
  }) {
    return OvertimeModel(
      id: id ?? this.id,
      employee_full_name: employee_full_name ?? this.employee_full_name,
      duration: duration ?? this.duration,
      insert_date: insert_date ?? this.insert_date,
      date: date ?? this.date,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      hr_notes: hr_notes ?? this.hr_notes,
      hr_approve: hr_approve ?? this.hr_approve,
      hr_approve_date: hr_approve_date ?? this.hr_approve_date,
      employee: employee ?? this.employee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'reason': reason,
      'notes': notes,
      'hr_notes': hr_notes,
      'hr_approve': hr_approve,
      'hr_approve_date': hr_approve_date,
      'employee': employee,
    };
  }

  factory OvertimeModel.fromMap(Map<String, dynamic> map) {
    return OvertimeModel(
      id: map['id'] as int,
      employee_full_name: map['employee_full_name'] != null
          ? map['employee_full_name'] as String
          : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      end_time: map['end_time'] != null ? map['end_time'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      hr_notes: map['hr_notes'] != null ? map['hr_notes'] as String : null,
      hr_approve: map['hr_approve'] != null ? map['hr_approve'] as bool : null,
      hr_approve_date: map['hr_approve_date'] != null
          ? map['hr_approve_date'] as String
          : null,
      employee: map['employee'] != null ? map['employee'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OvertimeModel.fromJson(String source) =>
      OvertimeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OvertimeModel(id: $id, employee_full_name: $employee_full_name, duration: $duration, insert_date: $insert_date, date: $date, start_time: $start_time, end_time: $end_time, reason: $reason, notes: $notes, hr_notes: $hr_notes, hr_approve: $hr_approve, hr_approve_date: $hr_approve_date, employee: $employee)';
  }

  @override
  bool operator ==(covariant OvertimeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.employee_full_name == employee_full_name &&
        other.duration == duration &&
        other.insert_date == insert_date &&
        other.date == date &&
        other.start_time == start_time &&
        other.end_time == end_time &&
        other.reason == reason &&
        other.notes == notes &&
        other.hr_notes == hr_notes &&
        other.hr_approve == hr_approve &&
        other.hr_approve_date == hr_approve_date &&
        other.employee == employee;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        employee_full_name.hashCode ^
        duration.hashCode ^
        insert_date.hashCode ^
        date.hashCode ^
        start_time.hashCode ^
        end_time.hashCode ^
        reason.hashCode ^
        notes.hashCode ^
        hr_notes.hashCode ^
        hr_approve.hashCode ^
        hr_approve_date.hashCode ^
        employee.hashCode;
  }
}
