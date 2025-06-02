// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PackagingBreakdownModel {
  int? id;
  String? brand;
  int? quantity;
  String? package_type;
  double? package_volume;
  double? package_weight;
  PackagingBreakdownModel({
    this.id,
    this.brand,
    this.quantity,
    this.package_type,
    this.package_volume,
    this.package_weight,
  });

  PackagingBreakdownModel copyWith({
    int? id,
    String? brand,
    int? quantity,
    double? sum_volume,
    double? sum_weight,
    String? package_type,
    double? package_volume,
    double? package_weight,
  }) {
    return PackagingBreakdownModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      quantity: quantity ?? this.quantity,
      package_type: package_type ?? this.package_type,
      package_volume: package_volume ?? this.package_volume,
      package_weight: package_weight ?? this.package_weight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'packaging_breakdown': {
        'id': id,
        'brand': brand,
        'quantity': quantity,
        'package_type': package_type,
        'package_volume': package_volume,
        'package_weight': package_weight,
      }
    };
  }

  factory PackagingBreakdownModel.fromMap(Map<String, dynamic> map) {
    return PackagingBreakdownModel(
      id: map['id'] != null ? map['id'] as int : null,
      brand: map['brand'] != null ? map['brand'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      package_type:
          map['package_type'] != null ? map['package_type'] as String : null,
      package_volume: map['package_volume'] != null
          ? map['package_volume'] as double
          : null,
      package_weight: map['package_weight'] != null
          ? map['package_weight'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackagingBreakdownModel.fromJson(String source) =>
      PackagingBreakdownModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PackagingBreakdownModel(id: $id, brand: $brand, quantity: $quantity, package_type: $package_type, package_volume: $package_volume, package_weight: $package_weight)';
  }

  @override
  bool operator ==(covariant PackagingBreakdownModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.brand == brand &&
        other.quantity == quantity &&
        other.package_type == package_type &&
        other.package_volume == package_volume &&
        other.package_weight == package_weight;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        brand.hashCode ^
        quantity.hashCode ^
        package_type.hashCode ^
        package_volume.hashCode ^
        package_weight.hashCode;
  }
}
