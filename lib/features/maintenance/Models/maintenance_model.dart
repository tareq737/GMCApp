// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MaintenanceModel {
  int id;
  String? applicant;
  String? department;
  String? reason;
  String? problem;
  String? insert_date;
  bool? manager_check;
  String? manager_notes;
  String? manager_check_date;
  String? start_date;
  String? end_date;
  String? worker;
  String? work_done;
  bool? archived;
  bool? received;
  String? received_notes;
  String? received_date;
  String? machine_name;
  String? machine_code;
  MaintenanceModel({
    required this.id,
    this.applicant,
    this.department,
    this.reason,
    this.problem,
    this.insert_date,
    this.manager_check,
    this.manager_notes,
    this.manager_check_date,
    this.start_date,
    this.end_date,
    this.worker,
    this.work_done,
    this.archived,
    this.received,
    this.received_notes,
    this.received_date,
    this.machine_name,
    this.machine_code,
  });

  MaintenanceModel copyWith({
    int? id,
    String? applicant,
    String? department,
    String? reason,
    String? problem,
    String? insert_date,
    bool? manager_check,
    String? manager_notes,
    String? manager_check_date,
    String? start_date,
    String? end_date,
    String? worker,
    String? work_done,
    bool? archived,
    bool? received,
    String? received_notes,
    String? received_date,
    String? machine_name,
    String? machine_code,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      applicant: applicant ?? this.applicant,
      department: department ?? this.department,
      reason: reason ?? this.reason,
      problem: problem ?? this.problem,
      insert_date: insert_date ?? this.insert_date,
      manager_check: manager_check ?? this.manager_check,
      manager_notes: manager_notes ?? this.manager_notes,
      manager_check_date: manager_check_date ?? this.manager_check_date,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      worker: worker ?? this.worker,
      work_done: work_done ?? this.work_done,
      archived: archived ?? this.archived,
      received: received ?? this.received,
      received_notes: received_notes ?? this.received_notes,
      received_date: received_date ?? this.received_date,
      machine_name: machine_name ?? this.machine_name,
      machine_code: machine_code ?? this.machine_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'applicant': applicant,
      'department': department,
      'reason': reason,
      'problem': problem,
      'insert_date': insert_date,
      'manager_check': manager_check,
      'manager_notes': manager_notes,
      'manager_check_date': manager_check_date,
      'start_date': start_date,
      'end_date': end_date,
      'worker': worker,
      'work_done': work_done,
      'archived': archived,
      'received': received,
      'received_notes': received_notes,
      'received_date': received_date,
      'machine_name': machine_name,
      'machine_code': machine_code,
    };
  }

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      id: map['id'] as int,
      applicant: map['applicant'] != null ? map['applicant'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      problem: map['problem'] != null ? map['problem'] as String : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      manager_check:
          map['manager_check'] != null ? map['manager_check'] as bool : null,
      manager_notes:
          map['manager_notes'] != null ? map['manager_notes'] as String : null,
      manager_check_date: map['manager_check_date'] != null
          ? map['manager_check_date'] as String
          : null,
      start_date:
          map['start_date'] != null ? map['start_date'] as String : null,
      end_date: map['end_date'] != null ? map['end_date'] as String : null,
      worker: map['worker'] != null ? map['worker'] as String : null,
      work_done: map['work_done'] != null ? map['work_done'] as String : null,
      archived: map['archived'] != null ? map['archived'] as bool : null,
      received: map['received'] != null ? map['received'] as bool : null,
      received_notes: map['received_notes'] != null
          ? map['received_notes'] as String
          : null,
      received_date:
          map['received_date'] != null ? map['received_date'] as String : null,
      machine_name:
          map['machine_name'] != null ? map['machine_name'] as String : null,
      machine_code:
          map['machine_code'] != null ? map['machine_code'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceModel.fromJson(String source) =>
      MaintenanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MaintenanceModel(id: $id, applicant: $applicant, department: $department, reason: $reason, problem: $problem, insert_date: $insert_date, manager_check: $manager_check, manager_notes: $manager_notes, manager_check_date: $manager_check_date, start_date: $start_date, end_date: $end_date, worker: $worker, work_done: $work_done, archived: $archived, received: $received, received_notes: $received_notes, received_date: $received_date, machine_name: $machine_name, machine_code: $machine_code)';
  }

  @override
  bool operator ==(covariant MaintenanceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.applicant == applicant &&
        other.department == department &&
        other.reason == reason &&
        other.problem == problem &&
        other.insert_date == insert_date &&
        other.manager_check == manager_check &&
        other.manager_notes == manager_notes &&
        other.manager_check_date == manager_check_date &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.worker == worker &&
        other.work_done == work_done &&
        other.archived == archived &&
        other.received == received &&
        other.received_notes == received_notes &&
        other.received_date == received_date &&
        other.machine_name == machine_name &&
        other.machine_code == machine_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        applicant.hashCode ^
        department.hashCode ^
        reason.hashCode ^
        problem.hashCode ^
        insert_date.hashCode ^
        manager_check.hashCode ^
        manager_notes.hashCode ^
        manager_check_date.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        worker.hashCode ^
        work_done.hashCode ^
        archived.hashCode ^
        received.hashCode ^
        received_notes.hashCode ^
        received_date.hashCode ^
        machine_name.hashCode ^
        machine_code.hashCode;
  }
}
