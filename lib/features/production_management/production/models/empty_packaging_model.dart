// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EmptyPackagingModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? employee;
  String? notes;
  String? problems;
  String? completion_date;
  bool? empty_packaging_check_1;
  bool? empty_packaging_check_2;
  bool? empty_packaging_check_3;
  bool? empty_packaging_check_4;
  bool? empty_packaging_check_5;
  EmptyPackagingModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.employee,
    this.notes,
    this.problems,
    this.completion_date,
    this.empty_packaging_check_1,
    this.empty_packaging_check_2,
    this.empty_packaging_check_3,
    this.empty_packaging_check_4,
    this.empty_packaging_check_5,
  });

  EmptyPackagingModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? employee,
    String? notes,
    String? problems,
    String? completion_date,
    bool? empty_packaging_check_1,
    bool? empty_packaging_check_2,
    bool? empty_packaging_check_3,
    bool? empty_packaging_check_4,
    bool? empty_packaging_check_5,
  }) {
    return EmptyPackagingModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      employee: employee ?? this.employee,
      notes: notes ?? this.notes,
      problems: problems ?? this.problems,
      completion_date: completion_date ?? this.completion_date,
      empty_packaging_check_1:
          empty_packaging_check_1 ?? this.empty_packaging_check_1,
      empty_packaging_check_2:
          empty_packaging_check_2 ?? this.empty_packaging_check_2,
      empty_packaging_check_3:
          empty_packaging_check_3 ?? this.empty_packaging_check_3,
      empty_packaging_check_4:
          empty_packaging_check_4 ?? this.empty_packaging_check_4,
      empty_packaging_check_5:
          empty_packaging_check_5 ?? this.empty_packaging_check_5,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'empty_packaging': {
        'id': id,
        'start_time': start_time,
        'finish_time': finish_time,
        'employee': employee,
        'notes': notes,
        'problems': problems,
        'completion_date': completion_date,
        'empty_packaging_check_1': empty_packaging_check_1,
        'empty_packaging_check_2': empty_packaging_check_2,
        'empty_packaging_check_3': empty_packaging_check_3,
        'empty_packaging_check_4': empty_packaging_check_4,
        'empty_packaging_check_5': empty_packaging_check_5,
      }
    };
  }

  factory EmptyPackagingModel.fromMap(Map<String, dynamic> map) {
    return EmptyPackagingModel(
      id: map['id'] != null ? map['id'] as int : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      finish_time:
          map['finish_time'] != null ? map['finish_time'] as String : null,
      employee: map['employee'] != null ? map['employee'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      problems: map['problems'] != null ? map['problems'] as String : null,
      completion_date: map['completion_date'] != null
          ? map['completion_date'] as String
          : null,
      empty_packaging_check_1: map['empty_packaging_check_1'] != null
          ? map['empty_packaging_check_1'] as bool
          : false,
      empty_packaging_check_2: map['empty_packaging_check_2'] != null
          ? map['empty_packaging_check_2'] as bool
          : false,
      empty_packaging_check_3: map['empty_packaging_check_3'] != null
          ? map['empty_packaging_check_3'] as bool
          : false,
      empty_packaging_check_4: map['empty_packaging_check_4'] != null
          ? map['empty_packaging_check_4'] as bool
          : false,
      empty_packaging_check_5: map['empty_packaging_check_5'] != null
          ? map['empty_packaging_check_5'] as bool
          : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmptyPackagingModel.fromJson(String source) =>
      EmptyPackagingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmptyPackagingModel(id: $id, start_time: $start_time, finish_time: $finish_time, employee: $employee, notes: $notes, problems: $problems, completion_date: $completion_date, empty_packaging_check_1: $empty_packaging_check_1, empty_packaging_check_2: $empty_packaging_check_2, empty_packaging_check_3: $empty_packaging_check_3, empty_packaging_check_4: $empty_packaging_check_4, empty_packaging_check_5: $empty_packaging_check_5)';
  }

  @override
  bool operator ==(covariant EmptyPackagingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.employee == employee &&
        other.notes == notes &&
        other.problems == problems &&
        other.completion_date == completion_date &&
        other.empty_packaging_check_1 == empty_packaging_check_1 &&
        other.empty_packaging_check_2 == empty_packaging_check_2 &&
        other.empty_packaging_check_3 == empty_packaging_check_3 &&
        other.empty_packaging_check_4 == empty_packaging_check_4 &&
        other.empty_packaging_check_5 == empty_packaging_check_5;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        start_time.hashCode ^
        finish_time.hashCode ^
        employee.hashCode ^
        notes.hashCode ^
        problems.hashCode ^
        completion_date.hashCode ^
        empty_packaging_check_1.hashCode ^
        empty_packaging_check_2.hashCode ^
        empty_packaging_check_3.hashCode ^
        empty_packaging_check_4.hashCode ^
        empty_packaging_check_5.hashCode;
  }
}
