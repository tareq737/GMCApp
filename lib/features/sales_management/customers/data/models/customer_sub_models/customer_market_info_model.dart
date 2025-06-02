import 'dart:convert';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerMarketInfoModel extends CustomerMarketInfoEntity {
  CustomerMarketInfoModel({
    super.clientActivityOld,
    super.responsible,
    super.customerSize = 0,
    super.clientTradeType,
    super.clientSpread,
    super.paintProffesion,
    super.dependenceOnCompany,
    super.isDirectCustomer,
    super.credFinance,
    super.credDeals,
    super.credComplains,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'client_activity_old': clientActivityOld,
      'responsible': responsible,
      'customer_size': customerSize,
      'client_trade_type': clientTradeType,
      'client_spread': clientSpread,
      'paint_proffession': paintProffesion,
      'dependence_on_company': dependenceOnCompany,
      'is_direct_customer': isDirectCustomer,
      'cred_finance': credFinance,
      'cred_deals': credDeals,
      'cred_complains': credComplains,
    };
  }

  factory CustomerMarketInfoModel.fromMap(Map<String, dynamic> map) {
    return CustomerMarketInfoModel(
      clientActivityOld: map['client_activity_old'] != null
          ? map['client_activity_old'] as String
          : null,
      responsible:
          map['responsible'] != null ? map['responsible'] as String : null,
      customerSize:
          map['customer_size'] != null ? map['customer_size'] as int : 0,
      clientTradeType: map['client_trade_type'] != null
          ? map['client_trade_type'] as String
          : null,
      clientSpread:
          map['client_spread'] != null ? map['client_spread'] as String : null,
      paintProffesion: map['paint_proffession'] != null
          ? map['paint_proffession'] as String
          : null,
      dependenceOnCompany: map['dependence_on_company'] != null
          ? map['dependence_on_company'] as String
          : null,
      isDirectCustomer: map['is_direct_customer'] != null
          ? map['is_direct_customer'] as bool
          : null,
      credFinance:
          map['cred_finance'] != null ? map['cred_finance'] as String : null,
      credDeals: map['cred_deals'] != null ? map['cred_deals'] as String : null,
      credComplains: map['cred_complains'] != null
          ? map['cred_complains'] as String
          : null,
    );
  }

  factory CustomerMarketInfoModel.fromEntity(CustomerMarketInfoEntity entity) {
    return CustomerMarketInfoModel(
      clientActivityOld: entity.clientActivityOld,
      responsible: entity.responsible,
      customerSize: entity.customerSize,
      clientSpread: entity.clientSpread,
      clientTradeType: entity.clientTradeType,
      credDeals: entity.credDeals,
      credComplains: entity.credComplains,
      credFinance: entity.credFinance,
      paintProffesion: entity.paintProffesion,
      dependenceOnCompany: entity.dependenceOnCompany,
      isDirectCustomer: entity.isDirectCustomer,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerMarketInfoModel.fromJson(String source) =>
      CustomerMarketInfoModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
