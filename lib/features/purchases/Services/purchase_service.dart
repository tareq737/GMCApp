import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/purchases/Models/brief_purchase_model.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';

class PurchaseService {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;
  PurchaseService({
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

  Future<PurchasesModel?> getOnePurchaseByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
            user: success, endPoint: 'purchases', id: id);
        return PurchasesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<BriefPurchaseModel>?> getAllPurchase({
    required int page,
    required int status,
    required String department,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'purchases/paginated',
          queryParams: {
            'page_size': 20,
            'page': page,
            'status': status,
            'department': department,
          },
        );

        return List.generate(response.length, (index) {
          return BriefPurchaseModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<List<BriefPurchaseModel>?> searchPurchase(
      {required String search, required int page}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getPageinated(
          user: success,
          endPoint: 'purchases/paginated',
          queryParams: {'search': search, 'page': page},
        );
        return List.generate(response.length, (index) {
          return BriefPurchaseModel.fromMap(response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<PurchasesModel?> addPurchase(PurchasesModel purchasesModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'purchases',
          data: purchasesModel.toJson(),
        );
        return PurchasesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PurchasesModel?> updatePurchaseManager(
      int id, PurchasesModel purchasesModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPatch(
          user: success,
          endPoint: 'purchases',
          data: purchasesModel.toJson(),
          id: id,
        );
        return PurchasesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

//bill
  Future<Either<Uint8List, Failure>> getPurchaseBillImage(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/image', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<PurchasesModel?> addPurchaseImage({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "bill": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletePurchaseBillByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_image', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

// offers
  Future<Either<Uint8List, Failure>> getPurchaseOffer1Image(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/offer_image/1', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Either<Uint8List, Failure>> getPurchaseOffer2Image(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/offer_image/2', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Either<Uint8List, Failure>> getPurchaseOffer3Image(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/offer_image/3', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<PurchasesModel?> addPurchaseOffer1Image({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload_offer_image/1',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<PurchasesModel?> addPurchaseOffer2Image({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload_offer_image/2',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<PurchasesModel?> addPurchaseOffer3Image({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload_offer_image/3',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletePurchaseOffer1ByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_offer_image/1', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePurchaseOffer2ByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_offer_image/2', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePurchaseOffer3ByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_offer_image/3', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  //datasheet

  Future<Either<Uint8List, Failure>> getPurchaseDatasheet1Image(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/datasheet/1', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Either<Uint8List, Failure>> getPurchaseDatasheet2Image(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/datasheet/2', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Either<Uint8List, Failure>> getPurchaseDatasheet3Image(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'purchases/datasheet/3', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<PurchasesModel?> addPurchaseDatasheet1Image({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload_datasheet/1',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<PurchasesModel?> addPurchaseDatasheet2Image({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload_datasheet/2',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<PurchasesModel?> addPurchaseDatasheet3Image({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'purchases/upload_datasheet/3',
              formData: formData,
              id: id);
          return PurchasesModel.fromMap(response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletePurchaseDatasheet1ByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_datasheet/1', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePurchaseDatasheet2ByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_datasheet/2', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePurchaseDatasheet3ByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'purchases/delete_datasheet/3', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }
}
