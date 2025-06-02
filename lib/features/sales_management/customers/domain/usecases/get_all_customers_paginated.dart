// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';

import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_brief_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';

class GetAllCustomersPaginated
    implements UseCase<List<CustomerBriefEntity>, PaginatedSalesParams> {
  final AuthInteractor authInteractor;
  final SalesRepository salesRepository;

  GetAllCustomersPaginated({
    required this.authInteractor,
    required this.salesRepository,
  });

  @override
  Future<Either<Failure, List<CustomerBriefEntity>>> call(
      PaginatedSalesParams params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return salesRepository.getallCustomerPaginatation(
        user: user,
        page: params.page,
        hasCood: params.hasCood,
        pageSize: params.pageSize,
        search: params.search,
      );
    } else {
      return left(Failure(message: 'no user tokens were found'));
    }
  }
}

class PaginatedSalesParams {
  int page;
  int? pageSize;
  int? hasCood;
  String? search;
  PaginatedSalesParams({
    required this.page,
    this.pageSize,
    this.hasCood,
    this.search,
  });
}
