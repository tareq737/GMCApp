import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/surveys/bloc/surveys_bloc.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/brief_homeowner_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/market_survey_summary_model.dart';
import 'package:gmcappclean/features/surveys/models/sales/brief_sales_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/homeowner_model.dart';
import 'package:gmcappclean/features/surveys/models/painters_model.dart';
import 'package:gmcappclean/features/surveys/models/sales/sales_model.dart';

class SurveysServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;
  SurveysServices(
      {required ApiClient apiClient, required AuthInteractor authInteractor})
      : _apiClient = apiClient,
        _authInteractor = authInteractor;

  Future<Either<Failure, UserEntity>> getCredentials() async {
    var user = await _authInteractor.getSession();
    if (user is UserEntity) {
      return right(user);
    } else {
      return left(Failure(message: 'no user'));
    }
  }

  Future<PageintedResult?> getHomeownerSurveys({required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'homeowner_survey',
          queryParams: {
            'page_size': 30,
            'page': page,
          },
        );

        final models = paginated.results
            .map((item) => BriefHomeownerModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<HomeownerModel?> getOneHomeownerSurvey(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'homeowner_survey',
          id: id,
        );
        return HomeownerModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<HomeownerModel?> addNewHomeownerSurvey(
      HomeownerModel homeownerModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'homeowner_survey',
          data: homeownerModel.toJson(),
        );
        return HomeownerModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<HomeownerModel?> editHomeownerSurvey({
    required int id,
    required HomeownerModel homeownerModel,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'homeowner_survey',
          data: homeownerModel.toJson(),
          id: id,
        );
        return HomeownerModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOneHomeownerSurvey(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'homeowner_survey',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelHomeownerSurvey() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'export_homeowner_survey',
            );
            return left(response);
          } catch (e) {
            print('Error exporting Excel: $e');
            return right(
                Failure(message: 'Failed to export Excel: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportExcel service: $e');
      return right(Failure(
          message: 'Unexpected error during Excel export: ${e.toString()}'));
    }
  }

  Future<MarketSurveySummaryModel?> getHomeownerStatistics({
    required String date1,
    required String date2,
    String? regions,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
            user: success,
            endPoint: 'homeowner_survey/statistics',
            queryParams: {
              'date1': date1,
              'date2': date2,
              'regions': regions,
            });
        if (response == null) {
          return null;
        }
        return MarketSurveySummaryModel.fromMap(response);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<PageintedResult?> getPainters({required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'painters',
          queryParams: {
            'page_size': 30,
            'page': page,
          },
        );

        final models = paginated.results
            .map((item) => PaintersModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<PaintersModel?> getOnePainter(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'painters',
          id: id,
        );
        return PaintersModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PaintersModel?> addNewPainter(PaintersModel paintersModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'painters',
          data: paintersModel.toJson(),
        );
        return PaintersModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PaintersModel?> editPainter({
    required int id,
    required PaintersModel paintersModel,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'painters',
          data: paintersModel.toJson(),
          id: id,
        );
        return PaintersModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOnePainter(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'painters',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<PageintedResult?> getSalesSurveys({required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'sales_survey',
          queryParams: {
            'page_size': 30,
            'page': page,
          },
        );

        final models = paginated.results
            .map((item) => BriefSalesModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<SalesModel?> getOneSalesSurvey(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'sales_survey',
          id: id,
        );
        return SalesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<SalesModel?> addNewSalesSurvey(SalesModel salesModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'sales_survey',
          data: salesModel.toJson(),
        );
        return SalesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<SalesModel?> editSalesSurvey({
    required int id,
    required SalesModel salesModel,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'sales_survey',
          data: salesModel.toJson(),
          id: id,
        );
        return SalesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool?> deleteOneSalesSurvey(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'sales_survey',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelSalesSurvey() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'export_sales_survey',
            );
            return left(response);
          } catch (e) {
            print('Error exporting Excel: $e');
            return right(
                Failure(message: 'Failed to export Excel: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportExcel service: $e');
      return right(Failure(
          message: 'Unexpected error during Excel export: ${e.toString()}'));
    }
  }

  Future<Map<String, dynamic>?> getProsAndCons() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
          user: success,
          endPoint: 'prosandcons',
        );
        if (response == null) {
          return null;
        }
        return response;
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }
}
