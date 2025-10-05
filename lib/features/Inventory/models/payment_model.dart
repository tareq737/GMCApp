// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentModel {
  int? id;
  String? date;
  String? amount;
  int? customer;
  String? customer_name;
  int? bill;
  String? note;
  int? account_paid_into;
  String? account_paid_into_name;
  PaymentModel({
    this.id,
    this.date,
    this.amount,
    this.customer,
    this.customer_name,
    this.bill,
    this.note,
    this.account_paid_into,
    this.account_paid_into_name,
  });

  PaymentModel copyWith({
    int? id,
    String? date,
    String? amount,
    int? customer,
    String? customer_name,
    int? bill,
    String? note,
    int? account_paid_into,
    String? account_paid_into_name,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      customer: customer ?? this.customer,
      customer_name: customer_name ?? this.customer_name,
      bill: bill ?? this.bill,
      note: note ?? this.note,
      account_paid_into: account_paid_into ?? this.account_paid_into,
      account_paid_into_name:
          account_paid_into_name ?? this.account_paid_into_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'amount': amount,
      'customer': customer,
      'bill': bill,
      'note': note,
      'account_paid_into': account_paid_into,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] != null ? map['id'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      customer: map['customer'] != null ? map['customer'] as int : null,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      bill: map['bill'] != null ? map['bill'] as int : null,
      note: map['note'] != null ? map['note'] as String : null,
      account_paid_into: map['account_paid_into'] != null
          ? map['account_paid_into'] as int
          : null,
      account_paid_into_name: map['account_paid_into_name'] != null
          ? map['account_paid_into_name'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentModel(id: $id, date: $date, amount: $amount, customer: $customer, customer_name: $customer_name, bill: $bill, note: $note, account_paid_into: $account_paid_into, account_paid_into_name: $account_paid_into_name)';
  }

  @override
  bool operator ==(covariant PaymentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.amount == amount &&
        other.customer == customer &&
        other.customer_name == customer_name &&
        other.bill == bill &&
        other.note == note &&
        other.account_paid_into == account_paid_into &&
        other.account_paid_into_name == account_paid_into_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        amount.hashCode ^
        customer.hashCode ^
        customer_name.hashCode ^
        bill.hashCode ^
        note.hashCode ^
        account_paid_into.hashCode ^
        account_paid_into_name.hashCode;
  }
}
