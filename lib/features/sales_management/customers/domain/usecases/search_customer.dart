import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_brief_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';

class SearchCustomer implements UseCase<List<CustomerBriefEntity>, String> {
  final AuthInteractor authInteractor;
  final SalesRepository salesRepository;

  SearchCustomer({
    required this.authInteractor,
    required this.salesRepository,
  });

  @override
  Future<Either<Failure, List<CustomerBriefEntity>>> call(String params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return salesRepository.searchCustomer(user: user, lexum: params);
    } else {
      return left(Failure(message: 'no user tokens were found'));
    }
  }
}
