import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';

class GetCustomer implements UseCase<CustomerEntity, int> {
  final SalesRepository salesRepository;
  final AuthInteractor authInteractor;

  GetCustomer({
    required this.salesRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, CustomerEntity>> call(int params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await salesRepository.getCustomer(user: user, id: params);
    } else {
      return left(Failure(message: 'No user tokens were found'));
    }
  }
}
