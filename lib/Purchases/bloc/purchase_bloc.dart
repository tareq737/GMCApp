import 'package:bloc/bloc.dart';
import 'package:gmc/Purchases/models/brief_purchase_model.dart';
import 'package:gmc/Purchases/models/details_purchase_model.dart';
import 'package:gmc/Purchases/services/purchases_services.dart';
import 'package:gmc/core/model/handling_models.dart';
import 'package:meta/meta.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc() : super(PurchaseInitial()) {
    on<GetBriefPurchase>(
      (event, emit) async {
        emit(PurchaseLoading());
        var result = await getBriefPurchase(
            section: event.section, status: event.status);

        if (result is ListOf<BriefPurchaseModel>) {
          emit(
            PurchaseSuccess(
              result: result.data,
            ),
          );
        } else if (result is FailureModel) {
          emit(
            PurchaseError(
              errorMessage: result.message,
            ),
          );
        }
      },
    );

    on<GetDetailsPurchase>(
      (event, emit) async {
        emit(PurchaseLoading());

        var result = await getOnePurchase(pur_id: event.pur_id);

        if (result is ListOf<DetailsPurchaseModel>) {
          emit(
            PurchaseSuccess(
              result: result.data,
            ),
          );
        } else if (result is FailureModel) {
          emit(
            PurchaseError(
              errorMessage: result.message,
            ),
          );
        }
      },
    );
  }
}
