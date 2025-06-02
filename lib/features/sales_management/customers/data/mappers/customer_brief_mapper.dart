import 'package:gmcappclean/features/sales_management/customers/data/models/customer_brief_model.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_brief_entity.dart';

class CustomerBriefDataMapper {
  static CustomerBriefModel toModel({required CustomerBriefEntity entity}) {
    return CustomerBriefModel(
      id: entity.id,
      customerName: entity.customerName,
      shopName: entity.shopName,
      governate: entity.governate,
      region: entity.region,
      shopCoordinates: entity.shopCoordinates,
      address: entity.address,
    );
  }

  static CustomerBriefEntity toEntity({required CustomerBriefModel model}) {
    return CustomerBriefEntity(
      id: model.id,
      customerName: model.customerName,
      shopName: model.shopName,
      governate: model.governate,
      region: model.region,
      shopCoordinates: model.shopCoordinates,
      address: model.address,
    );
  }
}
