// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/exceptions.dart';
import 'package:gmcappclean/features/production_management/production_ready/data/models/check_model.dart';
import 'package:gmcappclean/features/production_management/production_ready/data/models/prod_planning_model.dart';

abstract interface class ProdRemoteDataSource {
  Future<ProdPlanModel> addProdPlan({
    required UserEntity user,
    required ProdPlanModel model,
  });

  Future<ProdPlanModel> updateProdPlan({
    required UserEntity user,
    required ProdPlanModel model,
  });

  Future<bool> deleteProdPlan({
    required UserEntity user,
    required int id,
  });

  Future<ProdPlanModel> getProdPlan({
    required UserEntity user,
    required int id,
  });

  Future<List<ProdPlanModel>> getAllProdPlan({
    required UserEntity user,
  });

  Future<List<ProdPlanModel>> searchProdPlan({
    required UserEntity user,
    required String lexum,
  });

  Future<bool> checkDepProdPlan({
    required UserEntity user,
    required CheckModel model,
  });

  Future<bool> transferPlanToProd({
    required UserEntity user,
    required int id,
  });
}

class ProdRemoteDataSourceImp implements ProdRemoteDataSource {
  final ApiClient apiClient;
  ProdRemoteDataSourceImp({
    required this.apiClient,
  });

  @override
  Future<ProdPlanModel> addProdPlan(
      {required UserEntity user, required ProdPlanModel model}) async {
    final data = model.toJson();
    try {
      return ProdPlanModel.fromMap(
        await apiClient.add(
          userTokens: user,
          endPoint: 'prodplanning',
          data: data,
        ),
      );
    } catch (e) {
      print('exception frommodel method\n ${e.toString()}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteProdPlan(
      {required UserEntity user, required int id}) async {
    try {
      return await apiClient.delete(
        user: user,
        endPoint: 'prodplanning',
        id: id,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProdPlanModel>> getAllProdPlan({required UserEntity user}) async {
    try {
      final data = await apiClient.get(user: user, endPoint: 'prodplanning');
      return List<ProdPlanModel>.generate(
        data.length,
        (index) {
          return ProdPlanModel.fromMap(data[index]);
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProdPlanModel> getProdPlan(
      {required UserEntity user, required int id}) async {
    try {
      return ProdPlanModel.fromMap(
        await apiClient.getById(
          user: user,
          endPoint: 'prodplanning',
          id: id,
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProdPlanModel>> searchProdPlan(
      {required UserEntity user, required String lexum}) async {
    try {
      final data = await apiClient.get(
        user: user,
        endPoint: 'prodplanning',
        queryParams: lexum != '' ? {'search': lexum} : null,
      );
      return List<ProdPlanModel>.generate(
        data.length,
        (index) {
          return ProdPlanModel.fromMap(data[index]);
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProdPlanModel> updateProdPlan(
      {required UserEntity user, required ProdPlanModel model}) async {
    try {
      final data = model.toJson();
      return ProdPlanModel.fromMap(
        await apiClient.updateViaPatch(
          user: user,
          endPoint: 'prodplanning',
          data: data,
          id: model.id,
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> checkDepProdPlan(
      {required UserEntity user, required CheckModel model}) async {
    try {
      final data = model.toJson();
      await apiClient.updateViaPatch(
        user: user,
        endPoint: 'prodplanning',
        data: data,
        id: model.planId,
      );
      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> transferPlanToProd(
      {required UserEntity user, required int id}) async {
    try {
      await apiClient.addById(
        userTokens: user,
        endPoint: 'toproduction',
        id: id,
      );
      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
