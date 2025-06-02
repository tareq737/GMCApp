import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';

class CustomerPresentationMapper {
  static CustomerEntity toEntity({required CustomerViewModel viewModel}) {
    return CustomerEntity(
      id: viewModel.id,
      address: viewModel.address,
      basicInfo: viewModel.basicInfo,
      personalInfo: viewModel.personalInfo,
      shopBasicInfo: viewModel.shopBasicInfo,
      discounts: viewModel.discounts,
      marketInfo: viewModel.marketInfo,
      methodsOfDealing: viewModel.methodsOfDealing,
      activity: viewModel.activity,
      specialBrands: viewModel.specialBrands,
      notes: viewModel.notes,
    );
  }

  static CustomerViewModel toViewModel({required CustomerEntity entity}) {
    return CustomerViewModel(
      id: entity.id,
      address: entity.address,
      basicInfo: entity.basicInfo,
      personalInfo: entity.personalInfo,
      shopBasicInfo: entity.shopBasicInfo,
      discounts: entity.discounts,
      marketInfo: entity.marketInfo,
      methodsOfDealing: entity.methodsOfDealing,
      activity: entity.activity,
      specialBrands: entity.specialBrands,
      notes: entity.notes,
    );
  }
}
