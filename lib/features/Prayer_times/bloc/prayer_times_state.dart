part of 'prayer_times_bloc.dart';

@immutable
sealed class PrayerTimesState {}

final class PrayerTimesInitial extends PrayerTimesState {}

final class PrayerTimesGetSuccess extends PrayerTimesState {
  final PrayerTimesModel opResult;

  PrayerTimesGetSuccess({required this.opResult});
}

final class PrayerTimesLoading extends PrayerTimesState {}

final class PrayerTimesGetFailure extends PrayerTimesState {
  final String errorMessage;

  PrayerTimesGetFailure({required this.errorMessage});
}
