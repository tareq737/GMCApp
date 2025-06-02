import 'dart:convert';

import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerMethodsOfDealingModel extends CustomerMethodsOfDealingEntity {
  CustomerMethodsOfDealingModel({
    super.methodCash = false,
    super.methodPayments = false,
    super.methodOffers = false,
    super.methodCustody = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'method_cash': methodCash,
      'method_payments': methodPayments,
      'method_offers': methodOffers,
      'method_custody': methodCustody,
    };
  }

  factory CustomerMethodsOfDealingModel.fromMap(Map<String, dynamic> map) {
    return CustomerMethodsOfDealingModel(
      methodCash:
          map['method_cash'] != null ? map['method_cash'] as bool : false,
      methodPayments: map['method_payments'] != null
          ? map['method_payments'] as bool
          : false,
      methodOffers:
          map['method_offers'] != null ? map['method_offers'] as bool : false,
      methodCustody:
          map['method_custody'] != null ? map['method_custody'] as bool : false,
    );
  }
  factory CustomerMethodsOfDealingModel.fromEntity(
      CustomerMethodsOfDealingEntity entity) {
    return CustomerMethodsOfDealingModel(
      methodCash: entity.methodCash,
      methodPayments: entity.methodPayments,
      methodCustody: entity.methodCustody,
      methodOffers: entity.methodOffers,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerMethodsOfDealingModel.fromJson(String source) =>
      CustomerMethodsOfDealingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
