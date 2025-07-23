// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:gmcappclean/features/Inventory/models/items_model.dart';

class FinishedItemsManufacturingModel {
  int? item;
  String? item_name;
  String? item_unit;
  String? quantity;
  int? to_warehouse;
  String? to_warehouse_name;
  String? note;
  ItemsModel? item_details;
  FinishedItemsManufacturingModel({
    this.item,
    this.item_name,
    this.item_unit,
    this.quantity,
    this.to_warehouse,
    this.to_warehouse_name,
    this.note,
    this.item_details,
  });

  FinishedItemsManufacturingModel copyWith({
    int? item,
    String? item_name,
    String? item_unit,
    String? quantity,
    int? to_warehouse,
    String? to_warehouse_name,
    String? note,
    ItemsModel? item_details,
  }) {
    return FinishedItemsManufacturingModel(
      item: item ?? this.item,
      item_name: item_name ?? this.item_name,
      item_unit: item_unit ?? this.item_unit,
      quantity: quantity ?? this.quantity,
      to_warehouse: to_warehouse ?? this.to_warehouse,
      to_warehouse_name: to_warehouse_name ?? this.to_warehouse_name,
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
      'to_warehouse': to_warehouse,
      'to_warehouse_name': to_warehouse_name,
      'note': note,
      'item_details': item_details?.toMap(),
    };
  }

  factory FinishedItemsManufacturingModel.fromMap(Map<String, dynamic> map) {
    return FinishedItemsManufacturingModel(
      item: map['item'] != null ? map['item'] as int : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_unit: map['item_unit'] != null ? map['item_unit'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as String : null,
      to_warehouse:
          map['to_warehouse'] != null ? map['to_warehouse'] as int : null,
      to_warehouse_name: map['to_warehouse_name'] != null
          ? map['to_warehouse_name'] as String
          : null,
      note: map['note'] != null ? map['note'] as String : null,
      item_details: map['item_details'] != null
          ? ItemsModel.fromMap(map['item_details'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinishedItemsManufacturingModel.fromJson(String source) =>
      FinishedItemsManufacturingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FinishedItemsManufacturingModel(item: $item, item_name: $item_name, item_unit: $item_unit, quantity: $quantity, to_warehouse: $to_warehouse, to_warehouse_name: $to_warehouse_name, note: $note, item_details: $item_details)';
  }

  @override
  bool operator ==(covariant FinishedItemsManufacturingModel other) {
    if (identical(this, other)) return true;

    return other.item == item &&
        other.item_name == item_name &&
        other.item_unit == item_unit &&
        other.quantity == quantity &&
        other.to_warehouse == to_warehouse &&
        other.to_warehouse_name == to_warehouse_name &&
        other.note == note &&
        other.item_details == item_details;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        item_name.hashCode ^
        item_unit.hashCode ^
        quantity.hashCode ^
        to_warehouse.hashCode ^
        to_warehouse_name.hashCode ^
        note.hashCode ^
        item_details.hashCode;
  }
}
