// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransferBriefModel {
  int id;
  String? from_warehouse_name;
  String? to_warehouse_name;
  String? note;
  String? date;
  int? serial;
  String? account_name;
  TransferBriefModel({
    required this.id,
    this.from_warehouse_name,
    this.to_warehouse_name,
    this.note,
    this.date,
    this.serial,
    this.account_name,
  });

  TransferBriefModel copyWith({
    int? id,
    String? from_warehouse_name,
    String? to_warehouse_name,
    String? note,
    String? date,
    int? serial,
    String? account_name,
  }) {
    return TransferBriefModel(
      id: id ?? this.id,
      from_warehouse_name: from_warehouse_name ?? this.from_warehouse_name,
      to_warehouse_name: to_warehouse_name ?? this.to_warehouse_name,
      note: note ?? this.note,
      date: date ?? this.date,
      serial: serial ?? this.serial,
      account_name: account_name ?? this.account_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'from_warehouse_name': from_warehouse_name,
      'to_warehouse_name': to_warehouse_name,
      'note': note,
      'date': date,
      'serial': serial,
      'account_name': account_name,
    };
  }

  factory TransferBriefModel.fromMap(Map<String, dynamic> map) {
    return TransferBriefModel(
      id: map['id'] as int,
      from_warehouse_name: map['from_warehouse_name'] != null
          ? map['from_warehouse_name'] as String
          : null,
      to_warehouse_name: map['to_warehouse_name'] != null
          ? map['to_warehouse_name'] as String
          : null,
      note: map['note'] != null ? map['note'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      serial: map['serial'] != null ? map['serial'] as int : null,
      account_name:
          map['account_name'] != null ? map['account_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferBriefModel.fromJson(String source) =>
      TransferBriefModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransferBriefModel(id: $id, from_warehouse_name: $from_warehouse_name, to_warehouse_name: $to_warehouse_name, note: $note, date: $date, serial: $serial, account_name: $account_name)';
  }

  @override
  bool operator ==(covariant TransferBriefModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.from_warehouse_name == from_warehouse_name &&
        other.to_warehouse_name == to_warehouse_name &&
        other.note == note &&
        other.date == date &&
        other.serial == serial &&
        other.account_name == account_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        from_warehouse_name.hashCode ^
        to_warehouse_name.hashCode ^
        note.hashCode ^
        date.hashCode ^
        serial.hashCode ^
        account_name.hashCode;
  }
}
