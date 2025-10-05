import 'dart:convert';

import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerBasicInfoModel extends CustomerBasicInfoEntity {
  CustomerBasicInfoModel({
    super.customerName,
    super.shopName,
    super.telNumber,
    super.phone_details,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_name': customerName,
      'shop_name': shopName,
      'tel_number': telNumber,
      'phone_details': phone_details,
    };
  }

  factory CustomerBasicInfoModel.fromMap(Map<String, dynamic> map) {
    return CustomerBasicInfoModel(
      customerName:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      shopName: map['shop_name'] != null ? map['shop_name'] as String : null,
      telNumber: map['tel_number'] != null ? map['tel_number'] as String : null,
      phone_details:
          map['phone_details'] != null ? map['phone_details'] as List : null,
    );
  }

  factory CustomerBasicInfoModel.fromEntity(CustomerBasicInfoEntity entity) {
    return CustomerBasicInfoModel(
      customerName: entity.customerName,
      shopName: entity.shopName,
      telNumber: entity.telNumber,
      phone_details: entity.phone_details,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerBasicInfoModel.fromJson(String source) =>
      CustomerBasicInfoModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
