// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FinishedGoodsModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? employee;
  String? problems;
  String? notes;
  String? completion_date;
  bool? finished_goods_check_1;
  bool? finished_goods_check_2;
  bool? finished_goods_check_3;
  bool? finished_goods_check_4;
  FinishedGoodsModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.employee,
    this.problems,
    this.notes,
    this.completion_date,
    this.finished_goods_check_1,
    this.finished_goods_check_2,
    this.finished_goods_check_3,
    this.finished_goods_check_4,
  });

  FinishedGoodsModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? employee,
    String? problems,
    String? notes,
    String? completion_date,
    bool? finished_goods_check_1,
    bool? finished_goods_check_2,
    bool? finished_goods_check_3,
    bool? finished_goods_check_4,
  }) {
    return FinishedGoodsModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      employee: employee ?? this.employee,
      problems: problems ?? this.problems,
      notes: notes ?? this.notes,
      completion_date: completion_date ?? this.completion_date,
      finished_goods_check_1:
          finished_goods_check_1 ?? this.finished_goods_check_1,
      finished_goods_check_2:
          finished_goods_check_2 ?? this.finished_goods_check_2,
      finished_goods_check_3:
          finished_goods_check_3 ?? this.finished_goods_check_3,
      finished_goods_check_4:
          finished_goods_check_4 ?? this.finished_goods_check_4,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'finished_goods': {
        'id': id,
        'start_time': start_time,
        'finish_time': finish_time,
        'employee': employee,
        'problems': problems,
        'notes': notes,
        'completion_date': completion_date,
        'finished_goods_check_1': finished_goods_check_1,
        'finished_goods_check_2': finished_goods_check_2,
        'finished_goods_check_3': finished_goods_check_3,
        'finished_goods_check_4': finished_goods_check_4,
      }
    };
  }

  factory FinishedGoodsModel.fromMap(Map<String, dynamic> map) {
    return FinishedGoodsModel(
      id: map['id'] != null ? map['id'] as int : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      finish_time:
          map['finish_time'] != null ? map['finish_time'] as String : null,
      employee: map['employee'] != null ? map['employee'] as String : null,
      problems: map['problems'] != null ? map['problems'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      completion_date: map['completion_date'] != null
          ? map['completion_date'] as String
          : null,
      finished_goods_check_1: map['finished_goods_check_1'] != null
          ? map['finished_goods_check_1'] as bool
          : null,
      finished_goods_check_2: map['finished_goods_check_2'] != null
          ? map['finished_goods_check_2'] as bool
          : null,
      finished_goods_check_3: map['finished_goods_check_3'] != null
          ? map['finished_goods_check_3'] as bool
          : null,
      finished_goods_check_4: map['finished_goods_check_4'] != null
          ? map['finished_goods_check_4'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinishedGoodsModel.fromJson(String source) =>
      FinishedGoodsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FinishedGoodsModel(id: $id, start_time: $start_time, finish_time: $finish_time, employee: $employee, problems: $problems, notes: $notes, completion_date: $completion_date, finished_goods_check_1: $finished_goods_check_1, finished_goods_check_2: $finished_goods_check_2, finished_goods_check_3: $finished_goods_check_3, finished_goods_check_4: $finished_goods_check_4)';
  }

  @override
  bool operator ==(covariant FinishedGoodsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.employee == employee &&
        other.problems == problems &&
        other.notes == notes &&
        other.completion_date == completion_date &&
        other.finished_goods_check_1 == finished_goods_check_1 &&
        other.finished_goods_check_2 == finished_goods_check_2 &&
        other.finished_goods_check_3 == finished_goods_check_3 &&
        other.finished_goods_check_4 == finished_goods_check_4;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        start_time.hashCode ^
        finish_time.hashCode ^
        employee.hashCode ^
        problems.hashCode ^
        notes.hashCode ^
        completion_date.hashCode ^
        finished_goods_check_1.hashCode ^
        finished_goods_check_2.hashCode ^
        finished_goods_check_3.hashCode ^
        finished_goods_check_4.hashCode;
  }
}
