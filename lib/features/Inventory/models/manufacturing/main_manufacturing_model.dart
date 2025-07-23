// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gmcappclean/features/Inventory/models/manufacturing/finished_items_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/finished_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/raw_manufacturing_model.dart';

class MainManufacturingModel {
  int? id;
  int? serial;
  String? date;
  String? note;
  int? raw_warehouse;
  int? finished_warehouse;
  RawManufacturingModel? rawManufacturingModel;
  FinishedManufacturingModel? finishedItemsManufacturingModel;
  String? manufactured_item_name;
  int? manufactured_item;
  String? raw_warehouse_name;
  String? finished_warehouse_name;
  int? batch_number;
  int? batch_level;
  String? batch_code;
  MainManufacturingModel({
    this.id,
    this.serial,
    this.date,
    this.note,
    this.raw_warehouse,
    this.finished_warehouse,
    this.rawManufacturingModel,
    this.finishedItemsManufacturingModel,
    this.manufactured_item_name,
    this.manufactured_item,
    this.raw_warehouse_name,
    this.finished_warehouse_name,
    this.batch_number,
    this.batch_level,
    this.batch_code,
  });

  MainManufacturingModel copyWith({
    int? id,
    int? serial,
    String? date,
    String? note,
    int? raw_warehouse,
    int? finished_warehouse,
    RawManufacturingModel? rawManufacturingModel,
    FinishedManufacturingModel? finishedItemsManufacturingModel,
    String? manufactured_item_name,
    int? manufactured_item,
    String? raw_warehouse_name,
    String? finished_warehouse_name,
    int? batch_number,
    int? batch_level,
    String? batch_code,
  }) {
    return MainManufacturingModel(
      id: id ?? this.id,
      serial: serial ?? this.serial,
      date: date ?? this.date,
      note: note ?? this.note,
      raw_warehouse: raw_warehouse ?? this.raw_warehouse,
      finished_warehouse: finished_warehouse ?? this.finished_warehouse,
      rawManufacturingModel:
          rawManufacturingModel ?? this.rawManufacturingModel,
      finishedItemsManufacturingModel: finishedItemsManufacturingModel ??
          this.finishedItemsManufacturingModel,
      manufactured_item_name:
          manufactured_item_name ?? this.manufactured_item_name,
      manufactured_item: manufactured_item ?? this.manufactured_item,
      raw_warehouse_name: raw_warehouse_name ?? this.raw_warehouse_name,
      finished_warehouse_name:
          finished_warehouse_name ?? this.finished_warehouse_name,
      batch_number: batch_number ?? this.batch_number,
      batch_level: batch_level ?? this.batch_level,
      batch_code: batch_code ?? this.batch_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'serial': serial,
      'date': date,
      'note': note,
      'raw_warehouse': raw_warehouse,
      'finished_warehouse': finished_warehouse,
      'raw_items':
          rawManufacturingModel?.items?.map((item) => item.toMap()).toList(),
      'fg_items': finishedItemsManufacturingModel?.items
          ?.map((item) => item.toMap())
          .toList(),
      'manufactured_item': manufactured_item,
      'batch_number': batch_number,
      'batch_level': batch_level,
    };
  }

  factory MainManufacturingModel.fromMap(Map<String, dynamic> map) {
    return MainManufacturingModel(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      serial:
          map['serial'] != null ? int.tryParse(map['serial'].toString()) : null,
      date: map['date']?.toString(),
      note: map['note']?.toString(),
      raw_warehouse: map['raw_warehouse'] != null
          ? int.tryParse(map['raw_warehouse'].toString())
          : null,
      finished_warehouse: map['finished_warehouse'] != null
          ? int.tryParse(map['finished_warehouse'].toString())
          : null,
      rawManufacturingModel: map['raw_transfer'] != null
          ? RawManufacturingModel.fromMap(
              map['raw_transfer'] as Map<String, dynamic>)
          : null,
      finishedItemsManufacturingModel: map['finished_transfer'] != null
          ? FinishedManufacturingModel.fromMap(
              map['finished_transfer'] as Map<String, dynamic>)
          : null,
      manufactured_item_name: map['manufactured_item_name']?.toString(),
      manufactured_item: map['manufactured_item'] != null
          ? int.tryParse(map['manufactured_item'].toString())
          : null,
      raw_warehouse_name: map['raw_warehouse_name']?.toString(),
      finished_warehouse_name: map['finished_warehouse_name']?.toString(),
      batch_number: map['batch_number'] != null
          ? int.tryParse(map['batch_number'].toString())
          : null,
      batch_level: map['batch_level'] != null
          ? int.tryParse(map['batch_level'].toString())
          : null,
      batch_code: map['batch_code']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MainManufacturingModel.fromJson(String source) =>
      MainManufacturingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MainManufacturingModel(id: $id, serial: $serial, date: $date, note: $note, raw_warehouse: $raw_warehouse, finished_warehouse: $finished_warehouse, rawManufacturingModel: $rawManufacturingModel, finishedItemsManufacturingModel: $finishedItemsManufacturingModel, manufactured_item_name: $manufactured_item_name, manufactured_item: $manufactured_item, raw_warehouse_name: $raw_warehouse_name, finished_warehouse_name: $finished_warehouse_name, batch_number: $batch_number, batch_level: $batch_level, batch_code: $batch_code)';
  }

  @override
  bool operator ==(covariant MainManufacturingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.serial == serial &&
        other.date == date &&
        other.note == note &&
        other.raw_warehouse == raw_warehouse &&
        other.finished_warehouse == finished_warehouse &&
        other.rawManufacturingModel == rawManufacturingModel &&
        other.finishedItemsManufacturingModel ==
            finishedItemsManufacturingModel &&
        other.manufactured_item_name == manufactured_item_name &&
        other.manufactured_item == manufactured_item &&
        other.raw_warehouse_name == raw_warehouse_name &&
        other.finished_warehouse_name == finished_warehouse_name &&
        other.batch_number == batch_number &&
        other.batch_level == batch_level &&
        other.batch_code == batch_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serial.hashCode ^
        date.hashCode ^
        note.hashCode ^
        raw_warehouse.hashCode ^
        finished_warehouse.hashCode ^
        rawManufacturingModel.hashCode ^
        finishedItemsManufacturingModel.hashCode ^
        manufactured_item_name.hashCode ^
        manufactured_item.hashCode ^
        raw_warehouse_name.hashCode ^
        finished_warehouse_name.hashCode ^
        batch_number.hashCode ^
        batch_level.hashCode ^
        batch_code.hashCode;
  }
}
