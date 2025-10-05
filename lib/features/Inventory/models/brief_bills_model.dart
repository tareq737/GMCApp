import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class BriefBillsModel {
  int? id;
  String? serial;
  String? from_warehouse_name;
  String? to_warehouse_name;
  String? customer_name;
  String? date;
  String? total_amount;
  int? transfer_type;
  String? bill_type;
  String? transfer_type_name;
  BriefBillsModel({
    this.id,
    this.serial,
    this.from_warehouse_name,
    this.to_warehouse_name,
    this.customer_name,
    this.date,
    this.total_amount,
    this.transfer_type,
    this.bill_type,
    this.transfer_type_name,
  });

  BriefBillsModel copyWith({
    int? id,
    String? serial,
    String? from_warehouse_name,
    String? to_warehouse_name,
    String? customer_name,
    String? date,
    String? total_amount,
    int? transfer_type,
    String? bill_type,
    String? transfer_type_name,
  }) {
    return BriefBillsModel(
      id: id ?? this.id,
      serial: serial ?? this.serial,
      from_warehouse_name: from_warehouse_name ?? this.from_warehouse_name,
      to_warehouse_name: to_warehouse_name ?? this.to_warehouse_name,
      customer_name: customer_name ?? this.customer_name,
      date: date ?? this.date,
      total_amount: total_amount ?? this.total_amount,
      transfer_type: transfer_type ?? this.transfer_type,
      bill_type: bill_type ?? this.bill_type,
      transfer_type_name: transfer_type_name ?? this.transfer_type_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'serial': serial,
      'from_warehouse_name': from_warehouse_name,
      'to_warehouse_name': to_warehouse_name,
      'customer_name': customer_name,
      'date': date,
      'total_amount': total_amount,
      'transfer_type': transfer_type,
      'bill_type': bill_type,
      'transfer_type_name': transfer_type_name,
    };
  }

  factory BriefBillsModel.fromMap(Map<String, dynamic> map) {
    return BriefBillsModel(
      id: map['id'] != null ? map['id'] as int : null,
      serial: map['serial'] != null ? map['serial'] as String : null,
      from_warehouse_name: map['from_warehouse_name'] != null
          ? map['from_warehouse_name'] as String
          : null,
      to_warehouse_name: map['to_warehouse_name'] != null
          ? map['to_warehouse_name'] as String
          : null,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      total_amount:
          map['total_amount'] != null ? map['total_amount'] as String : null,
      transfer_type:
          map['transfer_type'] != null ? map['transfer_type'] as int : null,
      bill_type: map['bill_type'] != null ? map['bill_type'] as String : null,
      transfer_type_name: map['transfer_type_name'] != null
          ? map['transfer_type_name'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefBillsModel.fromJson(String source) =>
      BriefBillsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefBillsModel(id: $id, serial: $serial, from_warehouse_name: $from_warehouse_name, to_warehouse_name: $to_warehouse_name, customer_name: $customer_name, date: $date, total_amount: $total_amount, transfer_type: $transfer_type, bill_type: $bill_type, transfer_type_name: $transfer_type_name)';
  }

  @override
  bool operator ==(covariant BriefBillsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.serial == serial &&
        other.from_warehouse_name == from_warehouse_name &&
        other.to_warehouse_name == to_warehouse_name &&
        other.customer_name == customer_name &&
        other.date == date &&
        other.total_amount == total_amount &&
        other.transfer_type == transfer_type &&
        other.bill_type == bill_type &&
        other.transfer_type_name == transfer_type_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serial.hashCode ^
        from_warehouse_name.hashCode ^
        to_warehouse_name.hashCode ^
        customer_name.hashCode ^
        date.hashCode ^
        total_amount.hashCode ^
        transfer_type.hashCode ^
        bill_type.hashCode ^
        transfer_type_name.hashCode;
  }
}
