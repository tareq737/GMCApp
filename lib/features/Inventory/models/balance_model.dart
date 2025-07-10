// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BalanceModel {
  int item_id;
  String? item_code;
  String? item_name;
  String? unit;
  int warehouse_id;
  String? warehouse_name;
  double quantity;
  BalanceModel({
    required this.item_id,
    this.item_code,
    this.item_name,
    this.unit,
    required this.warehouse_id,
    this.warehouse_name,
    required this.quantity,
  });

  BalanceModel copyWith({
    int? item_id,
    String? item_code,
    String? item_name,
    String? unit,
    int? warehouse_id,
    String? warehouse_name,
    double? quantity,
  }) {
    return BalanceModel(
      item_id: item_id ?? this.item_id,
      item_code: item_code ?? this.item_code,
      item_name: item_name ?? this.item_name,
      unit: unit ?? this.unit,
      warehouse_id: warehouse_id ?? this.warehouse_id,
      warehouse_name: warehouse_name ?? this.warehouse_name,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_id': item_id,
      'item_code': item_code,
      'item_name': item_name,
      'unit': unit,
      'warehouse_id': warehouse_id,
      'warehouse_name': warehouse_name,
      'quantity': quantity,
    };
  }

  factory BalanceModel.fromMap(Map<String, dynamic> map) {
    return BalanceModel(
      item_id: map['item_id'] as int,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      warehouse_id: map['warehouse_id'] as int,
      warehouse_name: map['warehouse_name'] != null
          ? map['warehouse_name'] as String
          : null,
      quantity: map['quantity'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory BalanceModel.fromJson(String source) =>
      BalanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BalanceModel(item_id: $item_id, item_code: $item_code, item_name: $item_name, unit: $unit, warehouse_id: $warehouse_id, warehouse_name: $warehouse_name, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant BalanceModel other) {
    if (identical(this, other)) return true;

    return other.item_id == item_id &&
        other.item_code == item_code &&
        other.item_name == item_name &&
        other.unit == unit &&
        other.warehouse_id == warehouse_id &&
        other.warehouse_name == warehouse_name &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return item_id.hashCode ^
        item_code.hashCode ^
        item_name.hashCode ^
        unit.hashCode ^
        warehouse_id.hashCode ^
        warehouse_name.hashCode ^
        quantity.hashCode;
  }
}
