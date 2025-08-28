// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashflowBalanceModel {
  double latest_balance;
  CashflowBalanceModel({
    required this.latest_balance,
  });

  CashflowBalanceModel copyWith({
    double? latest_balance,
  }) {
    return CashflowBalanceModel(
      latest_balance: latest_balance ?? this.latest_balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latest_balance': latest_balance,
    };
  }

  factory CashflowBalanceModel.fromMap(Map<String, dynamic> map) {
    return CashflowBalanceModel(
      latest_balance: map['latest_balance'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashflowBalanceModel.fromJson(String source) =>
      CashflowBalanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CashflowBalanceModel(latest_balance: $latest_balance)';

  @override
  bool operator ==(covariant CashflowBalanceModel other) {
    if (identical(this, other)) return true;

    return other.latest_balance == latest_balance;
  }

  @override
  int get hashCode => latest_balance.hashCode;
}
