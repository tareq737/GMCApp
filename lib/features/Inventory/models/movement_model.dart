// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MovementModel {
  String? date;
  String? quantity;
  String? direction;
  String? balance;
  String? note;
  String? warehouse;
  int? transfer_serial;
  String? transfer_type;
  MovementModel({
    this.date,
    this.quantity,
    this.direction,
    this.balance,
    this.note,
    this.warehouse,
    this.transfer_serial,
    this.transfer_type,
  });

  MovementModel copyWith({
    String? date,
    String? quantity,
    String? direction,
    String? balance,
    String? note,
    String? warehouse,
    int? transfer_serial,
    String? transfer_type,
  }) {
    return MovementModel(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      direction: direction ?? this.direction,
      balance: balance ?? this.balance,
      note: note ?? this.note,
      warehouse: warehouse ?? this.warehouse,
      transfer_serial: transfer_serial ?? this.transfer_serial,
      transfer_type: transfer_type ?? this.transfer_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'quantity': quantity,
      'direction': direction,
      'balance': balance,
      'note': note,
      'warehouse': warehouse,
      'transfer_serial': transfer_serial,
      'transfer_type': transfer_type,
    };
  }

  factory MovementModel.fromMap(Map<String, dynamic> map) {
    return MovementModel(
      date: map['date'] != null ? map['date'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as String : null,
      direction: map['direction'] != null ? map['direction'] as String : null,
      balance: map['balance'] != null ? map['balance'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      warehouse: map['warehouse'] != null ? map['warehouse'] as String : null,
      transfer_serial:
          map['transfer_serial'] != null ? map['transfer_serial'] as int : null,
      transfer_type:
          map['transfer_type'] != null ? map['transfer_type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovementModel.fromJson(String source) =>
      MovementModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MovementModel(date: $date, quantity: $quantity, direction: $direction, balance: $balance, note: $note, warehouse: $warehouse, transfer_serial: $transfer_serial, transfer_type: $transfer_type)';
  }

  @override
  bool operator ==(covariant MovementModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.quantity == quantity &&
        other.direction == direction &&
        other.balance == balance &&
        other.note == note &&
        other.warehouse == warehouse &&
        other.transfer_serial == transfer_serial &&
        other.transfer_type == transfer_type;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        quantity.hashCode ^
        direction.hashCode ^
        balance.hashCode ^
        note.hashCode ^
        warehouse.hashCode ^
        transfer_serial.hashCode ^
        transfer_type.hashCode;
  }
}
