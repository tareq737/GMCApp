part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent {}

final class SalesAddCustomer extends SalesEvent {
  final CustomerViewModel item;
  SalesAddCustomer({required this.item});
}

final class SalesUpdateCustomer extends SalesEvent {
  final CustomerViewModel item;
  SalesUpdateCustomer({required this.item});
}

final class SalesDelete<T> extends SalesEvent {
  final int id;

  SalesDelete({required this.id});
}

final class SalesGetById<T> extends SalesEvent {
  final int id;

  SalesGetById({required this.id});
}

final class SalesSearch<T> extends SalesEvent {
  final String lexum;

  SalesSearch({required this.lexum});
}

final class SalesGetAllPaginated<T> extends SalesEvent {
  final int page;
  final int? hasCood;
  final int? pageSize;
  final String? search;

  SalesGetAllPaginated(
      {required this.page, this.hasCood, this.pageSize, this.search});
}

class ExportExcelCustomers extends SalesEvent {}
