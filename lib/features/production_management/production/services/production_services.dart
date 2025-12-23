import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/production_management/production/models/brief_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/empty_packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/finished_goods_model.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/lab_model.dart';
import 'package:gmcappclean/features/production_management/production/models/manufacturing_model.dart';
import 'package:gmcappclean/features/production_management/production/models/packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/quality_control_model.dart';
import 'package:gmcappclean/features/production_management/production/models/raw_materials_model.dart';

class ProductionServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  ProductionServices({
    required ApiClient apiClient,
    required AuthInteractor authInteractor,
  })  : _apiClient = apiClient,
        _authInteractor = authInteractor;

  Future<Either<Failure, UserEntity>> getCredentials() async {
    var user = await _authInteractor.getSession();
    if (user is UserEntity) {
      return right(user);
    } else {
      return left(Failure(message: 'no user'));
    }
  }

  Future<FullProductionModel?> getOneProductionByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'production', id: id);
        return FullProductionModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PageintedResult?> getAllProduction({
    required int page,
    String? type,
    String? tier,
    String? color,
    String? search,
    String? date1,
    String? date2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final Map<String, dynamic> queryParams = {
          'page_size': 40,
          'page': page,
        };
        if (type != null && type.isNotEmpty) queryParams['type'] = type;
        if (tier != null && tier.isNotEmpty) queryParams['tier'] = tier;
        if (color != null && color.isNotEmpty) queryParams['color'] = color;
        if (search != null && search.isNotEmpty) queryParams['search'] = search;
        if (date1 != null && date1.isNotEmpty) queryParams['date1'] = date1;
        if (date2 != null && date2.isNotEmpty) queryParams['date2'] = date2;
        final paginated = await _apiClient.getPageinatedWithCount(
            user: success,
            endPoint: 'briefproduction',
            queryParams: queryParams);
        final models = paginated.results
            .map((item) => BriefProductionModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      // Consistent exception logging
      print('exception caught: $e');
      return null;
    }
  }

  Future<PageintedResult?> searchProductionArchive({
    required int page,
    String? type,
    String? tier,
    String? color,
    String? search,
    String? date1,
    String? date2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Build query parameters dynamically
        final Map<String, dynamic> queryParams = {
          'page_size': 40,
          'page': page,
        };

        if (type != null && type.isNotEmpty) queryParams['type'] = type;
        if (tier != null && tier.isNotEmpty) queryParams['tier'] = tier;
        if (color != null && color.isNotEmpty) queryParams['color'] = color;
        if (search != null && search.isNotEmpty) queryParams['search'] = search;
        if (date1 != null && date1.isNotEmpty) queryParams['date1'] = date1;
        if (date2 != null && date2.isNotEmpty) queryParams['date2'] = date2;

        // Call API
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'archive_production_filter',
          queryParams: queryParams,
        );

        // Map results to models
        final models = paginated.results
            .map((item) => BriefProductionModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<FullProductionModel?> getOneProductionByIDArchive(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'production',
          id: id,
        );
        return FullProductionModel.fromMapArchive(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<RawMaterialsModel?> saveRawMaterial(
      int id, RawMaterialsModel rawMaterialsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: rawMaterialsModel.toJson(),
          id: id,
        );
        return RawMaterialsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<ManufacturingModel?> saveManufacturing(
      int id, ManufacturingModel manufacturingModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: manufacturingModel.toJson(),
          id: id,
        );
        return ManufacturingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<LabModel?> saveLab(int id, LabModel labModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: labModel.toJson(),
          id: id,
        );
        return LabModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<EmptyPackagingModel?> saveEmptyPackaging(
      int id, EmptyPackagingModel emptyPackagingModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: emptyPackagingModel.toJson(),
          id: id,
        );
        return EmptyPackagingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PackagingModel?> savePackaging(
      int id, PackagingModel packagingModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: packagingModel.toJson(),
          id: id,
        );
        return PackagingModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<FinishedGoodsModel?> saveFinishedGoods(
      int id, FinishedGoodsModel finishedGoodsModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: finishedGoodsModel.toJson(),
          id: id,
        );
        return FinishedGoodsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<QualityControlModel?> saveQualityControl(
      int id, QualityControlModel qualityControl) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'production/edit',
          data: qualityControl.toJson(),
          id: id,
        );
        return QualityControlModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<Either<Failure, String>> archive(int id) async {
    try {
      final userEntityResult = await getCredentials();

      return userEntityResult.fold(
        (failure) {
          return Left(failure);
        },
        (userEntity) async {
          try {
            final response = await _apiClient.addById(
              endPoint: 'production/archive',
              id: id,
              userTokens: userEntity,
            );
            // Assuming 'response' is a Map<String, dynamic>
            if (response.containsKey('detail')) {
              return right(response['detail'] as String);
            } else {
              return left(
                  Failure(message: 'Unexpected success response format.'));
            }
          } catch (e) {
            return left(Failure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      print('Error in archive method: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> unArchive(int id) async {
    try {
      final userEntityResult = await getCredentials();

      return userEntityResult.fold(
        (failure) {
          return Left(failure);
        },
        (userEntity) async {
          try {
            final response = await _apiClient.addById(
              endPoint: 'production/unarchive',
              id: id,
              userTokens: userEntity,
            );
            // Assuming 'response' is a Map<String, dynamic>
            if (response.containsKey('detail')) {
              return right(response['detail'] as String);
            } else {
              return left(
                  Failure(message: 'Unexpected success response format.'));
            }
          } catch (e) {
            return left(Failure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      print('Error in archive method: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> revertToProdplanning(int id) async {
    try {
      final userEntityResult = await getCredentials();

      return userEntityResult.fold(
        (failure) {
          return Left(failure);
        },
        (userEntity) async {
          try {
            final response = await _apiClient.addById(
              endPoint: 'revert_to_prodplanning',
              id: id,
              userTokens: userEntity,
            );
            if (response.containsKey('detail')) {
              return right(response['detail'] as String);
            } else {
              return left(
                  Failure(message: 'Unexpected success response format.'));
            }
          } catch (e) {
            return left(Failure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      print('Error in archive method: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<List<BriefProductionModel>?> allProduction(
      {required int page, required String search}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'Allproduction',
          queryParams: {
            'search': search,
            'page_size': 20,
            'page': page,
          },
        );
        return List.generate(response.length, (index) {
          return BriefProductionModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<PageintedResult?> getProductionFilter({
    required int page,
    required String status,
    required String type,
    required String date_1,
    required String date_2,
    required String timeliness,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'production_filter',
          queryParams: {
            'page_size': 20,
            'page': page,
            'status': status,
            'type': type,
            'date_1': date_1,
            'date_2': date_2,
            'timeliness': timeliness,
          },
        );

        final models = paginated.results
            .map((item) => BriefProductionModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<Either<Failure, String>> generateLoyaltyQr({required int id}) async {
    try {
      final userEntityResult = await getCredentials();

      return userEntityResult.fold(
        (failure) {
          return Left(failure);
        },
        (userEntity) async {
          try {
            final response = await _apiClient.getOneMap(
              endPoint: 'loyalty/generate_qr/',
              user: userEntity,
              queryParams: {'id': id},
            );
            if (response == null) {
              return left(
                  Failure(message: 'No response received from server.'));
            }
            if (response.containsKey('detail')) {
              return right(response['detail'] as String);
            } else {
              return left(
                Failure(message: 'Unexpected success response format.'),
              );
            }
          } catch (e) {
            return left(Failure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      print('Error in archive method: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Uint8List, Failure>> generateLabelPdf({
    required double length,
    required double width,
    required String content,
    required String paper_size,
  }) async {
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
                endPoint: 'generate_label_pdf',
                queryParameters: {
                  'length': length,
                  'width': width,
                  'content': content,
                  'paper_size': paper_size,
                });
            return left(response);
          } catch (e) {
            print('Error exporting PDF: $e');
            return right(
                Failure(message: 'Failed to export PDF: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportPDF service: $e');
      return right(Failure(
          message: 'Unexpected error during PDF export: ${e.toString()}'));
    }
  }
}
