// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';

class SearchProdPlan implements UseCase<List<ProdPlanEntity>, String> {
  final ProdRepository prodRepository;
  final AuthInteractor authInteractor;
  SearchProdPlan({
    required this.prodRepository,
    required this.authInteractor,
  });

  @override
  Future<Either<Failure, List<ProdPlanEntity>>> call(String params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await prodRepository.searchCustomer(user: user, lexum: params);
    } else {
      return left(Failure(message: 'No user tokens were found'));
    }
  }
}
