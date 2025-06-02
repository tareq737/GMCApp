import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/check_entity.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';

abstract interface class ProdRepository {
  Future<Either<Failure, ProdPlanEntity>> addProdPlanUnit({
    required UserEntity user,
    required ProdPlanEntity entity,
  });

  Future<Either<Failure, bool>> deleteProdPlanUnit({
    required UserEntity user,
    required int id,
  });

  Future<Either<Failure, ProdPlanEntity>> updateProdPlanningUnit({
    required UserEntity user,
    required ProdPlanEntity entity,
  });

  Future<Either<Failure, ProdPlanEntity>> getProdPlanUnit({
    required UserEntity user,
    required int id,
  });

  Future<Either<Failure, List<ProdPlanEntity>>> getAllProdPlanUnit({
    required UserEntity user,
  });
  Future<Either<Failure, List<ProdPlanEntity>>> searchCustomer({
    required UserEntity user,
    required String lexum,
  });

  Future<Either<Failure, bool>> checkDepProdPlam({
    required UserEntity user,
    required CheckEntity entity,
  });

  Future<Either<Failure, bool>> transferPlanToProd({
    required UserEntity user,
    required int id,
  });
}
