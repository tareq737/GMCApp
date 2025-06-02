// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductionModel {
  int? id;
  String? insert_date;
  String? batch_number;
  String? type;
  String? tier;
  String? color;
  double? total_weight;
  double? total_volume;
  double? density;
  String? prepared_by_notes;
  String? manager_notes;

  ProductionModel({
    this.id,
    this.insert_date,
    this.batch_number,
    this.type,
    this.tier,
    this.color,
    this.total_weight,
    this.total_volume,
    this.density,
    this.prepared_by_notes,
    this.manager_notes,
  });

  ProductionModel copyWith({
    int? id,
    String? insert_date,
    String? batch_number,
    String? type,
    String? tier,
    String? color,
    double? total_weight,
    double? total_volume,
    double? density,
    String? prepared_by_notes,
    String? manager_notes,
    bool? raw_material_check_4,
    bool? manufacturing_check_6,
    bool? lab_check_6,
    bool? empty_packaging_check_5,
    bool? packaging_check_6,
    bool? finished_goods_check_6,
  }) {
    return ProductionModel(
      id: id ?? this.id,
      insert_date: insert_date ?? this.insert_date,
      batch_number: batch_number ?? this.batch_number,
      type: type ?? this.type,
      tier: tier ?? this.tier,
      color: color ?? this.color,
      total_weight: total_weight ?? this.total_weight,
      total_volume: total_volume ?? this.total_volume,
      density: density ?? this.density,
      prepared_by_notes: prepared_by_notes ?? this.prepared_by_notes,
      manager_notes: manager_notes ?? this.manager_notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'insert_date': insert_date,
      'batch_number': batch_number,
      'type': type,
      'tier': tier,
      'color': color,
      'total_weight': total_weight,
      'total_volume': total_volume,
      'density': density,
      'prepared_by_notes': prepared_by_notes,
      'manager_notes': manager_notes,
    };
  }

  factory ProductionModel.fromMap(Map<String, dynamic> map) {
    return ProductionModel(
      id: map['id'] != null ? map['id'] as int : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      batch_number:
          map['batch_number'] != null ? map['batch_number'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      tier: map['tier'] != null ? map['tier'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      total_weight:
          map['total_weight'] != null ? map['total_weight'] as double : null,
      total_volume:
          map['total_volume'] != null ? map['total_volume'] as double : null,
      density: map['density'] != null ? map['density'] as double : null,
      prepared_by_notes: map['prepared_by_notes'] != null
          ? map['prepared_by_notes'] as String
          : null,
      manager_notes:
          map['manager_notes'] != null ? map['manager_notes'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionModel.fromJson(String source) =>
      ProductionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductionModel(id: $id, insert_date: $insert_date, batch_number: $batch_number, type: $type, tier: $tier, color: $color, total_weight: $total_weight, total_volume: $total_volume, density: $density, prepared_by_notes: $prepared_by_notes, manager_notes: $manager_notes)';
  }

  @override
  bool operator ==(covariant ProductionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.insert_date == insert_date &&
        other.batch_number == batch_number &&
        other.type == type &&
        other.tier == tier &&
        other.color == color &&
        other.total_weight == total_weight &&
        other.total_volume == total_volume &&
        other.density == density &&
        other.prepared_by_notes == prepared_by_notes &&
        other.manager_notes == manager_notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        insert_date.hashCode ^
        batch_number.hashCode ^
        type.hashCode ^
        tier.hashCode ^
        color.hashCode ^
        total_weight.hashCode ^
        total_volume.hashCode ^
        density.hashCode ^
        prepared_by_notes.hashCode ^
        manager_notes.hashCode;
  }
}
