import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
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

  Future<List<BriefProductionModel>?> getAllProduction({
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'briefproduction',
          queryParams: {
            'page_size': 15,
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

  // Future<List<BriefProductionModel>?> getAllProductionArchive({
  //   required int page,
  // }) async {
  //   try {
  //     final userEntity = await getCredentials();
  //     return userEntity.fold((failure) {
  //       return null;
  //     }, (success) async {
  //       final response = await _apiClient.getPageinated(
  //         user: success,
  //         endPoint: 'production/archive',
  //         queryParams: {
  //           'page_size': 15,
  //           'page': page,
  //         },
  //       );

  //       return List.generate(response.length, (index) {
  //         return BriefProductionModel.fromMap(response[index]);
  //       });
  //     });
  //   } catch (e) {
  //     print('exception caught');
  //     return null;
  //   }
  // }

  Future<List<BriefProductionModel>?> searchProductionArchive(
      {required int page, required String search}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'production/briefarchive',
          queryParams: {
            'search': search,
            'page_size': 15,
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

  Future<Either<Failure, String>> archive(int id) async {
    // Change return type to String for the success message
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
              return right(
                  response['detail'] as String); // Return the success message
            } else {
              // Handle unexpected response format if 'detail' is not present
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
            'page_size': 15,
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

  Future<List<BriefProductionModel>?> getProductionFilter({
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
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'production_filter',
          queryParams: {
            'page_size': 15,
            'page': page,
            'status': status,
            'type': type,
            'date_1': date_1,
            'date_2': date_2,
            'timeliness': timeliness,
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
}
