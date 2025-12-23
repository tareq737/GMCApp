part of 'surveys_bloc.dart';

@immutable
sealed class SurveysState {}

final class SurveysInitial extends SurveysState {}

class SurveysLoading extends SurveysState {}

class SurveysSuccess<T> extends SurveysState {
  final T result;

  SurveysSuccess({required this.result});
}

class SurveysError extends SurveysState {
  final String errorMessage;

  SurveysError({required this.errorMessage});
}

class SurveysSuccessProsandcons extends SurveysState {
  final List<ProsConsItem> pros;
  final List<ProsConsItem> cons;

  SurveysSuccessProsandcons({
    required this.pros,
    required this.cons,
  });

  @override
  List<Object> get props => [pros, cons];
}
