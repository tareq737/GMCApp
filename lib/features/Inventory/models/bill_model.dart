// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';

import 'package:gmcappclean/features/Inventory/models/accounts_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';

class BillModel {
  int? id;
  TransferModel? transfer;
  AccountsModel? customer;
  double? discount_rate;
  String? bill_type;
  int? customer_id;
  int? transfer_type;
  BillModel({
    this.id,
    this.transfer,
    this.customer,
    this.discount_rate,
    this.bill_type,
    this.customer_id,
    this.transfer_type,
  });

  BillModel copyWith({
    int? id,
    TransferModel? transfer,
    AccountsModel? customer,
    double? discount_rate,
    String? bill_type,
    int? customer_id,
    int? transfer_type,
  }) {
    return BillModel(
      id: id ?? this.id,
      transfer: transfer ?? this.transfer,
      customer: customer ?? this.customer,
      discount_rate: discount_rate ?? this.discount_rate,
      bill_type: bill_type ?? this.bill_type,
      customer_id: customer_id ?? this.customer_id,
      transfer_type: transfer_type ?? this.transfer_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transfer': transfer?.toMap(),
      'customer': customer?.toMap(),
      'discount_rate': discount_rate,
      'bill_type': bill_type,
      'customer_id': customer_id,
      'transfer_type': transfer_type,
    };
  }

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'] != null ? map['id'] as int : null,
      transfer: map['transfer'] != null
          ? TransferModel.fromMap(map['transfer'] as Map<String, dynamic>)
          : null,
      customer: map['customer'] != null
          ? AccountsModel.fromMap(map['customer'] as Map<String, dynamic>)
          : null,
      discount_rate:
          map['discount_rate'] != null ? map['discount_rate'] as double : null,
      bill_type: map['bill_type'] != null ? map['bill_type'] as String : null,
      customer_id:
          map['customer_id'] != null ? map['customer_id'] as int : null,
      transfer_type:
          map['transfer_type'] != null ? map['transfer_type'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillModel.fromJson(String source) =>
      BillModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BillModel(id: $id, transfer: $transfer, customer: $customer, discount_rate: $discount_rate, bill_type: $bill_type, customer_id: $customer_id, transfer_type: $transfer_type)';
  }

  @override
  bool operator ==(covariant BillModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.transfer == transfer &&
        other.customer == customer &&
        other.discount_rate == discount_rate &&
        other.bill_type == bill_type &&
        other.customer_id == customer_id &&
        other.transfer_type == transfer_type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        transfer.hashCode ^
        customer.hashCode ^
        discount_rate.hashCode ^
        bill_type.hashCode ^
        customer_id.hashCode ^
        transfer_type.hashCode;
  }
}
