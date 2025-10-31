import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/exceptions.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/operations/models/call_model.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/models/visit_mode.dart';

class OperationsServices {
  final ApiClient _apiClient;
  final CheckUserSessionStatus _checkUserSessionStatus;

  OperationsServices(
      {required ApiClient apiClient,
      required CheckUserSessionStatus checkUserSessionStatus})
      : _apiClient = apiClient,
        _checkUserSessionStatus = checkUserSessionStatus;
  Future<Either<Failure, UserEntity>> getCredentials() async {
    try {
      final userResult = await _checkUserSessionStatus(NoParams());
      return userResult.fold(
        (failure) {
          throw const ServerException('No local tokens were found');
        },
        (success) {
          return right(success);
        },
      );
    } catch (e) {
      print('Error occurred: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<VisitModel?> addNewVisit(VisitModel visitModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'sales_visits',
          data: visitModel.toJson(),
        );
        print(response);
        return VisitModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<CallModel?> addNewCall(CallModel callModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'sales_calls',
          data: callModel.toJson(),
        );
        return CallModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<OperationsModel>?> getAllOperationsForCustomer(
      Map<String, dynamic> queryParams) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
          user: success,
          endPoint: 'sales_op',
          queryParams: queryParams,
        );
        print(response.length.toString());
        return List.generate(response.length, (index) {
          return OperationsModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<PageintedResult?> getAllOperationsForDate(
      Map<String, dynamic> queryParams) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        queryParams['page'] = queryParams['page'] ?? 1;
        queryParams['page_size'] = 30;

        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'sales_op_paginated',
          queryParams: queryParams,
        );

        final models = paginated.results
            .map((item) => OperationsModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<CallModel?> editCall({
    required int id,
    required CallModel callModel,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'sales_calls',
          data: callModel.toJson(),
          id: id,
        );
        return CallModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<VisitModel?> editVisit(
      {required int id, required VisitModel visitModel}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'sales_visits',
          data: visitModel.toJson(),
          id: id,
        );
        return VisitModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelOperations(
      {required Map queryParamss}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            final Map<String, dynamic> queryParams =
                queryParamss.cast<String, dynamic>();

            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'sales_report',
              queryParameters: queryParams,
            );
            return left(response);
          } catch (e) {
            print('Error exporting Excel tasks: $e');
            return right(
                Failure(message: 'Failed to export Excel: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportExcelTasks service: $e');
      return right(Failure(
          message: 'Unexpected error during Excel export: ${e.toString()}'));
    }
  }
}
