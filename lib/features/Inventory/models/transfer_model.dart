// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TransferModel {
  int id;
  String? from_warehouse_name;
  int? from_warehouse;
  String? to_warehouse_name;
  int? to_warehouse;
  String? note;
  String? date;
  int? transfer_type;
  int? serial;
  List<Map<String, dynamic>>? items;
  TransferModel({
    required this.id,
    this.from_warehouse_name,
    this.from_warehouse,
    this.to_warehouse_name,
    this.to_warehouse,
    this.note,
    this.date,
    this.transfer_type,
    this.serial,
    this.items,
  });

  TransferModel copyWith({
    int? id,
    String? from_warehouse_name,
    int? from_warehouse,
    String? to_warehouse_name,
    int? to_warehouse,
    String? note,
    String? date,
    int? transfer_type,
    int? serial,
    List<Map<String, dynamic>>? items,
  }) {
    return TransferModel(
      id: id ?? this.id,
      from_warehouse_name: from_warehouse_name ?? this.from_warehouse_name,
      from_warehouse: from_warehouse ?? this.from_warehouse,
      to_warehouse_name: to_warehouse_name ?? this.to_warehouse_name,
      to_warehouse: to_warehouse ?? this.to_warehouse,
      note: note ?? this.note,
      date: date ?? this.date,
      transfer_type: transfer_type ?? this.transfer_type,
      serial: serial ?? this.serial,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'from_warehouse': from_warehouse,
      'to_warehouse': to_warehouse,
      'note': note,
      'date': date,
      'transfer_type': transfer_type,
      'serial': serial,
      'items': items,
    };
  }

  factory TransferModel.fromMap(Map<String, dynamic> map) {
    return TransferModel(
      id: map['id'] as int,
      from_warehouse_name: map['from_warehouse_name'] != null
          ? map['from_warehouse_name'] as String
          : null,
      from_warehouse:
          map['from_warehouse'] != null ? map['from_warehouse'] as int : null,
      to_warehouse_name: map['to_warehouse_name'] != null
          ? map['to_warehouse_name'] as String
          : null,
      to_warehouse:
          map['to_warehouse'] != null ? map['to_warehouse'] as int : null,
      note: map['note'] != null ? map['note'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      transfer_type:
          map['transfer_type'] != null ? map['transfer_type'] as int : null,
      serial: map['serial'] != null ? map['serial'] as int : null,
      items: map['items'] != null
          ? List<Map<String, dynamic>>.from(map['items'] as List)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferModel.fromJson(String source) =>
      TransferModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransferModel(id: $id, from_warehouse_name: $from_warehouse_name, from_warehouse: $from_warehouse, to_warehouse_name: $to_warehouse_name, to_warehouse: $to_warehouse, note: $note, date: $date, transfer_type: $transfer_type, serial: $serial, items: $items)';
  }

  @override
  bool operator ==(covariant TransferModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.from_warehouse_name == from_warehouse_name &&
        other.from_warehouse == from_warehouse &&
        other.to_warehouse_name == to_warehouse_name &&
        other.to_warehouse == to_warehouse &&
        other.note == note &&
        other.date == date &&
        other.transfer_type == transfer_type &&
        other.serial == serial &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        from_warehouse_name.hashCode ^
        from_warehouse.hashCode ^
        to_warehouse_name.hashCode ^
        to_warehouse.hashCode ^
        note.hashCode ^
        date.hashCode ^
        transfer_type.hashCode ^
        serial.hashCode ^
        items.hashCode;
  }
}
