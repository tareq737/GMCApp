import 'dart:convert';

import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerDiscountsModel extends CustomerDiscountsEntity {
  CustomerDiscountsModel({
    super.staticDiscount = 0.0,
    super.monthDiscount = 0.0,
    super.yearDiscount = 0.0,
    super.giftOnQuantity,
    super.giftOnValue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'static_discount': staticDiscount,
      'month_discount': monthDiscount,
      'year_discount': yearDiscount,
      'gift_on_quantity': giftOnQuantity,
      'gift_on_value': giftOnValue,
    };
  }

  factory CustomerDiscountsModel.fromMap(Map<String, dynamic> map) {
    return CustomerDiscountsModel(
      staticDiscount: map['static_discount'] != null
          ? map['static_discount'] as double
          : 0.0,
      monthDiscount:
          map['month_discount'] != null ? map['month_discount'] as double : 0.0,
      yearDiscount:
          map['year_discount'] != null ? map['year_discount'] as double : 0.0,
      giftOnQuantity: map['gift_on_quantity'] != null
          ? map['gift_on_quantity'] as String
          : null,
      giftOnValue:
          map['gift_on_value'] != null ? map['gift_on_value'] as String : null,
    );
  }

  factory CustomerDiscountsModel.fromEntity(CustomerDiscountsEntity entity) {
    return CustomerDiscountsModel(
      staticDiscount: entity.staticDiscount,
      monthDiscount: entity.monthDiscount,
      yearDiscount: entity.yearDiscount,
      giftOnQuantity: entity.giftOnQuantity,
      giftOnValue: entity.giftOnValue,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDiscountsModel.fromJson(String source) =>
      CustomerDiscountsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
