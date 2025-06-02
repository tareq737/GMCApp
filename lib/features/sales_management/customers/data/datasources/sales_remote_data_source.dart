import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/exceptions.dart';
import 'package:gmcappclean/features/sales_management/customers/data/models/customer_brief_model.dart';
import 'package:gmcappclean/features/sales_management/customers/data/models/customer_model.dart';

abstract interface class SalesRemoteDataSource {
  Future<CustomerModel> addCustomer({
    required UserEntity user,
    required CustomerModel model,
  });

  Future<CustomerModel> updateCustomer({
    required UserEntity user,
    required CustomerModel model,
  });
  Future<bool> deleteCustomer({
    required UserEntity user,
    required int id,
  });
  Future<CustomerModel> getCustomerInfo({
    required UserEntity user,
    required int id,
  });
  Future<List<CustomerBriefModel>> searchCustomer({
    required UserEntity user,
    required String lexum,
  });
  Future<List<CustomerBriefModel>> getallCustomerPaginatation({
    required UserEntity user,
    required int page,
    int? pageSize,
    int? hasCood,
    String? search,
  });
}

class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final ApiClient apiClient;

  SalesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CustomerModel> addCustomer({
    required UserEntity user,
    required CustomerModel model,
  }) async {
    final data = model.toJson();
    try {
      return CustomerModel.fromMap(
        await apiClient.add(
          userTokens: user,
          endPoint: 'customer',
          data: data,
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteCustomer({
    required UserEntity user,
    required int id,
  }) async {
    try {
      return await apiClient.delete(
        user: user,
        endPoint: 'customer',
        id: id,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CustomerModel> getCustomerInfo({
    required UserEntity user,
    required int id,
  }) async {
    try {
      return CustomerModel.fromMap(
        await apiClient.getById(
          user: user,
          endPoint: 'customer',
          id: id,
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CustomerBriefModel>> searchCustomer({
    required UserEntity user,
    required String lexum,
  }) async {
    try {
      final data = await apiClient.get(
        user: user,
        endPoint: 'briefcustomer',
        queryParams: lexum != '' ? {'search': lexum} : null,
      );
      return List<CustomerBriefModel>.generate(data.length, (index) {
        return CustomerBriefModel.fromMap(data[index]);
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CustomerModel> updateCustomer({
    required UserEntity user,
    required CustomerModel model,
  }) async {
    try {
      final data = model.toJson();
      return CustomerModel.fromMap(
        await apiClient.updateViaPut(
          user: user,
          endPoint: 'customer',
          data: data,
          id: model.id,
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CustomerBriefModel>> getallCustomerPaginatation({
    required UserEntity user,
    required int page,
    int? pageSize,
    int? hasCood,
    String? search,
  }) async {
    try {
      print('REMOTE DATA SOURCE Params: $page, $pageSize, $hasCood,$search');
      final data = await apiClient.getPageinated(
        user: user,
        endPoint: 'customers/paginated',
        queryParams: {
          'page': page,
          'has_coords': hasCood,
          'page_size': pageSize,
          'search': search,
        },
      );
      return List<CustomerBriefModel>.generate(data.length, (index) {
        return CustomerBriefModel.fromMap(data[index]);
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
