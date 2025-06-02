import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';

import 'package:gmcappclean/features/sales_management/customers/presentation/mapper/customer_mapper.dart';

class UpdateCustomer implements UseCase<CustomerEntity, CustomerViewModel> {
  final SalesRepository salesRepository;
  final AuthInteractor authInteractor;

  UpdateCustomer({
    required this.salesRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, CustomerEntity>> call(CustomerViewModel params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await salesRepository.updateCustomer(
        user: user,
        entity: CustomerPresentationMapper.toEntity(viewModel: params),
      );
    } else {
      return left(Failure(message: 'No user tokens were found'));
    }
  }
}
