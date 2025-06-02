// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/mapper/prod_planning_mapper.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/prod_planning_viewmodel.dart';

class UpdateProdPlan implements UseCase<ProdPlanEntity, ProdPlanViewModel> {
  final ProdRepository prodRepository;
  final AuthInteractor authInteractor;
  UpdateProdPlan({
    required this.prodRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, ProdPlanEntity>> call(ProdPlanViewModel params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await prodRepository.updateProdPlanningUnit(
        user: user,
        entity: ProdPlanPresentationMapper.toEntity(viewModel: params),
      );
    } else {
      return left(Failure(message: 'No user tokens were found'));
    }
  }
}
