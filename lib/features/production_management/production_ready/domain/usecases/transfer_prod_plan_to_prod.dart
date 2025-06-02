import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';

class TransferProdPlanToProd implements UseCase<bool, int> {
  final ProdRepository prodRepository;
  final AuthInteractor authInteractor;

  TransferProdPlanToProd({
    required this.prodRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, bool>> call(int params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await prodRepository.transferPlanToProd(id: params, user: user);
    } else {
      return left(Failure(message: 'User not found'));
    }
  }
}
