part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsEvent {}

class GetStatistics extends StatisticsEvent {
  final String date_1;
  final String date_2;

  GetStatistics({
    required this.date_1,
    required this.date_2,
  });
}
