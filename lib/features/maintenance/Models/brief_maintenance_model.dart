// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BriefMaintenanceModel {
  int id;
  String? department;
  String? problem;
  String? insert_date;
  bool? manager_check;
  bool? archived;
  bool? received;
  String? machine_name;
  BriefMaintenanceModel({
    required this.id,
    this.department,
    this.problem,
    this.insert_date,
    this.manager_check,
    this.archived,
    this.received,
    this.machine_name,
  });

  BriefMaintenanceModel copyWith({
    int? id,
    String? department,
    String? problem,
    String? insert_date,
    bool? manager_check,
    bool? archived,
    bool? received,
    String? machine_name,
  }) {
    return BriefMaintenanceModel(
      id: id ?? this.id,
      department: department ?? this.department,
      problem: problem ?? this.problem,
      insert_date: insert_date ?? this.insert_date,
      manager_check: manager_check ?? this.manager_check,
      archived: archived ?? this.archived,
      received: received ?? this.received,
      machine_name: machine_name ?? this.machine_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'department': department,
      'problem': problem,
      'insert_date': insert_date,
      'manager_check': manager_check,
      'archived': archived,
      'received': received,
      'machine_name': machine_name,
    };
  }

  factory BriefMaintenanceModel.fromMap(Map<String, dynamic> map) {
    return BriefMaintenanceModel(
      id: map['id'] as int,
      department:
          map['department'] != null ? map['department'] as String : null,
      problem: map['problem'] != null ? map['problem'] as String : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      manager_check:
          map['manager_check'] != null ? map['manager_check'] as bool : null,
      archived: map['archived'] != null ? map['archived'] as bool : null,
      received: map['received'] != null ? map['received'] as bool : null,
      machine_name:
          map['machine_name'] != null ? map['machine_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefMaintenanceModel.fromJson(String source) =>
      BriefMaintenanceModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefMaintenanceModel(id: $id, department: $department, problem: $problem, insert_date: $insert_date, manager_check: $manager_check, archived: $archived, received: $received, machine_name: $machine_name)';
  }

  @override
  bool operator ==(covariant BriefMaintenanceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.department == department &&
        other.problem == problem &&
        other.insert_date == insert_date &&
        other.manager_check == manager_check &&
        other.archived == archived &&
        other.received == received &&
        other.machine_name == machine_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        department.hashCode ^
        problem.hashCode ^
        insert_date.hashCode ^
        manager_check.hashCode ^
        archived.hashCode ^
        received.hashCode ^
        machine_name.hashCode;
  }
}
