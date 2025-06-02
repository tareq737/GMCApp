import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_brief_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';

class CustomerBriefPresentationMapper {
  static CustomerBriefViewModel toViewModel(
      {required CustomerBriefEntity entity}) {
    return CustomerBriefViewModel(
        id: entity.id,
        customerName: entity.customerName,
        shopName: entity.shopName,
        governate: entity.governate,
        region: entity.region,
        address: entity.address,
        shopCoordinates: entity.shopCoordinates);
  }

  static CustomerBriefEntity toEntity(
      {required CustomerBriefViewModel viewModel}) {
    return CustomerBriefEntity(
        address: viewModel.address,
        id: viewModel.id,
        customerName: viewModel.customerName,
        shopName: viewModel.shopName,
        governate: viewModel.governate,
        region: viewModel.region,
        shopCoordinates: viewModel.shopCoordinates);
  }
}
