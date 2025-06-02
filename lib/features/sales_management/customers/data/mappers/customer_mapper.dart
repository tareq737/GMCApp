import 'package:gmcappclean/features/sales_management/customers/data/models/barrel_models.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerDataMapper {
  static CustomerEntity toEntity({required CustomerModel model}) {
    return CustomerEntity(
      id: model.id,
      address: model.address,
      basicInfo: model.basicInfo,
      personalInfo: model.personalInfo,
      shopBasicInfo: model.shopBasicInfo,
      discounts: model.discounts,
      marketInfo: model.marketInfo,
      methodsOfDealing: model.methodsOfDealing,
      activity: model.activity,
      specialBrands: model.specialBrands,
      notes: model.notes,
    );
  }

  static CustomerModel toModel({required CustomerEntity entity}) {
    return CustomerModel(
      id: entity.id,
      address: CustomerAddressModel.fromEntity(entity.address),
      basicInfo: CustomerBasicInfoModel.fromEntity(entity.basicInfo),
      personalInfo: CustomerPersonalInfoModel.fromEntity(entity.personalInfo),
      shopBasicInfo:
          CustomerShopBasicInfoModel.fromEntity(entity.shopBasicInfo),
      discounts: CustomerDiscountsModel.fromEntity(entity.discounts),
      marketInfo: CustomerMarketInfoModel.fromEntity(entity.marketInfo),
      methodsOfDealing:
          CustomerMethodsOfDealingModel.fromEntity(entity.methodsOfDealing),
      activity: CustomerActivityModel.fromEntity(entity.activity),
      specialBrands:
          CustomerSpecialBrandsModel.fromEntity(entity.specialBrands),
      notes: entity.notes,
    );
  }
}
