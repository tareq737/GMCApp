// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gmcappclean/features/Inventory/models/account_balance_model.dart';

class AccountsModel {
  int? id;
  String? code;
  String? name;
  AccountBalanceModel? balance;
  String? account_name;
  AccountsModel({
    this.id,
    this.code,
    this.name,
    this.balance,
    this.account_name,
  });

  AccountsModel copyWith({
    int? id,
    String? code,
    String? name,
    AccountBalanceModel? balance,
    String? account_name,
  }) {
    return AccountsModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      account_name: account_name ?? this.account_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'balance': balance?.toMap(),
      'account_name': account_name,
    };
  }

  factory AccountsModel.fromMap(Map<String, dynamic> map) {
    return AccountsModel(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      balance: map['balance'] != null
          ? AccountBalanceModel.fromMap(map['balance'] as Map<String, dynamic>)
          : null,
      account_name:
          map['account_name'] != null ? map['account_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountsModel.fromJson(String source) =>
      AccountsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccountsModel(id: $id, code: $code, name: $name, balance: $balance, account_name: $account_name)';
  }

  @override
  bool operator ==(covariant AccountsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.balance == balance &&
        other.account_name == account_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        balance.hashCode ^
        account_name.hashCode;
  }
}
