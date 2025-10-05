part of 'hr_bloc.dart';

@immutable
sealed class HrState {}

final class HrInitial extends HrState {}

final class SuccessHR<T> extends HrInitial {
  final T result;

  SuccessHR({required this.result});
}

final class LoadingHR extends HrInitial {}

final class ErrorHR extends HrInitial {
  final String errorMessage;

  ErrorHR({required this.errorMessage});
}
