import 'package:dio/dio.dart';
import 'package:gmc/Purchases/models/brief_purchase_model.dart';
import 'package:gmc/Purchases/models/details_purchase_model.dart';
import 'package:gmc/core/api/auth.dart';
import 'package:gmc/core/api/url.dart';
import 'package:gmc/core/model/handling_models.dart';

Future<ResultModel> getBriefPurchase({String? section, String? status}) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = basicAuth;
  try {
    String url = '$baseURL/Purchases/Get_brief_Purchase.php';
    Map<String, dynamic> params = {};

    if (section != null && section.isNotEmpty) {
      params['section'] = section;
    }

    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }

    Response response = await dio.get(url, queryParameters: params);

    if (response.statusCode == 200) {
      List<BriefPurchaseModel> briefPurchase = List.generate(
        response.data.length,
        (index) => BriefPurchaseModel.fromMap(
          response.data[index],
        ),
      );
      return ListOf<BriefPurchaseModel>(data: briefPurchase);
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      return ErrorModel(message: response.data['message'] ?? 'خطأ غير معروف');
    } else {
      return ErrorModel(message: 'يرجى التأكد من الاتصال بالانترنت');
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
      return ErrorModel(
          message: e.response?.data['message'] ?? 'خطأ غير معروف');
    }
    return ErrorModel(message: 'خطأ في الوصول لقاعدة البيانات');
  } catch (e) {
    return ErrorModel(message: 'خطأ في الوصول لقاعدة البيانات');
  }
}

Future<ResultModel> getOnePurchase({required int pur_id}) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = basicAuth;
  try {
    String url = '$baseURL/Purchases/Get_one.php';
    Map<String, dynamic> params = {"pur_id": pur_id};

    Response response = await dio.get(url, queryParameters: params);
    if (response.statusCode == 200) {
      // Parse the response data directly as a single map
      DetailsPurchaseModel detailsPurchase =
          DetailsPurchaseModel.fromMap(response.data);
      return Single(data: detailsPurchase);
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      return ErrorModel(message: response.data['message'] ?? 'خطأ غير معروف');
    } else {
      return ErrorModel(message: 'يرجى التأكد من الاتصال بالانترنت');
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
      return ErrorModel(
          message: e.response?.data['message'] ?? 'خطأ غير معروف');
    }
    return ErrorModel(message: 'خطأ في الوصول لقاعدة البيانات');
  } catch (e) {
    return ErrorModel(message: 'خطأ في الوصول لقاعدة البيانات');
  }
}
