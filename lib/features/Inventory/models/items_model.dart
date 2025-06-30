// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

// Example ItemsModel.dart (ensure your actual file has this)
class ItemsModel {
  int id; // Now required
  String? code;
  String? name;
  String? unit;
  String? min_limit;
  String? max_limit;
  int? group;
  String? group_code_name;
  List<dynamic>? default_price;
  List<dynamic>? balances;

  ItemsModel({
    required this.id, // Made required
    this.code,
    this.name,
    this.unit,
    this.min_limit,
    this.max_limit,
    this.group,
    this.group_code_name,
    this.default_price,
    this.balances,
  });

  ItemsModel copyWith({
    int? id,
    String? code,
    String? name,
    String? unit,
    String? min_limit,
    String? max_limit,
    int? group,
    String? group_code_name,
    List<dynamic>? default_price,
    List<dynamic>? balances,
  }) {
    return ItemsModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      min_limit: min_limit ?? this.min_limit,
      max_limit: max_limit ?? this.max_limit,
      group: group ?? this.group,
      group_code_name: group_code_name ?? this.group_code_name,
      default_price: default_price ?? this.default_price,
      balances: balances ?? this.balances,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'unit': unit,
      'min_limit': min_limit,
      'max_limit': max_limit,
      'group': group,
      'group_code_name': group_code_name,
      'default_price': default_price,
      'balances': balances,
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      min_limit: map['min_limit'] != null ? map['min_limit'] as String : null,
      max_limit: map['max_limit'] != null ? map['max_limit'] as String : null,
      group: map['group'] != null ? map['group'] as int : null,
      group_code_name: map['group_code_name'] != null
          ? map['group_code_name'] as String
          : null,
      default_price: map['default_price'] != null
          ? List<dynamic>.from(map['default_price'] as List)
          : null,
      balances: map['balances'] != null
          ? List<dynamic>.from(map['balances'] as List)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsModel.fromJson(String source) =>
      ItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemsModel(id: $id, code: $code, name: $name, unit: $unit, min_limit: $min_limit, max_limit: $max_limit, group: $group, group_code_name: $group_code_name, default_price: $default_price, balances: $balances)';
  }

  @override
  bool operator ==(covariant ItemsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.unit == unit &&
        other.min_limit == min_limit &&
        other.max_limit == max_limit &&
        other.group == group &&
        other.group_code_name == group_code_name &&
        listEquals(other.default_price, default_price) &&
        listEquals(other.balances, balances);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        unit.hashCode ^
        min_limit.hashCode ^
        max_limit.hashCode ^
        group.hashCode ^
        group_code_name.hashCode ^
        default_price.hashCode ^
        balances.hashCode;
  }
}
