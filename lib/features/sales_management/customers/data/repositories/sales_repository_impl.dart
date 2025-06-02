import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/features/sales_management/customers/data/datasources/sales_remote_data_source.dart';
import 'package:gmcappclean/features/sales_management/customers/data/mappers/customer_brief_mapper.dart';
import 'package:gmcappclean/features/sales_management/customers/data/mappers/customer_mapper.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_brief_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource salesRemoteDataSource;

  SalesRepositoryImpl({required this.salesRemoteDataSource});

  @override
  Future<Either<Failure, CustomerEntity>> addCustomer({
    required UserEntity user,
    required CustomerEntity entity,
  }) async {
    try {
      print('has reached repo impl');
      return right(
        CustomerDataMapper.toEntity(
          model: await salesRemoteDataSource.addCustomer(
            user: user,
            model: CustomerDataMapper.toModel(entity: entity),
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCustomer({
    required int id,
    required UserEntity user,
  }) async {
    try {
      return right(
        await salesRemoteDataSource.deleteCustomer(
          id: id,
          user: user,
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> getCustomer({
    required UserEntity user,
    required int id,
  }) async {
    try {
      final res =
          await salesRemoteDataSource.getCustomerInfo(user: user, id: id);
      return right(CustomerDataMapper.toEntity(model: res));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomerBriefEntity>>> searchCustomer({
    required UserEntity user,
    required String lexum,
  }) async {
    try {
      final result = await salesRemoteDataSource.searchCustomer(
        user: user,
        lexum: lexum,
      );
      return right(
        List.generate(
          result.length,
          (index) {
            return CustomerBriefDataMapper.toEntity(model: result[index]);
          },
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> updateCustomer({
    required UserEntity user,
    required CustomerEntity entity,
  }) async {
    try {
      return right(
        CustomerDataMapper.toEntity(
          model: await salesRemoteDataSource.updateCustomer(
            user: user,
            model: CustomerDataMapper.toModel(entity: entity),
          ),
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomerBriefEntity>>> getallCustomerPaginatation(
      {required UserEntity user,
      required int page,
      int? hasCood,
      int? pageSize,
      String? search}) async {
    try {
      final result = await salesRemoteDataSource.getallCustomerPaginatation(
        user: user,
        page: page,
        hasCood: hasCood,
        pageSize: pageSize,
        search: search,
      );
      return right(
        List.generate(
          result.length,
          (index) {
            return CustomerBriefDataMapper.toEntity(model: result[index]);
          },
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
