import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/homeowner_model.dart';
import 'package:gmcappclean/features/surveys/models/painters_model.dart';
import 'package:gmcappclean/features/surveys/models/sales/pros_cons_model.dart';
import 'package:gmcappclean/features/surveys/models/sales/sales_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';

import 'package:meta/meta.dart';

part 'surveys_event.dart';
part 'surveys_state.dart';

class SurveysBloc extends Bloc<SurveysEvent, SurveysState> {
  final SurveysServices _surveysServices;
  SurveysBloc(this._surveysServices) : super(SurveysInitial()) {
    on<SurveysEvent>((event, emit) {
      emit(SurveysLoading());
    });
    on<GetHomeownerSurveys>(
      (event, emit) async {
        var result = await _surveysServices.getHomeownerSurveys(
          page: event.page,
        );

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<GetOneHomeownerSurveys>(
      (event, emit) async {
        var result = await _surveysServices.getOneHomeownerSurvey(event.id);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );

    on<AddNewHomeownerSurvey>(
      (event, emit) async {
        var result =
            await _surveysServices.addNewHomeownerSurvey(event.homeownerModel);
        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<EditHomeownerSurvey>(
      (event, emit) async {
        var result = await _surveysServices.editHomeownerSurvey(
            id: event.id, homeownerModel: event.homeownerModel);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<DeleteOneHomeownerSurvey>(
      (event, emit) async {
        var result = await _surveysServices.deleteOneHomeownerSurvey(event.id);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<ExportExcelHomeownerSurvey>(
      (event, emit) async {
        var result = await _surveysServices.exportExcelHomeownerSurvey();
        result.fold(
          (successBytes) {
            emit(SurveysSuccess(result: successBytes));
          },
          (failure) {
            emit(SurveysError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<GetHomeownerStatistics>(
      (event, emit) async {
        final result = await _surveysServices.getHomeownerStatistics(
          date1: event.date1,
          date2: event.date2,
          regions: event.regions,
        );
        if (result != null) {
          emit(SurveysSuccess(result: result));
        } else {
          emit(SurveysError(errorMessage: 'Error fetching statistics'));
        }
      },
    );
    on<GetPainters>(
      (event, emit) async {
        var result = await _surveysServices.getPainters(page: event.page);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<GetOnePainter>(
      (event, emit) async {
        var result = await _surveysServices.getOnePainter(event.id);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );

    on<AddNewPainter>(
      (event, emit) async {
        var result = await _surveysServices.addNewPainter(event.paintersModel);
        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<EditPainter>(
      (event, emit) async {
        var result = await _surveysServices.editPainter(
            id: event.id, paintersModel: event.paintersModel);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<DeleteOnePainter>(
      (event, emit) async {
        var result = await _surveysServices.deleteOnePainter(event.id);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<GetSalesSurveys>(
      (event, emit) async {
        var result = await _surveysServices.getSalesSurveys(
          page: event.page,
        );

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<GetOneSalesSurveys>(
      (event, emit) async {
        var result = await _surveysServices.getOneSalesSurvey(event.id);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );

    on<AddNewSalesSurvey>(
      (event, emit) async {
        var result = await _surveysServices.addNewSalesSurvey(event.salesModel);
        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<EditSalesSurvey>(
      (event, emit) async {
        var result = await _surveysServices.editSalesSurvey(
            id: event.id, salesModel: event.salesModel);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<DeleteOneSalesSurvey>(
      (event, emit) async {
        var result = await _surveysServices.deleteOneSalesSurvey(event.id);

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ'));
        } else {
          emit(SurveysSuccess(result: result));
        }
      },
    );
    on<ExportExcelSalesSurvey>(
      (event, emit) async {
        var result = await _surveysServices.exportExcelSalesSurvey();
        result.fold(
          (successBytes) {
            emit(SurveysSuccess(result: successBytes));
          },
          (failure) {
            emit(SurveysError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<GetProsAndCons>((event, emit) async {
      emit(SurveysLoading());
      try {
        var result = await _surveysServices.getProsAndCons();

        if (result == null) {
          emit(SurveysError(errorMessage: 'خطأ في تحميل البيانات'));
        } else {
          final response = ProsConsResponse.fromJson(result);
          emit(SurveysSuccessProsandcons(
            pros: response.pros,
            cons: response.cons,
          ));
        }
      } catch (e) {
        emit(SurveysError(errorMessage: 'خطأ: $e'));
      }
    });
  }
}
