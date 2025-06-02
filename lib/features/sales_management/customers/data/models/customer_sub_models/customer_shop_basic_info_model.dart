import 'dart:convert';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerShopBasicInfoModel extends CustomerShopBasicInfoEntity {
  CustomerShopBasicInfoModel({
    super.shopSpace = 0,
    super.numberOfWarehouses = 0,
    super.numberOfWorkers = 0,
    super.shopStatus = false,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shop_space': shopSpace,
      'number_of_warehouses': numberOfWarehouses,
      'number_of_workers': numberOfWorkers,
      'shop_status': shopStatus,
    };
  }

  factory CustomerShopBasicInfoModel.fromMap(Map<String, dynamic> map) {
    return CustomerShopBasicInfoModel(
      shopSpace: map['shop_space'] != null ? map['shop_space'] as int : 0,
      numberOfWarehouses: map['number_of_warehouses'] != null
          ? map['number_of_warehouses'] as int
          : 0,
      numberOfWorkers: map['number_of_workers'] != null
          ? map['number_of_workers'] as int
          : 0,
      shopStatus:
          map['shop_status'] != null ? map['shop_status'] as bool : false,
    );
  }
  factory CustomerShopBasicInfoModel.fromEntity(
      CustomerShopBasicInfoEntity entity) {
    return CustomerShopBasicInfoModel(
      shopSpace: entity.shopSpace,
      numberOfWarehouses: entity.numberOfWarehouses,
      numberOfWorkers: entity.numberOfWorkers,
      shopStatus: entity.shopStatus,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerShopBasicInfoModel.fromJson(String source) =>
      CustomerShopBasicInfoModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
