import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../errors/app_exception.dart';

typedef TokenProvider = FutureOr<String?> Function();

class ApiClient {
  ApiClient({
    required String baseUrl,
    required TokenProvider tokenProvider,
    FutureOr<void> Function()? onUnauthorized,
    bool enableLogging = false,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 20),
           receiveTimeout: const Duration(seconds: 20),
           sendTimeout: const Duration(seconds: 20),
           headers: const {'Content-Type': 'application/json'},
         ),
       ),
       _tokenProvider = tokenProvider,
       _onUnauthorized = onUnauthorized {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresAuth = options.extra['auth'] != false;
          if (requiresAuth) {
            final token = await _tokenProvider();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final authRequired = error.requestOptions.extra['auth'] != false;
          if (statusCode == 401 && authRequired && _onUnauthorized != null) {
            await _onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );

    if (enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }
  }

  final Dio _dio;
  final TokenProvider _tokenProvider;
  final FutureOr<void> Function()? _onUnauthorized;

  Future<T> request<T>(
    String path, {
    String method = 'GET',
    bool authenticated = true,
    Map<String, dynamic>? queryParameters,
    Object? body,
    T Function(dynamic data)? parser,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      debugPrint('[API] $method ${_dio.options.baseUrl}$path started');
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method, extra: {'auth': authenticated}),
      );
      debugPrint(
        '[API] $method $path completed: HTTP ${response.statusCode} in ${stopwatch.elapsedMilliseconds}ms',
      );

      final data = response.data;
      if (parser != null) {
        return parser(data);
      }

      return data as T;
    } on DioException catch (error) {
      debugPrint(
        '[API] $method $path failed: ${error.type}, HTTP ${error.response?.statusCode ?? '-'} in ${stopwatch.elapsedMilliseconds}ms',
      );
      throw _mapError(error);
    } catch (error) {
      debugPrint(
        '[API] $method $path failed: $error in ${stopwatch.elapsedMilliseconds}ms',
      );
      throw AppException(AppErrorMessages.generic);
    }
  }

  AppException _mapError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    String message = AppErrorMessages.generic;
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      message = AppErrorMessages.network;
    } else if (statusCode == 401) {
      message = AppErrorMessages.unauthorized;
    } else if (responseData is Map<String, dynamic>) {
      message = (responseData['message'] ?? responseData['error'] ?? message)
          .toString();
    } else if (responseData is String && responseData.trim().isNotEmpty) {
      message = responseData;
    }

    return AppException(message, statusCode: statusCode);
  }
}
