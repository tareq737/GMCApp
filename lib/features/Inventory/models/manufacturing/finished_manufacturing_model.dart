// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:gmcappclean/features/Inventory/models/manufacturing/finished_items_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/raw_items_manufacturing_model.dart';

class FinishedManufacturingModel {
  int? id;
  int? serial;
  String? transfer_type_name;
  String? note;
  List<FinishedItemsManufacturingModel>? items;
  FinishedManufacturingModel({
    this.id,
    this.serial,
    this.transfer_type_name,
    this.note,
    this.items,
  });

  FinishedManufacturingModel copyWith({
    int? id,
    int? serial,
    String? transfer_type_name,
    String? note,
    List<FinishedItemsManufacturingModel>? items,
  }) {
    return FinishedManufacturingModel(
      id: id ?? this.id,
      serial: serial ?? this.serial,
      transfer_type_name: transfer_type_name ?? this.transfer_type_name,
      note: note ?? this.note,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'serial': serial,
      'transfer_type_name': transfer_type_name,
      'note': note,
      'items': items!.map((x) => x?.toMap()).toList(),
    };
  }

  factory FinishedManufacturingModel.fromMap(Map<String, dynamic> map) {
    return FinishedManufacturingModel(
      id: map['id'] != null ? map['id'] as int : null,
      serial: map['serial'] != null ? map['serial'] as int : null,
      transfer_type_name: map['transfer_type_name'] != null
          ? map['transfer_type_name'] as String
          : null,
      note: map['note'] != null ? map['note'] as String : null,
      items: map['items'] != null
          ? List<FinishedItemsManufacturingModel>.from(
              (map['items'] as List<dynamic>)
                  .map<FinishedItemsManufacturingModel?>(
                (x) => FinishedItemsManufacturingModel.fromMap(
                    x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinishedManufacturingModel.fromJson(String source) =>
      FinishedManufacturingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FinishedManufacturingModel(id: $id, serial: $serial, transfer_type_name: $transfer_type_name, note: $note, items: $items)';
  }

  @override
  bool operator ==(covariant FinishedManufacturingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.serial == serial &&
        other.transfer_type_name == transfer_type_name &&
        other.note == note &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serial.hashCode ^
        transfer_type_name.hashCode ^
        note.hashCode ^
        items.hashCode;
  }
}
