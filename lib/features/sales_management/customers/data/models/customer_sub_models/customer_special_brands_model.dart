import 'dart:convert';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerSpecialBrandsModel extends CustomerSpecialBrandsEntity {
  CustomerSpecialBrandsModel({
    super.specialItemsOil,
    super.specialItemsWater,
    super.specialItemsAcrylic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'special_items_oil': specialItemsOil,
      'special_items_water': specialItemsWater,
      'special_items_acrylic': specialItemsAcrylic,
    };
  }

  factory CustomerSpecialBrandsModel.fromMap(Map<String, dynamic> map) {
    return CustomerSpecialBrandsModel(
      specialItemsOil: map['special_items_oil'] != null
          ? map['special_items_oil'] as String
          : null,
      specialItemsWater: map['special_items_water'] != null
          ? map['special_items_water'] as String
          : null,
      specialItemsAcrylic: map['special_items_acrylic'] != null
          ? map['special_items_acrylic'] as String
          : null,
    );
  }

  factory CustomerSpecialBrandsModel.fromEntity(
      CustomerSpecialBrandsEntity entity) {
    return CustomerSpecialBrandsModel(
      specialItemsOil: entity.specialItemsOil,
      specialItemsWater: entity.specialItemsWater,
      specialItemsAcrylic: entity.specialItemsAcrylic,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerSpecialBrandsModel.fromJson(String source) =>
      CustomerSpecialBrandsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
