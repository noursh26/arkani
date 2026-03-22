import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import '../utils/device_info_util.dart';

class ApiInterceptor extends Interceptor {
  final DeviceInfoUtil _deviceInfoUtil = DeviceInfoUtil();
  
  // Cache device info to avoid repeated async calls
  static Map<String, String>? _cachedHeaders;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Use cached headers if available
    if (_cachedHeaders != null) {
      options.headers.addAll(_cachedHeaders!);
      handler.next(options);
      return;
    }

    // Check connectivity - skip if fails
    bool hasConnection = true; // Default to true to not block requests
    try {
      final result = await Connectivity().checkConnectivity() as List;
      // connectivity_plus 5.x returns List<ConnectivityResult>
      for (final r in result) {
        if (r != ConnectivityResult.none) {
          hasConnection = true;
          break;
        }
        hasConnection = false;
      }
    } catch (_) {
      // Skip connectivity check on error - proceed with request
    }
    
    if (!hasConnection) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const NetworkException('لا يوجد اتصال بالإنترنت'),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }

    // Add device headers with timeout
    try {
      final deviceInfo = await _deviceInfoUtil
          .getDeviceInfo()
          .timeout(const Duration(seconds: 2));
          
      _cachedHeaders = {
        'X-Device-ID': deviceInfo.deviceId,
        'X-Platform': deviceInfo.platform,
        'X-App-Version': deviceInfo.appVersion,
        'Accept-Language': 'ar',
      };
      options.headers.addAll(_cachedHeaders!);
    } catch (_) {
      options.headers['Accept-Language'] = 'ar';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if response follows our API format
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      
      if (data.containsKey('success') && data['success'] == false) {
        final message = data['message']?.toString() ?? 'حدث خطأ غير متوقع';
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: ApiException(message, statusCode: response.statusCode),
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = _handleDioError(err);
    handler.next(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: error,
    ));
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('انتهى وقت الانتظار، يرجى المحاولة مرة أخرى');
      
      case DioExceptionType.connectionError:
        return const NetworkException('لا يمكن الاتصال بالخادم، تأكد من اتصال الإنترنت');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        
        if (data is Map<String, dynamic>) {
          final message = data['message']?.toString() ?? _getDefaultErrorMessage(statusCode);
          return ApiException(message, statusCode: statusCode);
        }
        
        return ApiException(_getDefaultErrorMessage(statusCode), statusCode: statusCode);
      
      case DioExceptionType.cancel:
        return const RequestCancelledException('تم إلغاء الطلب');
      
      default:
        return const UnknownException('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
    }
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح';
      case 401:
        return 'غير مصرح';
      case 403:
        return 'غير مسموح بالوصول';
      case 404:
        return 'الصفحة غير موجودة';
      case 422:
        return 'بيانات غير صالحة';
      case 429:
        return 'تم إرسال طلبات كثيرة، يرجى الانتظار';
      case 500:
      case 502:
      case 503:
        return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
