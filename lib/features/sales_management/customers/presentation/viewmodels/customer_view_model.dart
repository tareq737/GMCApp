// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerViewModel {
  int id;
  CustomerAddressEntity address;
  CustomerBasicInfoEntity basicInfo;
  CustomerPersonalInfoEntity personalInfo;
  CustomerShopBasicInfoEntity shopBasicInfo;
  CustomerDiscountsEntity discounts;
  CustomerMarketInfoEntity marketInfo;
  CustomerMethodsOfDealingEntity methodsOfDealing;
  CustomerActivityEntity activity;
  CustomerSpecialBrandsEntity specialBrands;
  String? notes;
  CustomerViewModel({
    required this.id,
    CustomerAddressEntity? address,
    CustomerBasicInfoEntity? basicInfo,
    CustomerPersonalInfoEntity? personalInfo,
    CustomerShopBasicInfoEntity? shopBasicInfo,
    CustomerDiscountsEntity? discounts,
    CustomerMarketInfoEntity? marketInfo,
    CustomerMethodsOfDealingEntity? methodsOfDealing,
    CustomerActivityEntity? activity,
    CustomerSpecialBrandsEntity? specialBrands,
    this.notes,
  })  : address = address ?? CustomerAddressEntity(),
        basicInfo = basicInfo ?? CustomerBasicInfoEntity(),
        personalInfo = personalInfo ?? CustomerPersonalInfoEntity(),
        shopBasicInfo = shopBasicInfo ?? CustomerShopBasicInfoEntity(),
        discounts = discounts ?? CustomerDiscountsEntity(),
        marketInfo = marketInfo ?? CustomerMarketInfoEntity(),
        methodsOfDealing = methodsOfDealing ?? CustomerMethodsOfDealingEntity(),
        activity = activity ?? CustomerActivityEntity(),
        specialBrands = specialBrands ?? CustomerSpecialBrandsEntity();
}
