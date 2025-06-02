// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';

import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';

class GetProdPlan implements UseCase<ProdPlanEntity, int> {
  final AuthInteractor authInteractor;
  final ProdRepository prodRepository;
  GetProdPlan({
    required this.authInteractor,
    required this.prodRepository,
  });

  @override
  Future<Either<Failure, ProdPlanEntity>> call(int params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await prodRepository.getProdPlanUnit(user: user, id: params);
    } else {
      return left(Failure(message: 'No user tokens were found'));
    }
  }
}
