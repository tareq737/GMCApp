// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ManufacturingModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? employee;
  String? notes;
  String? problems;
  String? completion_date;
  bool? manufacturing_check_1;
  bool? manufacturing_check_2;
  bool? manufacturing_check_3;
  bool? manufacturing_check_4;
  bool? manufacturing_check_5;
  bool? manufacturing_check_6;
  double? batch_weight;
  String? additions;
  ManufacturingModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.employee,
    this.notes,
    this.problems,
    this.completion_date,
    this.manufacturing_check_1,
    this.manufacturing_check_2,
    this.manufacturing_check_3,
    this.manufacturing_check_4,
    this.manufacturing_check_5,
    this.manufacturing_check_6,
    this.batch_weight,
    this.additions,
  });

  ManufacturingModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? employee,
    String? notes,
    String? problems,
    String? completion_date,
    bool? manufacturing_check_1,
    bool? manufacturing_check_2,
    bool? manufacturing_check_3,
    bool? manufacturing_check_4,
    bool? manufacturing_check_5,
    bool? manufacturing_check_6,
    double? batch_weight,
    String? additions,
  }) {
    return ManufacturingModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      employee: employee ?? this.employee,
      notes: notes ?? this.notes,
      problems: problems ?? this.problems,
      completion_date: completion_date ?? this.completion_date,
      manufacturing_check_1:
          manufacturing_check_1 ?? this.manufacturing_check_1,
      manufacturing_check_2:
          manufacturing_check_2 ?? this.manufacturing_check_2,
      manufacturing_check_3:
          manufacturing_check_3 ?? this.manufacturing_check_3,
      manufacturing_check_4:
          manufacturing_check_4 ?? this.manufacturing_check_4,
      manufacturing_check_5:
          manufacturing_check_5 ?? this.manufacturing_check_5,
      manufacturing_check_6:
          manufacturing_check_6 ?? this.manufacturing_check_6,
      batch_weight: batch_weight ?? this.batch_weight,
      additions: additions ?? this.additions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'manufacturing': {
        'id': id,
        'start_time': start_time,
        'finish_time': finish_time,
        'employee': employee,
        'notes': notes,
        'problems': problems,
        'completion_date': completion_date,
        'manufacturing_check_1': manufacturing_check_1,
        'manufacturing_check_2': manufacturing_check_2,
        'manufacturing_check_3': manufacturing_check_3,
        'manufacturing_check_4': manufacturing_check_4,
        'manufacturing_check_5': manufacturing_check_5,
        'manufacturing_check_6': manufacturing_check_6,
        'batch_weight': batch_weight,
        'additions': additions,
      }
    };
  }

  factory ManufacturingModel.fromMap(Map<String, dynamic> map) {
    return ManufacturingModel(
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
      manufacturing_check_1: map['manufacturing_check_1'] != null
          ? map['manufacturing_check_1'] as bool
          : false,
      manufacturing_check_2: map['manufacturing_check_2'] != null
          ? map['manufacturing_check_2'] as bool
          : false,
      manufacturing_check_3: map['manufacturing_check_3'] != null
          ? map['manufacturing_check_3'] as bool
          : false,
      manufacturing_check_4: map['manufacturing_check_4'] != null
          ? map['manufacturing_check_4'] as bool
          : false,
      manufacturing_check_5: map['manufacturing_check_5'] != null
          ? map['manufacturing_check_5'] as bool
          : false,
      manufacturing_check_6: map['manufacturing_check_6'] != null
          ? map['manufacturing_check_6'] as bool
          : false,
      batch_weight:
          map['batch_weight'] != null ? map['batch_weight'] as double : null,
      additions: map['additions'] != null ? map['additions'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ManufacturingModel.fromJson(String source) =>
      ManufacturingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ManufacturingModel(id: $id, start_time: $start_time, finish_time: $finish_time, employee: $employee, notes: $notes, problems: $problems, completion_date: $completion_date, manufacturing_check_1: $manufacturing_check_1, manufacturing_check_2: $manufacturing_check_2, manufacturing_check_3: $manufacturing_check_3, manufacturing_check_4: $manufacturing_check_4, manufacturing_check_5: $manufacturing_check_5, manufacturing_check_6: $manufacturing_check_6, batch_weight: $batch_weight, additions: $additions)';
  }

  @override
  bool operator ==(covariant ManufacturingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.employee == employee &&
        other.notes == notes &&
        other.problems == problems &&
        other.completion_date == completion_date &&
        other.manufacturing_check_1 == manufacturing_check_1 &&
        other.manufacturing_check_2 == manufacturing_check_2 &&
        other.manufacturing_check_3 == manufacturing_check_3 &&
        other.manufacturing_check_4 == manufacturing_check_4 &&
        other.manufacturing_check_5 == manufacturing_check_5 &&
        other.manufacturing_check_6 == manufacturing_check_6 &&
        other.batch_weight == batch_weight &&
        other.additions == additions;
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
        manufacturing_check_1.hashCode ^
        manufacturing_check_2.hashCode ^
        manufacturing_check_3.hashCode ^
        manufacturing_check_4.hashCode ^
        manufacturing_check_5.hashCode ^
        manufacturing_check_6.hashCode ^
        batch_weight.hashCode ^
        additions.hashCode;
  }
}
