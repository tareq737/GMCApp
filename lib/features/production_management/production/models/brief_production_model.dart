// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BriefProductionModel {
  int? id;
  String? batch_number;
  String? insert_date;
  String? type;
  String? tier;
  String? color;
  double? total_weight;
  double? total_volume;
  bool? raw_material_check_4;
  bool? manufacturing_check_6;
  bool? lab_check_6;
  bool? empty_packaging_check_5;
  bool? packaging_check_6;
  bool? finished_goods_check_3;
  int? duration;
  BriefProductionModel({
    this.id,
    this.batch_number,
    this.insert_date,
    this.type,
    this.tier,
    this.color,
    this.total_weight,
    this.total_volume,
    this.raw_material_check_4,
    this.manufacturing_check_6,
    this.lab_check_6,
    this.empty_packaging_check_5,
    this.packaging_check_6,
    this.finished_goods_check_3,
    this.duration,
  });

  BriefProductionModel copyWith({
    int? id,
    String? batch_number,
    String? insert_date,
    String? type,
    String? tier,
    String? color,
    double? total_weight,
    double? total_volume,
    bool? raw_material_check_4,
    bool? manufacturing_check_6,
    bool? lab_check_6,
    bool? empty_packaging_check_5,
    bool? packaging_check_6,
    bool? finished_goods_check_3,
    int? duration,
  }) {
    return BriefProductionModel(
      id: id ?? this.id,
      batch_number: batch_number ?? this.batch_number,
      insert_date: insert_date ?? this.insert_date,
      type: type ?? this.type,
      tier: tier ?? this.tier,
      color: color ?? this.color,
      total_weight: total_weight ?? this.total_weight,
      total_volume: total_volume ?? this.total_volume,
      raw_material_check_4: raw_material_check_4 ?? this.raw_material_check_4,
      manufacturing_check_6:
          manufacturing_check_6 ?? this.manufacturing_check_6,
      lab_check_6: lab_check_6 ?? this.lab_check_6,
      empty_packaging_check_5:
          empty_packaging_check_5 ?? this.empty_packaging_check_5,
      packaging_check_6: packaging_check_6 ?? this.packaging_check_6,
      finished_goods_check_3:
          finished_goods_check_3 ?? this.finished_goods_check_3,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'batch_number': batch_number,
      'insert_date': insert_date,
      'type': type,
      'tier': tier,
      'color': color,
      'total_weight': total_weight,
      'total_volume': total_volume,
      'raw_material_check_4': raw_material_check_4,
      'manufacturing_check_6': manufacturing_check_6,
      'lab_check_6': lab_check_6,
      'empty_packaging_check_5': empty_packaging_check_5,
      'packaging_check_6': packaging_check_6,
      'finished_goods_check_3': finished_goods_check_3,
      'duration': duration,
    };
  }

  factory BriefProductionModel.fromMap(Map<String, dynamic> map) {
    return BriefProductionModel(
      id: map['id'] != null ? map['id'] as int : null,
      batch_number:
          map['batch_number'] != null ? map['batch_number'] as String : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      tier: map['tier'] != null ? map['tier'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      total_weight:
          map['total_weight'] != null ? map['total_weight'] as double : null,
      total_volume:
          map['total_volume'] != null ? map['total_volume'] as double : null,
      raw_material_check_4: map['raw_material_check_4'] != null
          ? map['raw_material_check_4'] as bool
          : null,
      manufacturing_check_6: map['manufacturing_check_6'] != null
          ? map['manufacturing_check_6'] as bool
          : null,
      lab_check_6:
          map['lab_check_6'] != null ? map['lab_check_6'] as bool : null,
      empty_packaging_check_5: map['empty_packaging_check_5'] != null
          ? map['empty_packaging_check_5'] as bool
          : null,
      packaging_check_6: map['packaging_check_6'] != null
          ? map['packaging_check_6'] as bool
          : null,
      finished_goods_check_3: map['finished_goods_check_3'] != null
          ? map['finished_goods_check_3'] as bool
          : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefProductionModel.fromJson(String source) =>
      BriefProductionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefProductionModel(id: $id, batch_number: $batch_number, insert_date: $insert_date, type: $type, tier: $tier, color: $color, total_weight: $total_weight, total_volume: $total_volume, raw_material_check_4: $raw_material_check_4, manufacturing_check_6: $manufacturing_check_6, lab_check_6: $lab_check_6, empty_packaging_check_5: $empty_packaging_check_5, packaging_check_6: $packaging_check_6, finished_goods_check_3: $finished_goods_check_3, duration: $duration)';
  }

  @override
  bool operator ==(covariant BriefProductionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.batch_number == batch_number &&
        other.insert_date == insert_date &&
        other.type == type &&
        other.tier == tier &&
        other.color == color &&
        other.total_weight == total_weight &&
        other.total_volume == total_volume &&
        other.raw_material_check_4 == raw_material_check_4 &&
        other.manufacturing_check_6 == manufacturing_check_6 &&
        other.lab_check_6 == lab_check_6 &&
        other.empty_packaging_check_5 == empty_packaging_check_5 &&
        other.packaging_check_6 == packaging_check_6 &&
        other.finished_goods_check_3 == finished_goods_check_3 &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        batch_number.hashCode ^
        insert_date.hashCode ^
        type.hashCode ^
        tier.hashCode ^
        color.hashCode ^
        total_weight.hashCode ^
        total_volume.hashCode ^
        raw_material_check_4.hashCode ^
        manufacturing_check_6.hashCode ^
        lab_check_6.hashCode ^
        empty_packaging_check_5.hashCode ^
        packaging_check_6.hashCode ^
        finished_goods_check_3.hashCode ^
        duration.hashCode;
  }
}
