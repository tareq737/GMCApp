import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/mapper/prod_planning_mapper.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/check_view_model.dart';

class DepCheckProdPlan implements UseCase<bool, CheckViewModel> {
  final ProdRepository prodRepository;
  final AuthInteractor authInteractor;

  DepCheckProdPlan(
      {required this.prodRepository, required this.authInteractor});
  @override
  Future<Either<Failure, bool>> call(CheckViewModel params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await prodRepository.checkDepProdPlam(
        user: user,
        entity: ProdPlanPresentationMapper.toCheckEntity(viewmodel: params),
      );
    } else {
      return left(Failure(message: 'User not found'));
    }
  }
}
