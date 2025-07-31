// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gmcappclean/features/statistics/models/maintenance.dart';
import 'package:gmcappclean/features/statistics/models/production.dart';
import 'package:gmcappclean/features/statistics/models/purchases.dart';
import 'package:gmcappclean/features/statistics/models/sales.dart';

class StatisticsModel {
  Sales? sales;
  Production? production;
  Purchases? purchases;
  Maintenance? maintenance;
  StatisticsModel({
    this.sales,
    this.production,
    this.purchases,
    this.maintenance,
  });

  StatisticsModel copyWith({
    Sales? sales,
    Production? production,
    Purchases? purchases,
    Maintenance? maintenance,
  }) {
    return StatisticsModel(
      sales: sales ?? this.sales,
      production: production ?? this.production,
      purchases: purchases ?? this.purchases,
      maintenance: maintenance ?? this.maintenance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sales': sales?.toMap(),
      'production': production?.toMap(),
      'purchases': purchases?.toMap(),
      'maintenance': maintenance?.toMap(),
    };
  }

  factory StatisticsModel.fromMap(Map<String, dynamic> map) {
    return StatisticsModel(
      sales: map['sales'] != null
          ? Sales.fromMap(map['sales'] as Map<String, dynamic>)
          : null,
      production: map['production'] != null
          ? Production.fromMap(map['production'] as Map<String, dynamic>)
          : null,
      purchases: map['purchases'] != null
          ? Purchases.fromMap(map['purchases'] as Map<String, dynamic>)
          : null,
      maintenance: map['maintenance'] != null
          ? Maintenance.fromMap(map['maintenance'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsModel.fromJson(String source) =>
      StatisticsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatisticsModel(sales: $sales, production: $production, purchases: $purchases, maintenance: $maintenance)';
  }

  @override
  bool operator ==(covariant StatisticsModel other) {
    if (identical(this, other)) return true;

    return other.sales == sales &&
        other.production == production &&
        other.purchases == purchases &&
        other.maintenance == maintenance;
  }

  @override
  int get hashCode {
    return sales.hashCode ^
        production.hashCode ^
        purchases.hashCode ^
        maintenance.hashCode;
  }
}
