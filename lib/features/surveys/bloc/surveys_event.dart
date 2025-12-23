part of 'surveys_bloc.dart';

@immutable
sealed class SurveysEvent {}

class GetHomeownerSurveys extends SurveysEvent {
  final int page;

  GetHomeownerSurveys({
    required this.page,
  });
}

class GetOneHomeownerSurveys extends SurveysEvent {
  final int id;
  GetOneHomeownerSurveys({required this.id});
}

class AddNewHomeownerSurvey extends SurveysEvent {
  final HomeownerModel homeownerModel;

  AddNewHomeownerSurvey({required this.homeownerModel});
}

class EditHomeownerSurvey extends SurveysEvent {
  final int id;
  final HomeownerModel homeownerModel;

  EditHomeownerSurvey({
    required this.id,
    required this.homeownerModel,
  });
}

class DeleteOneHomeownerSurvey extends SurveysEvent {
  final int id;

  DeleteOneHomeownerSurvey({required this.id});
}

class ExportExcelHomeownerSurvey extends SurveysEvent {}

class GetPainters extends SurveysEvent {
  final int page;

  GetPainters({
    required this.page,
  });
}

class GetHomeownerStatistics extends SurveysEvent {
  final String date1;
  final String date2;
  final String? regions;

  GetHomeownerStatistics({
    required this.date1,
    required this.date2,
    this.regions,
  });
}

class GetOnePainter extends SurveysEvent {
  final int id;
  GetOnePainter({required this.id});
}

class AddNewPainter extends SurveysEvent {
  final PaintersModel paintersModel;

  AddNewPainter({required this.paintersModel});
}

class EditPainter extends SurveysEvent {
  final int id;
  final PaintersModel paintersModel;

  EditPainter({
    required this.id,
    required this.paintersModel,
  });
}

class DeleteOnePainter extends SurveysEvent {
  final int id;

  DeleteOnePainter({required this.id});
}

class GetSalesSurveys extends SurveysEvent {
  final int page;

  GetSalesSurveys({
    required this.page,
  });
}

class GetOneSalesSurveys extends SurveysEvent {
  final int id;
  GetOneSalesSurveys({required this.id});
}

class AddNewSalesSurvey extends SurveysEvent {
  final SalesModel salesModel;

  AddNewSalesSurvey({required this.salesModel});
}

class EditSalesSurvey extends SurveysEvent {
  final int id;
  final SalesModel salesModel;

  EditSalesSurvey({
    required this.id,
    required this.salesModel,
  });
}

class DeleteOneSalesSurvey extends SurveysEvent {
  final int id;

  DeleteOneSalesSurvey({required this.id});
}

class ExportExcelSalesSurvey extends SurveysEvent {}

class GetProsAndCons extends SurveysEvent {}
