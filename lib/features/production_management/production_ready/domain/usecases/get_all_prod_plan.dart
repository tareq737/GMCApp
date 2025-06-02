import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';

class GetAllProdPlan implements UseCase<List<ProdPlanEntity>, NoParams> {
  final ProdRepository prodRepository;
  final AuthInteractor authInteractor;
  GetAllProdPlan({
    required this.prodRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, List<ProdPlanEntity>>> call(NoParams params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await prodRepository.getAllProdPlanUnit(user: user);
    } else {
      return left(Failure(message: 'No user tokens were found'));
    }
  }
}
