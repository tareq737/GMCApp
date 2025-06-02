import 'package:dio/dio.dart';
import 'package:gmcappclean/features/Prayer_times/models/prayer_times_model.dart';

class PrayerTimesService {
  Future<PrayerTimesModel?> getPrayerTimes(DateTime date) async {
    try {
      Dio dio = Dio();
      String stringDate = '${date.day}-${date.month}-${date.year}';
      Response response = await dio.get(
        'https://api.aladhan.com/v1/timingsByCity/$stringDate',
        queryParameters: {'city': 'damascus', 'country': 'syria'},
      );
      if (response.statusCode == 200) {
        return PrayerTimesModel.fromMap(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
