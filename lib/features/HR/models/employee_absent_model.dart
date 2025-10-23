// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EmployeeAbsentModel {
  int id;
  String? name;
  String? department;
  String? finger_print_code;
  EmployeeAbsentModel({
    required this.id,
    this.name,
    this.department,
    this.finger_print_code,
  });

  EmployeeAbsentModel copyWith({
    int? id,
    String? name,
    String? department,
    String? finger_print_code,
  }) {
    return EmployeeAbsentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      finger_print_code: finger_print_code ?? this.finger_print_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'department': department,
      'finger_print_code': finger_print_code,
    };
  }

  factory EmployeeAbsentModel.fromMap(Map<String, dynamic> map) {
    return EmployeeAbsentModel(
      id: map['id'] as int,
      name: map['name'] != null ? map['name'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      finger_print_code: map['finger_print_code'] != null
          ? map['finger_print_code'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeAbsentModel.fromJson(String source) =>
      EmployeeAbsentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmployeeAbsentModel(id: $id, name: $name, department: $department, finger_print_code: $finger_print_code)';
  }

  @override
  bool operator ==(covariant EmployeeAbsentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.department == department &&
        other.finger_print_code == finger_print_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        department.hashCode ^
        finger_print_code.hashCode;
  }
}
