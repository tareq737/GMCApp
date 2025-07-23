// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseService _purchaseService;

  PurchaseBloc(this._purchaseService) : super(PurchaseInitial()) {
    on<ResetPurchaseState>((event, emit) {
      emit(PurchaseInitial()); // Reset to initial state
    });
    on<GetAllPurchases>(
      (event, emit) async {
        emit(PurchaseLoading()); // Move it inside the specific event handler
        var result = await _purchaseService.getAllPurchase(
          page: event.page,
          status: event.status,
          department: event.department,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<SearchPurchases>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.searchPurchase(
          search: event.search,
          page: event.page,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<GetOnePurchase>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.getOnePurchaseByID(event.id);
        if (result == null) {
          emit(PurchaseError(
              errorMessage: 'Error fetching purchase with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<AddPurchases>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.addPurchase(event.purchasesModel);
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<UpdatePurchases>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.updatePurchaseManager(
            event.id, event.purchaseModel);
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );
    on<GetPurchaseImage>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseBillImage(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });
    on<AddPurchaseImage>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseImage(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<DeletePurchaceImage>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.deletePurchaseBillByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );

    on<GetPurchaseOffer1Image>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseOffer1Image(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });

    on<GetPurchaseOffer2Image>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseOffer2Image(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });

    on<GetPurchaseOffer3Image>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseOffer3Image(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });
    on<AddPurchaseOffer1Image>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseOffer1Image(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );
    on<AddPurchaseOffer2Image>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseOffer2Image(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );
    on<AddPurchaseOffer3Image>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseOffer3Image(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<DeletePurchaceOffer1Image>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.deletePurchaseOffer1ByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );
    on<DeletePurchaceOffer2Image>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.deletePurchaseOffer2ByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );
    on<DeletePurchaceOffer3Image>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.deletePurchaseOffer3ByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );

    on<GetPurchaseDatasheet1Image>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseDatasheet1Image(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });

    on<GetPurchaseDatasheet2Image>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseDatasheet2Image(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });

    on<GetPurchaseDatasheet3Image>((event, emit) async {
      emit(PurchaseImageLoading());
      var result = await _purchaseService.getPurchaseDatasheet3Image(event.id);
      result.fold((success) {
        emit(PurchaseSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(PurchaseError(errorMessage: failure.message));
      });
    });
    on<AddPurchaseDatasheet1Image>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseDatasheet1Image(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );
    on<AddPurchaseDatasheet2Image>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseDatasheet2Image(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );
    on<AddPurchaseDatasheet3Image>(
      (event, emit) async {
        emit(PurchaseImageLoading());
        var result = await _purchaseService.addPurchaseDatasheet3Image(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );

    on<DeletePurchaceDatasheet1Image>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result =
            await _purchaseService.deletePurchaseDatasheet1ByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );
    on<DeletePurchaceDatasheet2Image>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result =
            await _purchaseService.deletePurchaseDatasheet2ByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );
    on<DeletePurchaceDatasheet3Image>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result =
            await _purchaseService.deletePurchaseDatasheet3ByID(event.id);
        if (result == false) {
          emit(PurchaseError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(PurchaseSuccess<bool>(result: true));
        }
      },
    );

    on<ExportExcelPendingOffers>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.exportExcelPendingOffers();
        result.fold(
          (successBytes) {
            emit(PurchaseSuccess(result: successBytes));
          },
          (failure) {
            emit(PurchaseError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<ExportExcelReadyToBuy>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.exportExcelReadyToBuy();
        result.fold(
          (successBytes) {
            emit(PurchaseSuccess(result: successBytes));
          },
          (failure) {
            emit(PurchaseError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<GetListForPayment>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await _purchaseService.getListForPayment(page: event.page);
        if (result == null) {
          emit(PurchaseError(errorMessage: 'Error'));
        } else {
          emit(PurchaseSuccess(result: result));
        }
      },
    );
    on<ExportExcelForPayment>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result =
            await _purchaseService.exportExcelListForPayment(ids: event.ids);
        result.fold(
          (successBytes) {
            emit(PurchaseSuccess(result: successBytes));
          },
          (failure) {
            emit(PurchaseError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<ArchiveList>((event, emit) async {
      emit(PurchaseLoading());
      final result = await _purchaseService.archiveList(ids: event.ids);
      result.fold(
        (data) {
          emit(PurchaseSuccess(result: data));
        },
        (failure) {
          emit(PurchaseError(errorMessage: failure.message));
        },
      );
    });
  }
}
