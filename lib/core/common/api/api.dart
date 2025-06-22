// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/common/secrets/app_secrets.dart';
import 'package:gmcappclean/core/error/exceptions.dart';

class ApiClient {
  Dio dio;
  String baseURL = 'https://${AppSecrets.ip}:${AppSecrets.port}/api';
  //String baseURL = 'http://192.168.0.119/api';
  ApiClient({required this.dio}) {
    dio.interceptors.add(LogInterceptor(
      request: true, // Log request
      requestHeader: true, // Log request headers
      requestBody: true, // Log request body
      responseHeader: true, // Log response headers
      responseBody: true, // Log response body
      error: true,
      logPrint: (obj) => print(obj), // Log errors
    ));
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<Map<String, dynamic>> singIn({
    required String username,
    required String password,
    required String fcm_token,
  }) async {
    try {
      final data = {
        'username': username,
        'password': password,
        'fcm_token': fcm_token
      };
      final response = await dio.post('$baseURL/login', data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw const ServerException('response status code is not 200');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refreshToken(UserEntity user) async {
    try {
      final data = {'refresh': user.refreshToken};

      final response = await dio.post('$baseURL/token/refresh', data: data);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        throw const ServerException('response status code is not in the 200s');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> add({
    required UserEntity userTokens,
    required String endPoint,
    required String data,
  }) async {
    try {
      final response = await dio.post(
        '$baseURL/$endPoint',
        options: Options(
          headers: {'Authorization': 'Bearer ${userTokens.accessToken}'},
        ),
        data: data,
      );
      print('await is over');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print('status code is 200s');
        return response.data;
      } else {
        throw const ServerException('response status code is not in the 200s');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addById({
    required UserEntity userTokens,
    required String endPoint,
    String? data,
    required int id,
  }) async {
    try {
      print('reached api add');
      final response = await dio.post(
        '$baseURL/$endPoint/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${userTokens.accessToken}'},
        ),
        data: data,
      );
      print('await is over');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print('status code is 200s');
        return response.data;
      } else {
        throw const ServerException('response status code is not in the 200s');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<bool> delete(
      {required UserEntity user,
      required String endPoint,
      required int id}) async {
    try {
      final response = await dio.delete(
        '$baseURL/$endPoint/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateViaPut({
    required UserEntity user,
    required String endPoint,
    required String data,
    required int id,
  }) async {
    try {
      final response = await dio.put('$baseURL/$endPoint/$id',
          options: Options(
            headers: {'Authorization': 'Bearer ${user.accessToken}'},
          ),
          data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateViaPatch({
    required UserEntity user,
    required String endPoint,
    required String data,
    required int id,
  }) async {
    try {
      final response = await dio.patch('$baseURL/$endPoint/$id',
          options: Options(
            headers: {'Authorization': 'Bearer ${user.accessToken}'},
          ),
          data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> get({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get('$baseURL/$endPoint',
          options: Options(
            headers: {'Authorization': 'Bearer ${user.accessToken}'},
          ),
          queryParameters: queryParams);
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPageinated({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get('$baseURL/$endPoint',
          options: Options(
            headers: {'Authorization': 'Bearer ${user.accessToken}'},
          ),
          queryParameters: queryParams);
      if (response.statusCode == 200) {
        final data = response.data['results'];
        return (data as List<dynamic>).cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          return [];
        }
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getById({
    required UserEntity user,
    required String endPoint,
    required int id,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/$endPoint/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOneMap({
    required UserEntity user,
    required String endPoint,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/$endPoint',
        options: Options(
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> getImage({
    required UserEntity user,
    required String endPoint,
    required int id,
  }) async {
    try {
      Response<List<int>> response = await dio.get<List<int>>(
        '$baseURL/$endPoint/$id',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data!);
      } else {
        return Uint8List.fromList([]);
      }
    } catch (e) {
      print('error catch api');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addImageByID({
    required UserEntity userTokens,
    required String endPoint,
    required FormData? formData,
    required int id,
  }) async {
    print(formData!.files.toString());
    try {
      final response = await dio.post(
        '$baseURL/$endPoint/$id',
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Authorization': 'Bearer ${userTokens.accessToken}',
            "Content-Type": "multipart/form-data",
          },
        ),
        data: formData,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        throw const ServerException('response status code is not in the 200s');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<Uint8List> downloadFile({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response<List<int>> response = await dio.get<List<int>>(
        '$baseURL/$endPoint',
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data!);
      } else {
        return Uint8List.fromList([]);
      }
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }

  Future<Uint8List> downloadFilePost({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    try {
      Response<List<int>> response =
          await dio.post<List<int>>('$baseURL/$endPoint',
              queryParameters: queryParameters,
              options: Options(
                responseType: ResponseType.bytes,
                headers: {'Authorization': 'Bearer ${user.accessToken}'},
                receiveTimeout: const Duration(seconds: 30),
              ),
              data: data);
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data!);
      } else {
        return Uint8List.fromList([]);
      }
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }
}
