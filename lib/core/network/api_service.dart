import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  Dio get _dio => _dioClient.dio;

  // ==================== PRAYER ENDPOINTS ====================
  
  /// GET /api/v1/prayers/times
  /// Get prayer times for a location
  Future<Map<String, dynamic>> getPrayerTimes({
    required double lat,
    required double lng,
    String? date,
    int? method,
  }) async {
    return _requestWithRetry(
      () => _get('prayers/times', queryParameters: {
        'lat': lat,
        'lng': lng,
        if (date != null) 'date': date,
        if (method != null) 'method': method,
      }),
    );
  }

  // ==================== ADHKAR ENDPOINTS ====================
  
  /// GET /api/v1/adhkar/categories
  /// Get all adhkar categories
  Future<List<dynamic>> getAdhkarCategories() async {
    final response = await _requestWithRetry(() => _get('adhkar/categories'));
    return response['data'] ?? [];
  }

  /// GET /api/v1/adhkar/{slug}
  /// Get adhkar by category slug
  Future<Map<String, dynamic>> getAdhkarByCategory(String slug) async {
    return _requestWithRetry(() => _get('adhkar/$slug'));
  }

  // ==================== MOTIVATIONAL MESSAGE ENDPOINTS ====================
  
  /// GET /api/v1/messages/random
  /// Get random motivational message
  Future<Map<String, dynamic>> getRandomMessage({String? prayer}) async {
    return _requestWithRetry(
      () => _get('messages/random', queryParameters: {
        if (prayer != null) 'prayer': prayer,
      }),
    );
  }

  // ==================== ISLAMIC RULING ENDPOINTS ====================
  
  /// GET /api/v1/rulings/topics
  /// Get all ruling topics
  Future<List<dynamic>> getRulingTopics() async {
    final response = await _requestWithRetry(() => _get('rulings/topics'));
    return response['data'] ?? [];
  }

  /// GET /api/v1/rulings
  /// Get Islamic rulings with pagination and filters
  Future<Map<String, dynamic>> getRulings({
    int? topicId,
    String? search,
    int page = 1,
  }) async {
    return _requestWithRetry(
      () => _get('rulings', queryParameters: {
        if (topicId != null) 'topic_id': topicId,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
      }),
    );
  }

  // ==================== DAILY NOTIFICATION ENDPOINTS ====================
  
  /// GET /api/v1/notifications/today
  /// Get today's notification
  Future<Map<String, dynamic>?> getTodayNotification() async {
    final response = await _requestWithRetry(() => _get('notifications/today'));
    return response['data'] as Map<String, dynamic>?;
  }

  // ==================== MOSQUE ENDPOINTS ====================
  
  /// GET /api/v1/mosques/nearby
  /// Get nearby mosques
  Future<List<dynamic>> getNearbyMosques({
    required double lat,
    required double lng,
    int? radius,
  }) async {
    final response = await _requestWithRetry(
      () => _get('mosques/nearby', queryParameters: {
        'lat': lat,
        'lng': lng,
        if (radius != null) 'radius': radius,
      }),
    );
    return response['data'] ?? [];
  }

  // ==================== PRIVATE HELPER METHODS ====================

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Map<String, dynamic> _handleResponse(Response response) {
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    throw const ApiException('صيغة استجابة غير صالحة');
  }

  Exception _handleError(DioException error) {
    if (error.error is Exception) {
      return error.error as Exception;
    }
    return ApiException(
      error.message ?? 'حدث خطأ في الاتصال',
      statusCode: error.response?.statusCode,
    );
  }

  Future<T> _requestWithRetry<T>(Future<T> Function() request) async {
    return _dioClient.requestWithRetry(request: request);
  }
}
