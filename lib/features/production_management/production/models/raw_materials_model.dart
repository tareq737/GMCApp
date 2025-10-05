// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RawMaterialsModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? employee;
  String? notes;
  String? problems;
  String? completion_date;
  String? handover_date;
  bool? raw_material_check_1;
  bool? raw_material_check_2;
  bool? raw_material_check_3;
  bool? raw_material_check_4;
  int? receipt_number;
  double? raw_material_weight;
  RawMaterialsModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.employee,
    this.notes,
    this.problems,
    this.completion_date,
    this.handover_date,
    this.raw_material_check_1,
    this.raw_material_check_2,
    this.raw_material_check_3,
    this.raw_material_check_4,
    this.receipt_number,
    this.raw_material_weight,
  });

  RawMaterialsModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? employee,
    String? notes,
    String? problems,
    String? completion_date,
    String? handover_date,
    bool? raw_material_check_1,
    bool? raw_material_check_2,
    bool? raw_material_check_3,
    bool? raw_material_check_4,
    int? receipt_number,
    double? raw_material_weight,
  }) {
    return RawMaterialsModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      employee: employee ?? this.employee,
      notes: notes ?? this.notes,
      problems: problems ?? this.problems,
      completion_date: completion_date ?? this.completion_date,
      handover_date: handover_date ?? this.handover_date,
      raw_material_check_1: raw_material_check_1 ?? this.raw_material_check_1,
      raw_material_check_2: raw_material_check_2 ?? this.raw_material_check_2,
      raw_material_check_3: raw_material_check_3 ?? this.raw_material_check_3,
      raw_material_check_4: raw_material_check_4 ?? this.raw_material_check_4,
      receipt_number: receipt_number ?? this.receipt_number,
      raw_material_weight: raw_material_weight ?? this.raw_material_weight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'raw_materials': {
        'id': id,
        'start_time': start_time,
        'finish_time': finish_time,
        'employee': employee,
        'notes': notes,
        'problems': problems,
        'completion_date': completion_date,
        'handover_date': handover_date,
        'raw_material_check_1': raw_material_check_1,
        'raw_material_check_2': raw_material_check_2,
        'raw_material_check_3': raw_material_check_3,
        'raw_material_check_4': raw_material_check_4,
        'receipt_number': receipt_number,
        'raw_material_weight': raw_material_weight,
      }
    };
  }

  factory RawMaterialsModel.fromMap(Map<String, dynamic> map) {
    return RawMaterialsModel(
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
      handover_date:
          map['handover_date'] != null ? map['handover_date'] as String : null,
      raw_material_check_1: map['raw_material_check_1'] != null
          ? map['raw_material_check_1'] as bool
          : null,
      raw_material_check_2: map['raw_material_check_2'] != null
          ? map['raw_material_check_2'] as bool
          : null,
      raw_material_check_3: map['raw_material_check_3'] != null
          ? map['raw_material_check_3'] as bool
          : null,
      raw_material_check_4: map['raw_material_check_4'] != null
          ? map['raw_material_check_4'] as bool
          : null,
      receipt_number:
          map['receipt_number'] != null ? map['receipt_number'] as int : null,
      raw_material_weight: map['raw_material_weight'] != null
          ? map['raw_material_weight'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RawMaterialsModel.fromJson(String source) =>
      RawMaterialsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RawMaterialsModel(id: $id, start_time: $start_time, finish_time: $finish_time, employee: $employee, notes: $notes, problems: $problems, completion_date: $completion_date, handover_date: $handover_date, raw_material_check_1: $raw_material_check_1, raw_material_check_2: $raw_material_check_2, raw_material_check_3: $raw_material_check_3, raw_material_check_4: $raw_material_check_4, receipt_number: $receipt_number, raw_material_weight: $raw_material_weight)';
  }

  @override
  bool operator ==(covariant RawMaterialsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.employee == employee &&
        other.notes == notes &&
        other.problems == problems &&
        other.completion_date == completion_date &&
        other.handover_date == handover_date &&
        other.raw_material_check_1 == raw_material_check_1 &&
        other.raw_material_check_2 == raw_material_check_2 &&
        other.raw_material_check_3 == raw_material_check_3 &&
        other.raw_material_check_4 == raw_material_check_4 &&
        other.receipt_number == receipt_number &&
        other.raw_material_weight == raw_material_weight;
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
        handover_date.hashCode ^
        raw_material_check_1.hashCode ^
        raw_material_check_2.hashCode ^
        raw_material_check_3.hashCode ^
        raw_material_check_4.hashCode ^
        receipt_number.hashCode ^
        raw_material_weight.hashCode;
  }
}
