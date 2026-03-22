import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import '../utils/device_info_util.dart';

class ApiInterceptor extends Interceptor {
  final DeviceInfoUtil _deviceInfoUtil = DeviceInfoUtil();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check connectivity
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResult is List
          ? (connectivityResult as List).any((r) => r != ConnectivityResult.none)
          : connectivityResult != ConnectivityResult.none;
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
    } catch (_) {
      // If connectivity check fails, proceed anyway and let Dio handle errors
    }

    // Add device headers
    try {
      final deviceInfo = await _deviceInfoUtil.getDeviceInfo();
      options.headers.addAll({
        'X-Device-ID': deviceInfo.deviceId,
        'X-Platform': deviceInfo.platform,
        'X-App-Version': deviceInfo.appVersion,
        'Accept-Language': 'ar',
      });
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
