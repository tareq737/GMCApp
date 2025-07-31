part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsSuccess<T> extends StatisticsState {
  final T result;

  StatisticsSuccess({required this.result});
}

class StatisticsError extends StatisticsState {
  final String errorMessage;

  StatisticsError({required this.errorMessage});
}
