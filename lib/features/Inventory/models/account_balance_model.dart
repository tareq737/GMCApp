// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AccountBalanceModel {
  String? debit;
  String? credit;
  String? net;
  AccountBalanceModel({
    this.debit,
    this.credit,
    this.net,
  });

  AccountBalanceModel copyWith({
    String? debit,
    String? credit,
    String? net,
  }) {
    return AccountBalanceModel(
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      net: net ?? this.net,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'debit': debit,
      'credit': credit,
      'net': net,
    };
  }

  factory AccountBalanceModel.fromMap(Map<String, dynamic> map) {
    return AccountBalanceModel(
      debit: map['debit'] != null ? map['debit'] as String : null,
      credit: map['credit'] != null ? map['credit'] as String : null,
      net: map['net'] != null ? map['net'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountBalanceModel.fromJson(String source) =>
      AccountBalanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AccountBalanceModel(debit: $debit, credit: $credit, net: $net)';

  @override
  bool operator ==(covariant AccountBalanceModel other) {
    if (identical(this, other)) return true;

    return other.debit == debit && other.credit == credit && other.net == net;
  }

  @override
  int get hashCode => debit.hashCode ^ credit.hashCode ^ net.hashCode;
}
