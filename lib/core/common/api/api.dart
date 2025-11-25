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
    dio.interceptors.add(
      LogInterceptor(
        request: true, // Log request
        requestHeader: true, // Log request headers
        requestBody: true, // Log request body
        responseHeader: true, // Log response headers
        responseBody: true, // Log response body
        error: true,
        logPrint: (obj) => print(obj), // Log errors
      ),
    );
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
        'fcm_token': fcm_token,
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

  Future<void> clearFcmToken(String fcmToken) async {
    try {
      final response = await dio.post(
        '$baseURL/remove_fcm_token',
        data: {'token': fcmToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('✅ FCM token cleared successfully');
      } else {
        print('⚠️ Failed to clear FCM token: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('❌ Dio error (${e.response?.statusCode}): ${e.response?.data}');
        throw ServerException(e.response!.data.toString());
      } else {
        print('❌ Network or unexpected error: ${e.message}');
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> add({
    required UserEntity userTokens,
    required String endPoint,
    required String data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        '$baseURL/$endPoint',
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userTokens.accessToken}',
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 500) {
        return response.data;
      } else {
        final msg = response.data is Map && response.data['error'] != null
            ? response.data['error'].toString()
            : response.data.toString();
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        // Check for 'detail' field first (your current API format)
        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        }
        // Then check for 'error' field (if you have other APIs that use this)
        else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
        }
        // If neither field exists, use the whole response as string
        else {
          throw ServerException(responseData.toString());
        }
      } else {
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> addById({
    required UserEntity userTokens,
    required String endPoint,
    Map? data,
    required int id,
  }) async {
    try {
      final response = await dio.post(
        '$baseURL/$endPoint/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userTokens.accessToken}',
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        final msg = response.data is Map && response.data['error'] != null
            ? response.data['error'].toString()
            : response.data.toString();
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        // Check for 'detail' field first (your current API format)
        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        }
        // Then check for 'error' field (if you have other APIs that use this)
        else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
          // Then check for '__all__' field
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        }
        // If neither field exists, use the whole response as string
        else {
          throw ServerException(responseData.toString());
        }
      } else {
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<bool> delete({
    required UserEntity user,
    required String endPoint,
    required int id,
  }) async {
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
      final response = await dio.put(
        '$baseURL/$endPoint/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user.accessToken}',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null,
        ),
        data: data,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        final responseData = response.data;

        // Check for 'detail' field first
        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        }
        // Then check for 'error' field
        else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
          // Then check for '__all__' field
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        }
        // If neither field exists, use the whole response as string
        else {
          throw ServerException(responseData.toString());
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        // Check for 'detail' field first
        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        }
        // Then check for 'error' field
        else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
          // Then check for '__all__' field
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        }
        // If neither field exists, use the whole response as string
        else {
          throw ServerException(responseData.toString());
        }
      } else {
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateViaPatch({
    required UserEntity user,
    required String endPoint,
    required String data,
    required int id,
  }) async {
    try {
      final response = await dio.patch(
        '$baseURL/$endPoint/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user.accessToken}',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null,
        ),
        data: data,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        final responseData = response.data;

        // Check for 'detail' field first
        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        }
        // Then check for 'error' field
        else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
          // Then check for '__all__' field
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        }
        // If neither field exists, use the whole response as string
        else {
          throw ServerException(responseData.toString());
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        // Check for 'detail' field first
        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        }
        // Then check for 'error' field
        else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
          // Then check for '__all__' field
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        }
        // If neither field exists, use the whole response as string
        else {
          throw ServerException(responseData.toString());
        }
      } else {
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> get({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/$endPoint',
        options: Options(
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
        ),
        queryParameters: queryParams,
      );
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
      final response = await dio.get(
        '$baseURL/$endPoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user.accessToken}',
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: queryParams,
      );

      // ✅ Handle successful response
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data['results'];
        return (data as List<dynamic>).cast<Map<String, dynamic>>();
      }

      // ✅ Handle known server responses (non-200)
      final responseData = response.data;

      // If backend says "Invalid page." → just return empty list
      if (responseData is Map && responseData['detail'] == 'Invalid page.') {
        return [];
      }

      // ✅ Handle "No objects found." → return empty list
      if (responseData is Map &&
          responseData['detail'] == 'No objects found.') {
        return [];
      }

      // Common error messages
      if (responseData is Map && responseData['detail'] != null) {
        throw ServerException(responseData['detail'].toString());
      } else if (responseData is Map && responseData['error'] != null) {
        throw ServerException(responseData['error'].toString());
      } else {
        throw ServerException(responseData.toString());
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        // ✅ Handle "Invalid page." inside Dio error too
        if (responseData is Map && responseData['detail'] == 'Invalid page.') {
          return [];
        }

        // ✅ Handle "No objects found." inside Dio error too
        if (responseData is Map &&
            responseData['detail'] == 'No objects found.') {
          return [];
        }

        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        } else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        } else {
          throw ServerException(responseData.toString());
        }
      } else {
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<PaginatedResponse> getPageinatedWithCount({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/$endPoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user.accessToken}',
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: queryParams,
      );

      // ✅ Handle successful response
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;

        final count = data['count'] is int ? data['count'] as int : null;
        final results =
            (data['results'] as List<dynamic>).cast<Map<String, dynamic>>();

        return PaginatedResponse(results: results, count: count);
      }

      // ✅ Handle known non-200 responses
      final responseData = response.data;
      if (responseData is Map && responseData['detail'] == 'Invalid page.') {
        return PaginatedResponse(results: [], count: 0);
      }
      if (responseData is Map &&
          responseData['detail'] == 'No objects found.') {
        return PaginatedResponse(results: [], count: 0);
      }

      if (responseData is Map && responseData['detail'] != null) {
        throw ServerException(responseData['detail'].toString());
      } else if (responseData is Map && responseData['error'] != null) {
        throw ServerException(responseData['error'].toString());
      } else {
        throw ServerException(responseData.toString());
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData is Map && responseData['detail'] == 'Invalid page.') {
          return PaginatedResponse(results: [], count: 0);
        }
        if (responseData is Map &&
            responseData['detail'] == 'No objects found.') {
          return PaginatedResponse(results: [], count: 0);
        }

        if (responseData is Map && responseData['detail'] != null) {
          throw ServerException(responseData['detail'].toString());
        } else if (responseData is Map && responseData['error'] != null) {
          throw ServerException(responseData['error'].toString());
        } else if (responseData is Map && responseData['__all__'] != null) {
          throw ServerException(responseData['__all__'].toString());
        } else {
          throw ServerException(responseData.toString());
        }
      } else {
        throw const ServerException('Network or server error occurred.');
      }
    } catch (e) {
      throw ServerException(e.toString());
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

  Future<Map<String, dynamic>?> getOneMap({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/$endPoint',
        options: Options(
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
        ),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List?> getOneList({
    required UserEntity user,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/$endPoint',
        options: Options(
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
        ),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
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
    Map<String, dynamic>? data,
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
        data: data,
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
      Response<List<int>> response = await dio.post<List<int>>(
        '$baseURL/$endPoint',
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer ${user.accessToken}'},
          receiveTimeout: const Duration(seconds: 30),
        ),
        data: data,
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
}

class PaginatedResponse {
  final List<Map<String, dynamic>> results;
  final int? count;

  PaginatedResponse({required this.results, this.count});
}
