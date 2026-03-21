import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import '../../config/env_config.dart';
import '../constants/app_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        sendTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.addAll([
      ApiInterceptor(),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => print(object.toString()),
      ),
    ]);
  }

  Dio get dio => _dio;

  Future<T> requestWithRetry<T>({
    required Future<T> Function() request,
  }) async {
    return retry(
      request,
      retryIf: (e) => e is DioException && _isRetryableError(e),
      maxAttempts: AppConstants.maxRetries,
      delayFactor: const Duration(seconds: AppConstants.retryDelaySeconds),
    );
  }

  bool _isRetryableError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null && 
         error.response!.statusCode! >= 500);
  }
}
