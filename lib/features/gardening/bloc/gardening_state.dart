part of 'gardening_bloc.dart';

@immutable
sealed class GardeningState {}

final class GardeningInitial extends GardeningState {}

class GardeningLoading extends GardeningState {}

class GardeningError extends GardeningState {
  final String errorMessage;

  GardeningError({required this.errorMessage});
}

class GardeningSuccess<T> extends GardeningState {
  final T result;

  GardeningSuccess({required this.result});
}

class GetWorkerSuccess<T> extends GardeningState {
  final T result;

  GetWorkerSuccess({required this.result});
}

class GardeningMailSuccess<T> extends GardeningState {
  final T result;

  GardeningMailSuccess({required this.result});
}

class GardeningExcelSuccess<T> extends GardeningState {
  final T result;

  GardeningExcelSuccess({required this.result});
}

class GardeningWorkerHoursSuccess<T> extends GardeningState {
  final T result;

  GardeningWorkerHoursSuccess({required this.result});
}
