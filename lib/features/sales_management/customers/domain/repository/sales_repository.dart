import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_brief_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

abstract interface class SalesRepository {
  Future<Either<Failure, CustomerEntity>> addCustomer({
    required UserEntity user,
    required CustomerEntity entity,
  });

  Future<Either<Failure, bool>> deleteCustomer({
    required int id,
    required UserEntity user,
  });

  Future<Either<Failure, CustomerEntity>> updateCustomer({
    required UserEntity user,
    required CustomerEntity entity,
  });
  Future<Either<Failure, CustomerEntity>> getCustomer({
    required UserEntity user,
    required int id,
  });
  Future<Either<Failure, List<CustomerBriefEntity>>> searchCustomer({
    required UserEntity user,
    required String lexum,
  });
  Future<Either<Failure, List<CustomerBriefEntity>>>
      getallCustomerPaginatation({
    required UserEntity user,
    required int page,
    int? hasCood,
    int? pageSize,
    String? search,
  });
  Future<Either<Failure, Uint8List>> exportExcelCustomers({
    required UserEntity user,
  });
}
