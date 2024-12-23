import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gmc/Auth/model/auth_model.dart';
import 'package:gmc/core/api/auth.dart';
import 'package:gmc/core/api/url.dart';
import 'package:gmc/core/model/handling_models.dart';

Future<ResultModel> loginService({
  required String Username,
  required String Password,
}) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = basicAuth;

  try {
    String url = '$baseURL/auth/login.php';
    Map<String, dynamic> params = {
      'Username': Username,
      'Password': Password,
    };

    // Print the data being sent
    print('Sending request to $url');
    print('Request data: $params');

    Response response = await dio.post(url, data: FormData.fromMap(params));

    // Print the response received
    print('Response status code: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      // Decode the response data if it is a JSON string
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData); // Decode if it's a JSON string
      }

      // Parse the decoded response data into an AuthModel
      AuthModel authModel = AuthModel.fromMap(responseData);

      return Single<AuthModel>(data: authModel);
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      return ErrorModel(message: response.data['message'] ?? 'خطأ غير معروف');
    } else {
      return ErrorModel(message: 'يرجى التأكد من الاتصال بالانترنت');
    }
  } on DioException catch (e) {
    // Print the exception details
    print('DioException occurred: $e');
    if (e.response != null) {
      print('Error response status code: ${e.response?.statusCode}');
      print('Error response data: ${e.response?.data}');
    }

    if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
      return ErrorModel(
          message: e.response?.data['message'] ?? 'خطأ غير معروف');
    }
    return ErrorModel(message: 'خطأ في الوصول لقاعدة البيانات');
  } catch (e) {
    // Print the general exception details
    print('Exception occurred: $e');
    return ErrorModel(message: 'خطأ في الوصول لقاعدة البيانات');
  }
}
