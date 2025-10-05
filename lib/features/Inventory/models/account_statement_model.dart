// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AccountStatementModel {
  String? type;
  String? date;
  double? amount;
  int? serial;
  int? bill_id;
  String? account_paid_into;
  int? payment_id;
  AccountStatementModel({
    this.type,
    this.date,
    this.amount,
    this.serial,
    this.bill_id,
    this.account_paid_into,
    this.payment_id,
  });

  AccountStatementModel copyWith({
    String? type,
    String? date,
    double? amount,
    int? serial,
    int? bill_id,
    String? account_paid_into,
    int? payment_id,
  }) {
    return AccountStatementModel(
      type: type ?? this.type,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      serial: serial ?? this.serial,
      bill_id: bill_id ?? this.bill_id,
      account_paid_into: account_paid_into ?? this.account_paid_into,
      payment_id: payment_id ?? this.payment_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'date': date,
      'amount': amount,
      'serial': serial,
      'bill_id': bill_id,
      'account_paid_into': account_paid_into,
      'payment_id': payment_id,
    };
  }

  factory AccountStatementModel.fromMap(Map<String, dynamic> map) {
    return AccountStatementModel(
      type: map['type'] != null ? map['type'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
      serial: map['serial'] != null ? map['serial'] as int : null,
      bill_id: map['bill_id'] != null ? map['bill_id'] as int : null,
      account_paid_into: map['account_paid_into'] != null
          ? map['account_paid_into'] as String
          : null,
      payment_id: map['payment_id'] != null ? map['payment_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountStatementModel.fromJson(String source) =>
      AccountStatementModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccountStatementModel(type: $type, date: $date, amount: $amount, serial: $serial, bill_id: $bill_id, account_paid_into: $account_paid_into, payment_id: $payment_id)';
  }

  @override
  bool operator ==(covariant AccountStatementModel other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.date == date &&
        other.amount == amount &&
        other.serial == serial &&
        other.bill_id == bill_id &&
        other.account_paid_into == account_paid_into &&
        other.payment_id == payment_id;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        date.hashCode ^
        amount.hashCode ^
        serial.hashCode ^
        bill_id.hashCode ^
        account_paid_into.hashCode ^
        payment_id.hashCode;
  }
}
