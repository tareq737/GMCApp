// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductPercentagesAverageModel {
  int? healthy_percentage;
  int? paints_percentage;
  int? hardware_percentage;
  int? electrical_percentage;
  int? building_materials_percentage;
  ProductPercentagesAverageModel({
    this.healthy_percentage,
    this.paints_percentage,
    this.hardware_percentage,
    this.electrical_percentage,
    this.building_materials_percentage,
  });

  ProductPercentagesAverageModel copyWith({
    int? healthy_percentage,
    int? paints_percentage,
    int? hardware_percentage,
    int? electrical_percentage,
    int? building_materials_percentage,
  }) {
    return ProductPercentagesAverageModel(
      healthy_percentage: healthy_percentage ?? this.healthy_percentage,
      paints_percentage: paints_percentage ?? this.paints_percentage,
      hardware_percentage: hardware_percentage ?? this.hardware_percentage,
      electrical_percentage:
          electrical_percentage ?? this.electrical_percentage,
      building_materials_percentage:
          building_materials_percentage ?? this.building_materials_percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'healthy_percentage': healthy_percentage,
      'paints_percentage': paints_percentage,
      'hardware_percentage': hardware_percentage,
      'electrical_percentage': electrical_percentage,
      'building_materials_percentage': building_materials_percentage,
    };
  }

  factory ProductPercentagesAverageModel.fromMap(Map<String, dynamic> map) {
    return ProductPercentagesAverageModel(
      healthy_percentage: map['healthy_percentage'] != null
          ? map['healthy_percentage'] as int
          : null,
      paints_percentage: map['paints_percentage'] != null
          ? map['paints_percentage'] as int
          : null,
      hardware_percentage: map['hardware_percentage'] != null
          ? map['hardware_percentage'] as int
          : null,
      electrical_percentage: map['electrical_percentage'] != null
          ? map['electrical_percentage'] as int
          : null,
      building_materials_percentage:
          map['building_materials_percentage'] != null
              ? map['building_materials_percentage'] as int
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductPercentagesAverageModel.fromJson(String source) =>
      ProductPercentagesAverageModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductPercentagesAverageModel(healthy_percentage: $healthy_percentage, paints_percentage: $paints_percentage, hardware_percentage: $hardware_percentage, electrical_percentage: $electrical_percentage, building_materials_percentage: $building_materials_percentage)';
  }

  @override
  bool operator ==(covariant ProductPercentagesAverageModel other) {
    if (identical(this, other)) return true;

    return other.healthy_percentage == healthy_percentage &&
        other.paints_percentage == paints_percentage &&
        other.hardware_percentage == hardware_percentage &&
        other.electrical_percentage == electrical_percentage &&
        other.building_materials_percentage == building_materials_percentage;
  }

  @override
  int get hashCode {
    return healthy_percentage.hashCode ^
        paints_percentage.hashCode ^
        hardware_percentage.hashCode ^
        electrical_percentage.hashCode ^
        building_materials_percentage.hashCode;
  }
}
