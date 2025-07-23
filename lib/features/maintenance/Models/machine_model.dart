// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MachineModel {
  int id;
  String? name;
  String? department;
  String? machine_code;
  MachineModel({
    required this.id,
    this.name,
    this.department,
    this.machine_code,
  });

  MachineModel copyWith({
    int? id,
    String? name,
    String? department,
    String? machine_code,
  }) {
    return MachineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      machine_code: machine_code ?? this.machine_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'department': department,
      'machine_code': machine_code,
    };
  }

  factory MachineModel.fromMap(Map<String, dynamic> map) {
    return MachineModel(
      id: map['id'] as int,
      name: map['name'] != null ? map['name'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      machine_code:
          map['machine_code'] != null ? map['machine_code'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineModel.fromJson(String source) =>
      MachineModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MachineModel(id: $id, name: $name, department: $department, machine_code: $machine_code)';
  }

  @override
  bool operator ==(covariant MachineModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.department == department &&
        other.machine_code == machine_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        department.hashCode ^
        machine_code.hashCode;
  }
}
