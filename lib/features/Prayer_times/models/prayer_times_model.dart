// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PrayerTimesModel {
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;
  String date;
  String hijriDay;
  String weekday;
  String hijiMonth;
  String hijriYear;
  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.hijriDay,
    required this.weekday,
    required this.hijiMonth,
    required this.hijriYear,
  });

  factory PrayerTimesModel.fromMap(Map<String, dynamic> map) {
    return PrayerTimesModel(
      fajr: map['data']['timings']['Fajr'] as String,
      sunrise: map['data']['timings']['Sunrise'] as String,
      dhuhr: map['data']['timings']['Dhuhr'] as String,
      asr: map['data']['timings']['Asr'] as String,
      maghrib: map['data']['timings']['Maghrib'] as String,
      isha: map['data']['timings']['Isha'] as String,
      date: map['data']['date']['timestamp'] as String,
      hijriDay: map['data']['date']['hijri']['day'] as String,
      weekday: map['data']['date']['hijri']['weekday']['ar'] as String,
      hijiMonth: map['data']['date']['hijri']['month']['ar'] as String,
      hijriYear: map['data']['date']['hijri']['year'] as String,
    );
  }

  factory PrayerTimesModel.fromJson(String source) =>
      PrayerTimesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PrayerTimesModel(fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, asr: $asr, maghrib: $maghrib, isha: $isha, date: $date, hijriDay: $hijriDay, weekday: $weekday, hijiMonth: $hijiMonth, hijriYear: $hijriYear)';
  }
}
