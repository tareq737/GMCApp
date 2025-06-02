// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'customer_sub_models/barrel_customer_sub_models.dart';

class CustomerModel {
  int id;
  CustomerAddressModel address;
  CustomerBasicInfoModel basicInfo;
  CustomerPersonalInfoModel personalInfo;
  CustomerShopBasicInfoModel shopBasicInfo;
  CustomerDiscountsModel discounts;
  CustomerMarketInfoModel marketInfo;
  CustomerMethodsOfDealingModel methodsOfDealing;
  CustomerActivityModel activity;
  CustomerSpecialBrandsModel specialBrands;
  String? notes;
  CustomerModel({
    required this.id,
    CustomerAddressModel? address,
    CustomerBasicInfoModel? basicInfo,
    CustomerPersonalInfoModel? personalInfo,
    CustomerShopBasicInfoModel? shopBasicInfo,
    CustomerDiscountsModel? discounts,
    CustomerMarketInfoModel? marketInfo,
    CustomerMethodsOfDealingModel? methodsOfDealing,
    CustomerActivityModel? activity,
    CustomerSpecialBrandsModel? specialBrands,
    this.notes,
  })  : address = address ?? CustomerAddressModel(),
        basicInfo = basicInfo ?? CustomerBasicInfoModel(),
        personalInfo = personalInfo ?? CustomerPersonalInfoModel(),
        shopBasicInfo = shopBasicInfo ?? CustomerShopBasicInfoModel(),
        discounts = discounts ?? CustomerDiscountsModel(),
        marketInfo = marketInfo ?? CustomerMarketInfoModel(),
        methodsOfDealing = methodsOfDealing ?? CustomerMethodsOfDealingModel(),
        activity = activity ?? CustomerActivityModel(),
        specialBrands = specialBrands ?? CustomerSpecialBrandsModel();

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as int,
      address: CustomerAddressModel.fromMap(map),
      basicInfo: CustomerBasicInfoModel.fromMap(map),
      personalInfo: CustomerPersonalInfoModel.fromMap(map),
      shopBasicInfo: CustomerShopBasicInfoModel.fromMap(map),
      discounts: CustomerDiscountsModel.fromMap(map),
      marketInfo: CustomerMarketInfoModel.fromMap(map),
      methodsOfDealing: CustomerMethodsOfDealingModel.fromMap(map),
      activity: CustomerActivityModel.fromMap(map),
      specialBrands: CustomerSpecialBrandsModel.fromMap(map),
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'notes': notes,
    };
    map.addAll(address.toMap());
    map.addAll(basicInfo.toMap());
    map.addAll(personalInfo.toMap());
    map.addAll(shopBasicInfo.toMap());
    map.addAll(discounts.toMap());
    map.addAll(marketInfo.toMap());
    map.addAll(methodsOfDealing.toMap());
    map.addAll(activity.toMap());
    map.addAll(specialBrands.toMap());
    return map;
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) {
    return CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
