part of 'hr_bloc.dart';

@immutable
sealed class HrState {}

final class HrInitial extends HrState {}

final class HRSuccess<T> extends HrInitial {
  final T result;

  HRSuccess({required this.result});
}

final class HRLoading extends HrInitial {}

final class HRError extends HrInitial {
  final String errorMessage;

  HRError({required this.errorMessage});
}

final class GetDepartmentEmployeesSuccess<T> extends HrInitial {
  final T result;

  GetDepartmentEmployeesSuccess({required this.result});
}

final class ImageSavedSuccess<T> extends HrInitial {
  final T result;

  ImageSavedSuccess({required this.result});
}

final class ExcelExportedSuccess<T> extends HrInitial {
  final T result;

  ExcelExportedSuccess({required this.result});
}
