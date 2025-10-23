// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BriefEmployeeModel {
  int id;
  String? full_name;
  bool? is_working;
  String? department_name;
  String? job_title;
  String? employment_date;
  String? quitting_date;
  String? gender;
  BriefEmployeeModel({
    required this.id,
    this.full_name,
    this.is_working,
    this.department_name,
    this.job_title,
    this.employment_date,
    this.quitting_date,
    this.gender,
  });

  BriefEmployeeModel copyWith({
    int? id,
    String? full_name,
    bool? is_working,
    String? department_name,
    String? job_title,
    String? employment_date,
    String? quitting_date,
    String? gender,
  }) {
    return BriefEmployeeModel(
      id: id ?? this.id,
      full_name: full_name ?? this.full_name,
      is_working: is_working ?? this.is_working,
      department_name: department_name ?? this.department_name,
      job_title: job_title ?? this.job_title,
      employment_date: employment_date ?? this.employment_date,
      quitting_date: quitting_date ?? this.quitting_date,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'full_name': full_name,
      'is_working': is_working,
      'department_name': department_name,
      'job_title': job_title,
      'employment_date': employment_date,
      'quitting_date': quitting_date,
      'gender': gender,
    };
  }

  factory BriefEmployeeModel.fromMap(Map<String, dynamic> map) {
    return BriefEmployeeModel(
      id: map['id'] as int,
      full_name: map['full_name'] != null ? map['full_name'] as String : null,
      is_working: map['is_working'] != null ? map['is_working'] as bool : null,
      department_name: map['department_name'] != null
          ? map['department_name'] as String
          : null,
      job_title: map['job_title'] != null ? map['job_title'] as String : null,
      employment_date: map['employment_date'] != null
          ? map['employment_date'] as String
          : null,
      quitting_date:
          map['quitting_date'] != null ? map['quitting_date'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefEmployeeModel.fromJson(String source) =>
      BriefEmployeeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefEmployeeModel(id: $id, full_name: $full_name, is_working: $is_working, department_name: $department_name, job_title: $job_title, employment_date: $employment_date, quitting_date: $quitting_date, gender: $gender)';
  }

  @override
  bool operator ==(covariant BriefEmployeeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.full_name == full_name &&
        other.is_working == is_working &&
        other.department_name == department_name &&
        other.job_title == job_title &&
        other.employment_date == employment_date &&
        other.quitting_date == quitting_date &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        full_name.hashCode ^
        is_working.hashCode ^
        department_name.hashCode ^
        job_title.hashCode ^
        employment_date.hashCode ^
        quitting_date.hashCode ^
        gender.hashCode;
  }
}
