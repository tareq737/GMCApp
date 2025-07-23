// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BriefManufacturingModel {
  int id;
  int? serial;
  String? manufactured_item_name;
  String? date;
  String? batch_number;
  BriefManufacturingModel({
    required this.id,
    this.serial,
    this.manufactured_item_name,
    this.date,
    this.batch_number,
  });

  BriefManufacturingModel copyWith({
    int? id,
    int? serial,
    String? manufactured_item_name,
    String? quantity,
    String? date,
    String? batch_number,
  }) {
    return BriefManufacturingModel(
      id: id ?? this.id,
      serial: serial ?? this.serial,
      manufactured_item_name:
          manufactured_item_name ?? this.manufactured_item_name,
      date: date ?? this.date,
      batch_number: batch_number ?? this.batch_number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'serial': serial,
      'manufactured_item_name': manufactured_item_name,
      'date': date,
      'batch_number': batch_number,
    };
  }

  factory BriefManufacturingModel.fromMap(Map<String, dynamic> map) {
    return BriefManufacturingModel(
      id: map['id'] as int,
      serial: map['serial'] != null ? map['serial'] as int : null,
      manufactured_item_name: map['manufactured_item_name'] != null
          ? map['manufactured_item_name'] as String
          : null,
      date: map['date'] != null ? map['date'] as String : null,
      batch_number:
          map['batch_number'] != null ? map['batch_number'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefManufacturingModel.fromJson(String source) =>
      BriefManufacturingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefManufacturingModel(id: $id, serial: $serial, manufactured_item_name: $manufactured_item_name,  date: $date, batch_number: $batch_number)';
  }

  @override
  bool operator ==(covariant BriefManufacturingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.serial == serial &&
        other.manufactured_item_name == manufactured_item_name &&
        other.date == date &&
        other.batch_number == batch_number;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serial.hashCode ^
        manufactured_item_name.hashCode ^
        date.hashCode ^
        batch_number.hashCode;
  }
}
