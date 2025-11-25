// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QualityControlModel {
  int? id;
  bool? qc_raw_check;
  bool? qc_manufacturing_check;
  bool? qc_lab_check;
  bool? qc_empty_check;
  bool? qc_packaging_check;
  bool? qc_finished_check;
  bool? qc_archive_ready;
  String? qc_raw_notes;
  String? qc_manufacturing_notes;
  String? qc_lab_notes;
  String? qc_empty_notes;
  String? qc_packaging_notes;
  String? qc_finished_notes;
  int? raw_mark_1;
  int? raw_mark_2;
  int? raw_mark_3;
  int? raw_mark_4;
  int? raw_mark_5;
  int? raw_mark_6;
  int? manufacturing_mark_1;
  int? manufacturing_mark_2;
  int? manufacturing_mark_3;
  int? manufacturing_mark_4;
  int? manufacturing_mark_5;
  int? manufacturing_mark_6;
  int? lab_mark_1;
  int? lab_mark_2;
  int? lab_mark_3;
  int? lab_mark_4;
  int? lab_mark_5;
  int? lab_mark_6;
  int? empty_packaging_mark_1;
  int? empty_packaging_mark_2;
  int? empty_packaging_mark_3;
  int? empty_packaging_mark_4;
  int? empty_packaging_mark_5;
  int? empty_packaging_mark_6;
  int? packaging_mark_1;
  int? packaging_mark_2;
  int? packaging_mark_3;
  int? packaging_mark_4;
  int? packaging_mark_5;
  int? packaging_mark_6;
  int? finished_goods_mark_1;
  int? finished_goods_mark_2;
  int? finished_goods_mark_3;
  int? finished_goods_mark_4;
  int? finished_goods_mark_5;
  int? finished_goods_mark_6;
  QualityControlModel({
    this.id,
    this.qc_raw_check,
    this.qc_manufacturing_check,
    this.qc_lab_check,
    this.qc_empty_check,
    this.qc_packaging_check,
    this.qc_finished_check,
    this.qc_archive_ready,
    this.qc_raw_notes,
    this.qc_manufacturing_notes,
    this.qc_lab_notes,
    this.qc_empty_notes,
    this.qc_packaging_notes,
    this.qc_finished_notes,
    this.raw_mark_1,
    this.raw_mark_2,
    this.raw_mark_3,
    this.raw_mark_4,
    this.raw_mark_5,
    this.raw_mark_6,
    this.manufacturing_mark_1,
    this.manufacturing_mark_2,
    this.manufacturing_mark_3,
    this.manufacturing_mark_4,
    this.manufacturing_mark_5,
    this.manufacturing_mark_6,
    this.lab_mark_1,
    this.lab_mark_2,
    this.lab_mark_3,
    this.lab_mark_4,
    this.lab_mark_5,
    this.lab_mark_6,
    this.empty_packaging_mark_1,
    this.empty_packaging_mark_2,
    this.empty_packaging_mark_3,
    this.empty_packaging_mark_4,
    this.empty_packaging_mark_5,
    this.empty_packaging_mark_6,
    this.packaging_mark_1,
    this.packaging_mark_2,
    this.packaging_mark_3,
    this.packaging_mark_4,
    this.packaging_mark_5,
    this.packaging_mark_6,
    this.finished_goods_mark_1,
    this.finished_goods_mark_2,
    this.finished_goods_mark_3,
    this.finished_goods_mark_4,
    this.finished_goods_mark_5,
    this.finished_goods_mark_6,
  });

  QualityControlModel copyWith({
    int? id,
    bool? qc_raw_check,
    bool? qc_manufacturing_check,
    bool? qc_lab_check,
    bool? qc_empty_check,
    bool? qc_packaging_check,
    bool? qc_finished_check,
    bool? qc_archive_ready,
    String? qc_raw_notes,
    String? qc_manufacturing_notes,
    String? qc_lab_notes,
    String? qc_empty_notes,
    String? qc_packaging_notes,
    String? qc_finished_notes,
    int? raw_mark_1,
    int? raw_mark_2,
    int? raw_mark_3,
    int? raw_mark_4,
    int? raw_mark_5,
    int? raw_mark_6,
    int? manufacturing_mark_1,
    int? manufacturing_mark_2,
    int? manufacturing_mark_3,
    int? manufacturing_mark_4,
    int? manufacturing_mark_5,
    int? manufacturing_mark_6,
    int? lab_mark_1,
    int? lab_mark_2,
    int? lab_mark_3,
    int? lab_mark_4,
    int? lab_mark_5,
    int? lab_mark_6,
    int? empty_packaging_mark_1,
    int? empty_packaging_mark_2,
    int? empty_packaging_mark_3,
    int? empty_packaging_mark_4,
    int? empty_packaging_mark_5,
    int? empty_packaging_mark_6,
    int? packaging_mark_1,
    int? packaging_mark_2,
    int? packaging_mark_3,
    int? packaging_mark_4,
    int? packaging_mark_5,
    int? packaging_mark_6,
    int? finished_goods_mark_1,
    int? finished_goods_mark_2,
    int? finished_goods_mark_3,
    int? finished_goods_mark_4,
    int? finished_goods_mark_5,
    int? finished_goods_mark_6,
  }) {
    return QualityControlModel(
      id: id ?? this.id,
      qc_raw_check: qc_raw_check ?? this.qc_raw_check,
      qc_manufacturing_check:
          qc_manufacturing_check ?? this.qc_manufacturing_check,
      qc_lab_check: qc_lab_check ?? this.qc_lab_check,
      qc_empty_check: qc_empty_check ?? this.qc_empty_check,
      qc_packaging_check: qc_packaging_check ?? this.qc_packaging_check,
      qc_finished_check: qc_finished_check ?? this.qc_finished_check,
      qc_archive_ready: qc_archive_ready ?? this.qc_archive_ready,
      qc_raw_notes: qc_raw_notes ?? this.qc_raw_notes,
      qc_manufacturing_notes:
          qc_manufacturing_notes ?? this.qc_manufacturing_notes,
      qc_lab_notes: qc_lab_notes ?? this.qc_lab_notes,
      qc_empty_notes: qc_empty_notes ?? this.qc_empty_notes,
      qc_packaging_notes: qc_packaging_notes ?? this.qc_packaging_notes,
      qc_finished_notes: qc_finished_notes ?? this.qc_finished_notes,
      raw_mark_1: raw_mark_1 ?? this.raw_mark_1,
      raw_mark_2: raw_mark_2 ?? this.raw_mark_2,
      raw_mark_3: raw_mark_3 ?? this.raw_mark_3,
      raw_mark_4: raw_mark_4 ?? this.raw_mark_4,
      raw_mark_5: raw_mark_5 ?? this.raw_mark_5,
      raw_mark_6: raw_mark_6 ?? this.raw_mark_6,
      manufacturing_mark_1: manufacturing_mark_1 ?? this.manufacturing_mark_1,
      manufacturing_mark_2: manufacturing_mark_2 ?? this.manufacturing_mark_2,
      manufacturing_mark_3: manufacturing_mark_3 ?? this.manufacturing_mark_3,
      manufacturing_mark_4: manufacturing_mark_4 ?? this.manufacturing_mark_4,
      manufacturing_mark_5: manufacturing_mark_5 ?? this.manufacturing_mark_5,
      manufacturing_mark_6: manufacturing_mark_6 ?? this.manufacturing_mark_6,
      lab_mark_1: lab_mark_1 ?? this.lab_mark_1,
      lab_mark_2: lab_mark_2 ?? this.lab_mark_2,
      lab_mark_3: lab_mark_3 ?? this.lab_mark_3,
      lab_mark_4: lab_mark_4 ?? this.lab_mark_4,
      lab_mark_5: lab_mark_5 ?? this.lab_mark_5,
      lab_mark_6: lab_mark_6 ?? this.lab_mark_6,
      empty_packaging_mark_1:
          empty_packaging_mark_1 ?? this.empty_packaging_mark_1,
      empty_packaging_mark_2:
          empty_packaging_mark_2 ?? this.empty_packaging_mark_2,
      empty_packaging_mark_3:
          empty_packaging_mark_3 ?? this.empty_packaging_mark_3,
      empty_packaging_mark_4:
          empty_packaging_mark_4 ?? this.empty_packaging_mark_4,
      empty_packaging_mark_5:
          empty_packaging_mark_5 ?? this.empty_packaging_mark_5,
      empty_packaging_mark_6:
          empty_packaging_mark_6 ?? this.empty_packaging_mark_6,
      packaging_mark_1: packaging_mark_1 ?? this.packaging_mark_1,
      packaging_mark_2: packaging_mark_2 ?? this.packaging_mark_2,
      packaging_mark_3: packaging_mark_3 ?? this.packaging_mark_3,
      packaging_mark_4: packaging_mark_4 ?? this.packaging_mark_4,
      packaging_mark_5: packaging_mark_5 ?? this.packaging_mark_5,
      packaging_mark_6: packaging_mark_6 ?? this.packaging_mark_6,
      finished_goods_mark_1:
          finished_goods_mark_1 ?? this.finished_goods_mark_1,
      finished_goods_mark_2:
          finished_goods_mark_2 ?? this.finished_goods_mark_2,
      finished_goods_mark_3:
          finished_goods_mark_3 ?? this.finished_goods_mark_3,
      finished_goods_mark_4:
          finished_goods_mark_4 ?? this.finished_goods_mark_4,
      finished_goods_mark_5:
          finished_goods_mark_5 ?? this.finished_goods_mark_5,
      finished_goods_mark_6:
          finished_goods_mark_6 ?? this.finished_goods_mark_6,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quality_control': {
        'id': id,
        'qc_raw_check': qc_raw_check,
        'qc_manufacturing_check': qc_manufacturing_check,
        'qc_lab_check': qc_lab_check,
        'qc_empty_check': qc_empty_check,
        'qc_packaging_check': qc_packaging_check,
        'qc_finished_check': qc_finished_check,
        'qc_archive_ready': qc_archive_ready,
        'qc_raw_notes': qc_raw_notes,
        'qc_manufacturing_notes': qc_manufacturing_notes,
        'qc_lab_notes': qc_lab_notes,
        'qc_empty_notes': qc_empty_notes,
        'qc_packaging_notes': qc_packaging_notes,
        'qc_finished_notes': qc_finished_notes,
        'raw_mark_1': raw_mark_1,
        'raw_mark_2': raw_mark_2,
        'raw_mark_3': raw_mark_3,
        'raw_mark_4': raw_mark_4,
        'raw_mark_5': raw_mark_5,
        'raw_mark_6': raw_mark_6,
        'manufacturing_mark_1': manufacturing_mark_1,
        'manufacturing_mark_2': manufacturing_mark_2,
        'manufacturing_mark_3': manufacturing_mark_3,
        'manufacturing_mark_4': manufacturing_mark_4,
        'manufacturing_mark_5': manufacturing_mark_5,
        'manufacturing_mark_6': manufacturing_mark_6,
        'lab_mark_1': lab_mark_1,
        'lab_mark_2': lab_mark_2,
        'lab_mark_3': lab_mark_3,
        'lab_mark_4': lab_mark_4,
        'lab_mark_5': lab_mark_5,
        'lab_mark_6': lab_mark_6,
        'empty_packaging_mark_1': empty_packaging_mark_1,
        'empty_packaging_mark_2': empty_packaging_mark_2,
        'empty_packaging_mark_3': empty_packaging_mark_3,
        'empty_packaging_mark_4': empty_packaging_mark_4,
        'empty_packaging_mark_5': empty_packaging_mark_5,
        'empty_packaging_mark_6': empty_packaging_mark_6,
        'packaging_mark_1': packaging_mark_1,
        'packaging_mark_2': packaging_mark_2,
        'packaging_mark_3': packaging_mark_3,
        'packaging_mark_4': packaging_mark_4,
        'packaging_mark_5': packaging_mark_5,
        'packaging_mark_6': packaging_mark_6,
        'finished_goods_mark_1': finished_goods_mark_1,
        'finished_goods_mark_2': finished_goods_mark_2,
        'finished_goods_mark_3': finished_goods_mark_3,
        'finished_goods_mark_4': finished_goods_mark_4,
        'finished_goods_mark_5': finished_goods_mark_5,
        'finished_goods_mark_6': finished_goods_mark_6,
      }
    };
  }

  factory QualityControlModel.fromMap(Map<String, dynamic> map) {
    return QualityControlModel(
      id: map['id'] != null ? map['id'] as int : null,
      qc_raw_check:
          map['qc_raw_check'] != null ? map['qc_raw_check'] as bool : null,
      qc_manufacturing_check: map['qc_manufacturing_check'] != null
          ? map['qc_manufacturing_check'] as bool
          : null,
      qc_lab_check:
          map['qc_lab_check'] != null ? map['qc_lab_check'] as bool : null,
      qc_empty_check:
          map['qc_empty_check'] != null ? map['qc_empty_check'] as bool : null,
      qc_packaging_check: map['qc_packaging_check'] != null
          ? map['qc_packaging_check'] as bool
          : null,
      qc_finished_check: map['qc_finished_check'] != null
          ? map['qc_finished_check'] as bool
          : null,
      qc_archive_ready: map['qc_archive_ready'] != null
          ? map['qc_archive_ready'] as bool
          : null,
      qc_raw_notes:
          map['qc_raw_notes'] != null ? map['qc_raw_notes'] as String : null,
      qc_manufacturing_notes: map['qc_manufacturing_notes'] != null
          ? map['qc_manufacturing_notes'] as String
          : null,
      qc_lab_notes:
          map['qc_lab_notes'] != null ? map['qc_lab_notes'] as String : null,
      qc_empty_notes: map['qc_empty_notes'] != null
          ? map['qc_empty_notes'] as String
          : null,
      qc_packaging_notes: map['qc_packaging_notes'] != null
          ? map['qc_packaging_notes'] as String
          : null,
      qc_finished_notes: map['qc_finished_notes'] != null
          ? map['qc_finished_notes'] as String
          : null,
      raw_mark_1: map['raw_mark_1'] != null ? map['raw_mark_1'] as int : null,
      raw_mark_2: map['raw_mark_2'] != null ? map['raw_mark_2'] as int : null,
      raw_mark_3: map['raw_mark_3'] != null ? map['raw_mark_3'] as int : null,
      raw_mark_4: map['raw_mark_4'] != null ? map['raw_mark_4'] as int : null,
      raw_mark_5: map['raw_mark_5'] != null ? map['raw_mark_5'] as int : null,
      raw_mark_6: map['raw_mark_6'] != null ? map['raw_mark_6'] as int : null,
      manufacturing_mark_1: map['manufacturing_mark_1'] != null
          ? map['manufacturing_mark_1'] as int
          : null,
      manufacturing_mark_2: map['manufacturing_mark_2'] != null
          ? map['manufacturing_mark_2'] as int
          : null,
      manufacturing_mark_3: map['manufacturing_mark_3'] != null
          ? map['manufacturing_mark_3'] as int
          : null,
      manufacturing_mark_4: map['manufacturing_mark_4'] != null
          ? map['manufacturing_mark_4'] as int
          : null,
      manufacturing_mark_5: map['manufacturing_mark_5'] != null
          ? map['manufacturing_mark_5'] as int
          : null,
      manufacturing_mark_6: map['manufacturing_mark_6'] != null
          ? map['manufacturing_mark_6'] as int
          : null,
      lab_mark_1: map['lab_mark_1'] != null ? map['lab_mark_1'] as int : null,
      lab_mark_2: map['lab_mark_2'] != null ? map['lab_mark_2'] as int : null,
      lab_mark_3: map['lab_mark_3'] != null ? map['lab_mark_3'] as int : null,
      lab_mark_4: map['lab_mark_4'] != null ? map['lab_mark_4'] as int : null,
      lab_mark_5: map['lab_mark_5'] != null ? map['lab_mark_5'] as int : null,
      lab_mark_6: map['lab_mark_6'] != null ? map['lab_mark_6'] as int : null,
      empty_packaging_mark_1: map['empty_packaging_mark_1'] != null
          ? map['empty_packaging_mark_1'] as int
          : null,
      empty_packaging_mark_2: map['empty_packaging_mark_2'] != null
          ? map['empty_packaging_mark_2'] as int
          : null,
      empty_packaging_mark_3: map['empty_packaging_mark_3'] != null
          ? map['empty_packaging_mark_3'] as int
          : null,
      empty_packaging_mark_4: map['empty_packaging_mark_4'] != null
          ? map['empty_packaging_mark_4'] as int
          : null,
      empty_packaging_mark_5: map['empty_packaging_mark_5'] != null
          ? map['empty_packaging_mark_5'] as int
          : null,
      empty_packaging_mark_6: map['empty_packaging_mark_6'] != null
          ? map['empty_packaging_mark_6'] as int
          : null,
      packaging_mark_1: map['packaging_mark_1'] != null
          ? map['packaging_mark_1'] as int
          : null,
      packaging_mark_2: map['packaging_mark_2'] != null
          ? map['packaging_mark_2'] as int
          : null,
      packaging_mark_3: map['packaging_mark_3'] != null
          ? map['packaging_mark_3'] as int
          : null,
      packaging_mark_4: map['packaging_mark_4'] != null
          ? map['packaging_mark_4'] as int
          : null,
      packaging_mark_5: map['packaging_mark_5'] != null
          ? map['packaging_mark_5'] as int
          : null,
      packaging_mark_6: map['packaging_mark_6'] != null
          ? map['packaging_mark_6'] as int
          : null,
      finished_goods_mark_1: map['finished_goods_mark_1'] != null
          ? map['finished_goods_mark_1'] as int
          : null,
      finished_goods_mark_2: map['finished_goods_mark_2'] != null
          ? map['finished_goods_mark_2'] as int
          : null,
      finished_goods_mark_3: map['finished_goods_mark_3'] != null
          ? map['finished_goods_mark_3'] as int
          : null,
      finished_goods_mark_4: map['finished_goods_mark_4'] != null
          ? map['finished_goods_mark_4'] as int
          : null,
      finished_goods_mark_5: map['finished_goods_mark_5'] != null
          ? map['finished_goods_mark_5'] as int
          : null,
      finished_goods_mark_6: map['finished_goods_mark_6'] != null
          ? map['finished_goods_mark_6'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QualityControlModel.fromJson(String source) =>
      QualityControlModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QualityControlModel(id: $id, qc_raw_check: $qc_raw_check, qc_manufacturing_check: $qc_manufacturing_check, qc_lab_check: $qc_lab_check, qc_empty_check: $qc_empty_check, qc_packaging_check: $qc_packaging_check, qc_finished_check: $qc_finished_check, qc_archive_ready: $qc_archive_ready, qc_raw_notes: $qc_raw_notes, qc_manufacturing_notes: $qc_manufacturing_notes, qc_lab_notes: $qc_lab_notes, qc_empty_notes: $qc_empty_notes, qc_packaging_notes: $qc_packaging_notes, qc_finished_notes: $qc_finished_notes, raw_mark_1: $raw_mark_1, raw_mark_2: $raw_mark_2, raw_mark_3: $raw_mark_3, raw_mark_4: $raw_mark_4, raw_mark_5: $raw_mark_5, raw_mark_6: $raw_mark_6, manufacturing_mark_1: $manufacturing_mark_1, manufacturing_mark_2: $manufacturing_mark_2, manufacturing_mark_3: $manufacturing_mark_3, manufacturing_mark_4: $manufacturing_mark_4, manufacturing_mark_5: $manufacturing_mark_5, manufacturing_mark_6: $manufacturing_mark_6, lab_mark_1: $lab_mark_1, lab_mark_2: $lab_mark_2, lab_mark_3: $lab_mark_3, lab_mark_4: $lab_mark_4, lab_mark_5: $lab_mark_5, lab_mark_6: $lab_mark_6, empty_packaging_mark_1: $empty_packaging_mark_1, empty_packaging_mark_2: $empty_packaging_mark_2, empty_packaging_mark_3: $empty_packaging_mark_3, empty_packaging_mark_4: $empty_packaging_mark_4, empty_packaging_mark_5: $empty_packaging_mark_5, empty_packaging_mark_6: $empty_packaging_mark_6, packaging_mark_1: $packaging_mark_1, packaging_mark_2: $packaging_mark_2, packaging_mark_3: $packaging_mark_3, packaging_mark_4: $packaging_mark_4, packaging_mark_5: $packaging_mark_5, packaging_mark_6: $packaging_mark_6, finished_goods_mark_1: $finished_goods_mark_1, finished_goods_mark_2: $finished_goods_mark_2, finished_goods_mark_3: $finished_goods_mark_3, finished_goods_mark_4: $finished_goods_mark_4, finished_goods_mark_5: $finished_goods_mark_5, finished_goods_mark_6: $finished_goods_mark_6)';
  }

  @override
  bool operator ==(covariant QualityControlModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.qc_raw_check == qc_raw_check &&
        other.qc_manufacturing_check == qc_manufacturing_check &&
        other.qc_lab_check == qc_lab_check &&
        other.qc_empty_check == qc_empty_check &&
        other.qc_packaging_check == qc_packaging_check &&
        other.qc_finished_check == qc_finished_check &&
        other.qc_archive_ready == qc_archive_ready &&
        other.qc_raw_notes == qc_raw_notes &&
        other.qc_manufacturing_notes == qc_manufacturing_notes &&
        other.qc_lab_notes == qc_lab_notes &&
        other.qc_empty_notes == qc_empty_notes &&
        other.qc_packaging_notes == qc_packaging_notes &&
        other.qc_finished_notes == qc_finished_notes &&
        other.raw_mark_1 == raw_mark_1 &&
        other.raw_mark_2 == raw_mark_2 &&
        other.raw_mark_3 == raw_mark_3 &&
        other.raw_mark_4 == raw_mark_4 &&
        other.raw_mark_5 == raw_mark_5 &&
        other.raw_mark_6 == raw_mark_6 &&
        other.manufacturing_mark_1 == manufacturing_mark_1 &&
        other.manufacturing_mark_2 == manufacturing_mark_2 &&
        other.manufacturing_mark_3 == manufacturing_mark_3 &&
        other.manufacturing_mark_4 == manufacturing_mark_4 &&
        other.manufacturing_mark_5 == manufacturing_mark_5 &&
        other.manufacturing_mark_6 == manufacturing_mark_6 &&
        other.lab_mark_1 == lab_mark_1 &&
        other.lab_mark_2 == lab_mark_2 &&
        other.lab_mark_3 == lab_mark_3 &&
        other.lab_mark_4 == lab_mark_4 &&
        other.lab_mark_5 == lab_mark_5 &&
        other.lab_mark_6 == lab_mark_6 &&
        other.empty_packaging_mark_1 == empty_packaging_mark_1 &&
        other.empty_packaging_mark_2 == empty_packaging_mark_2 &&
        other.empty_packaging_mark_3 == empty_packaging_mark_3 &&
        other.empty_packaging_mark_4 == empty_packaging_mark_4 &&
        other.empty_packaging_mark_5 == empty_packaging_mark_5 &&
        other.empty_packaging_mark_6 == empty_packaging_mark_6 &&
        other.packaging_mark_1 == packaging_mark_1 &&
        other.packaging_mark_2 == packaging_mark_2 &&
        other.packaging_mark_3 == packaging_mark_3 &&
        other.packaging_mark_4 == packaging_mark_4 &&
        other.packaging_mark_5 == packaging_mark_5 &&
        other.packaging_mark_6 == packaging_mark_6 &&
        other.finished_goods_mark_1 == finished_goods_mark_1 &&
        other.finished_goods_mark_2 == finished_goods_mark_2 &&
        other.finished_goods_mark_3 == finished_goods_mark_3 &&
        other.finished_goods_mark_4 == finished_goods_mark_4 &&
        other.finished_goods_mark_5 == finished_goods_mark_5 &&
        other.finished_goods_mark_6 == finished_goods_mark_6;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        qc_raw_check.hashCode ^
        qc_manufacturing_check.hashCode ^
        qc_lab_check.hashCode ^
        qc_empty_check.hashCode ^
        qc_packaging_check.hashCode ^
        qc_finished_check.hashCode ^
        qc_archive_ready.hashCode ^
        qc_raw_notes.hashCode ^
        qc_manufacturing_notes.hashCode ^
        qc_lab_notes.hashCode ^
        qc_empty_notes.hashCode ^
        qc_packaging_notes.hashCode ^
        qc_finished_notes.hashCode ^
        raw_mark_1.hashCode ^
        raw_mark_2.hashCode ^
        raw_mark_3.hashCode ^
        raw_mark_4.hashCode ^
        raw_mark_5.hashCode ^
        raw_mark_6.hashCode ^
        manufacturing_mark_1.hashCode ^
        manufacturing_mark_2.hashCode ^
        manufacturing_mark_3.hashCode ^
        manufacturing_mark_4.hashCode ^
        manufacturing_mark_5.hashCode ^
        manufacturing_mark_6.hashCode ^
        lab_mark_1.hashCode ^
        lab_mark_2.hashCode ^
        lab_mark_3.hashCode ^
        lab_mark_4.hashCode ^
        lab_mark_5.hashCode ^
        lab_mark_6.hashCode ^
        empty_packaging_mark_1.hashCode ^
        empty_packaging_mark_2.hashCode ^
        empty_packaging_mark_3.hashCode ^
        empty_packaging_mark_4.hashCode ^
        empty_packaging_mark_5.hashCode ^
        empty_packaging_mark_6.hashCode ^
        packaging_mark_1.hashCode ^
        packaging_mark_2.hashCode ^
        packaging_mark_3.hashCode ^
        packaging_mark_4.hashCode ^
        packaging_mark_5.hashCode ^
        packaging_mark_6.hashCode ^
        finished_goods_mark_1.hashCode ^
        finished_goods_mark_2.hashCode ^
        finished_goods_mark_3.hashCode ^
        finished_goods_mark_4.hashCode ^
        finished_goods_mark_5.hashCode ^
        finished_goods_mark_6.hashCode;
  }
}
