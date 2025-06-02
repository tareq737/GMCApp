import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';

class DeleteCustomer implements UseCase<bool, int> {
  final SalesRepository salesRepository;
  final AuthInteractor authInteractor;

  DeleteCustomer({
    required this.salesRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, bool>> call(int params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await salesRepository.deleteCustomer(user: user, id: params);
    } else {
      return Left(Failure(message: 'User not found'));
    }
  }
}
