// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:gmcappclean/features/Inventory/models/items_model.dart';

class RawItemsManufacturingModel {
  int? item;
  String? item_name;
  String? item_unit;
  String? quantity;
  int? from_warehouse;
  String? from_warehouse_name;
  String? note;
  ItemsModel? item_details;
  RawItemsManufacturingModel({
    this.item,
    this.item_name,
    this.item_unit,
    this.quantity,
    this.from_warehouse,
    this.from_warehouse_name,
    this.note,
    this.item_details,
  });

  RawItemsManufacturingModel copyWith({
    int? item,
    String? item_name,
    String? item_unit,
    String? quantity,
    int? from_warehouse,
    String? from_warehouse_name,
    String? note,
    ItemsModel? item_details,
  }) {
    return RawItemsManufacturingModel(
      item: item ?? this.item,
      item_name: item_name ?? this.item_name,
      item_unit: item_unit ?? this.item_unit,
      quantity: quantity ?? this.quantity,
      from_warehouse: from_warehouse ?? this.from_warehouse,
      from_warehouse_name: from_warehouse_name ?? this.from_warehouse_name,
      note: note ?? this.note,
      item_details: item_details ?? this.item_details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item,
      'item_name': item_name,
      'item_unit': item_unit,
      'quantity': quantity,
      'from_warehouse': from_warehouse,
      'from_warehouse_name': from_warehouse_name,
      'note': note,
      'item_details': item_details?.toMap(),
    };
  }

  factory RawItemsManufacturingModel.fromMap(Map<String, dynamic> map) {
    return RawItemsManufacturingModel(
      item: map['item'] != null ? map['item'] as int : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_unit: map['item_unit'] != null ? map['item_unit'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as String : null,
      from_warehouse:
          map['from_warehouse'] != null ? map['from_warehouse'] as int : null,
      from_warehouse_name: map['from_warehouse_name'] != null
          ? map['from_warehouse_name'] as String
          : null,
      note: map['note'] != null ? map['note'] as String : null,
      item_details: map['item_details'] != null
          ? ItemsModel.fromMap(map['item_details'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RawItemsManufacturingModel.fromJson(String source) =>
      RawItemsManufacturingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RawItemsManufacturingModel(item: $item, item_name: $item_name, item_unit: $item_unit, quantity: $quantity, from_warehouse: $from_warehouse, from_warehouse_name: $from_warehouse_name, note: $note, item_details: $item_details)';
  }

  @override
  bool operator ==(covariant RawItemsManufacturingModel other) {
    if (identical(this, other)) return true;

    return other.item == item &&
        other.item_name == item_name &&
        other.item_unit == item_unit &&
        other.quantity == quantity &&
        other.from_warehouse == from_warehouse &&
        other.from_warehouse_name == from_warehouse_name &&
        other.note == note &&
        other.item_details == item_details;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        item_name.hashCode ^
        item_unit.hashCode ^
        quantity.hashCode ^
        from_warehouse.hashCode ^
        from_warehouse_name.hashCode ^
        note.hashCode ^
        item_details.hashCode;
  }
}
