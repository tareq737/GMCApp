// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';

import 'package:gmcappclean/features/production_management/production_ready/domain/entities/check_entity.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/entities/prod_planning.dart';
import 'package:gmcappclean/features/production_management/production_ready/domain/repository/prod_repository.dart';
import 'package:gmcappclean/features/production_management/production_ready/data/datasources/prod_remote_source.dart';
import 'package:gmcappclean/features/production_management/production_ready/data/mapper/prod_planning_mapper.dart';

class ProdRepositoryImpl implements ProdRepository {
  final ProdRemoteDataSource prodRemoteDataSource;
  ProdRepositoryImpl({
    required this.prodRemoteDataSource,
  });

  @override
  Future<Either<Failure, ProdPlanEntity>> addProdPlanUnit({
    required UserEntity user,
    required ProdPlanEntity entity,
  }) async {
    try {
      return right(
        ProdPlanDataMapper.toEntity(
          model: await prodRemoteDataSource.addProdPlan(
            user: user,
            model: ProdPlanDataMapper.toModel(entity: entity),
          ),
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProdPlanUnit({
    required UserEntity user,
    required int id,
  }) async {
    try {
      return right(
        await prodRemoteDataSource.deleteProdPlan(
          user: user,
          id: id,
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProdPlanEntity>>> getAllProdPlanUnit(
      {required UserEntity user}) async {
    try {
      final result = await prodRemoteDataSource.getAllProdPlan(user: user);
      return right(
        List.generate(
          result.length,
          (index) {
            return ProdPlanDataMapper.toEntity(model: result[index]);
          },
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProdPlanEntity>> getProdPlanUnit(
      {required UserEntity user, required int id}) async {
    try {
      return right(
        ProdPlanDataMapper.toEntity(
          model: await prodRemoteDataSource.getProdPlan(user: user, id: id),
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProdPlanEntity>>> searchCustomer(
      {required UserEntity user, required String lexum}) async {
    try {
      final result =
          await prodRemoteDataSource.searchProdPlan(user: user, lexum: lexum);
      return right(
        List.generate(
          result.length,
          (index) {
            return ProdPlanDataMapper.toEntity(model: result[index]);
          },
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProdPlanEntity>> updateProdPlanningUnit({
    required UserEntity user,
    required ProdPlanEntity entity,
  }) async {
    try {
      return right(
        ProdPlanDataMapper.toEntity(
          model: await prodRemoteDataSource.updateProdPlan(
            user: user,
            model: ProdPlanDataMapper.toModel(entity: entity),
          ),
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDepProdPlam(
      {required UserEntity user, required CheckEntity entity}) async {
    try {
      return right(
        await prodRemoteDataSource.checkDepProdPlan(
          user: user,
          model: ProdPlanDataMapper.toCheckModel(entity: entity),
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> transferPlanToProd(
      {required UserEntity user, required int id}) async {
    try {
      return right(
          await prodRemoteDataSource.transferPlanToProd(user: user, id: id));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
