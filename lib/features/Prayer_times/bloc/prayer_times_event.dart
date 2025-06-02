// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'prayer_times_bloc.dart';

@immutable
sealed class PrayerTimesEvent {}

final class GetPrayerTimes extends PrayerTimesEvent {
  final DateTime date;
  GetPrayerTimes({
    required this.date,
  });
}
