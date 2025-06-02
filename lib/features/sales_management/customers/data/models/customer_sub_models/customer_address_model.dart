import 'dart:convert';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerAddressModel extends CustomerAddressEntity {
  CustomerAddressModel({
    super.address,
    super.governate,
    super.region,
    super.shopCoordinates,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'governate': governate,
      'region': region,
      'shop_coordinates': shopCoordinates,
    };
  }

  factory CustomerAddressModel.fromMap(Map<String, dynamic> map) {
    return CustomerAddressModel(
      address: map['address'] != null ? map['address'] as String : null,
      governate: map['governate'] != null ? map['governate'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      shopCoordinates: map['shop_coordinates'] != null
          ? map['shop_coordinates'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerAddressModel.fromJson(String source) =>
      CustomerAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CustomerAddressModel.fromEntity(CustomerAddressEntity entity) {
    return CustomerAddressModel(
      address: entity.address,
      governate: entity.governate,
      region: entity.region,
      shopCoordinates: entity.shopCoordinates,
    );
  }
}
