// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'operations_bloc.dart';

@immutable
sealed class OperationsEvent {}

class GetAllVisits extends OperationsEvent {}

class AddNewVisit extends OperationsEvent {
  final VisitModel visitModel;

  AddNewVisit({required this.visitModel});
}

class AddNewCall extends OperationsEvent {
  final CallModel callModel;

  AddNewCall({required this.callModel});
}

class GetAllOperationsForCustomer extends OperationsEvent {
  final int customerID;

  GetAllOperationsForCustomer({required this.customerID});
}

class GetAllOperationsForDate extends OperationsEvent {
  final String date1;
  final String date2;
  final String? reception;
  final bool? paid_money;
  final bool? bill;
  final int page;
  final String? type;

  GetAllOperationsForDate({
    required this.date1,
    required this.date2,
    this.reception,
    this.paid_money,
    this.bill,
    this.page = 1,
    this.type,
  });
}

class EditCall extends OperationsEvent {
  final int id;
  final CallModel callModel;

  EditCall({
    required this.id,
    required this.callModel,
  });
}

class EditVisit extends OperationsEvent {
  final int id;
  final VisitModel visitModel;

  EditVisit({
    required this.id,
    required this.visitModel,
  });
}

class ExportExcelOperations extends OperationsEvent {
  final String fromDate;
  final String toDate;
  final String type;

  ExportExcelOperations(
      {required this.fromDate, required this.toDate, required this.type});
}
