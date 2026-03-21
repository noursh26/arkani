import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../services/onesignal_service.dart';
import '../utils/device_info_util.dart';
import '../utils/device_uuid_util.dart';
import '../utils/location_util.dart';

// Network
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiService(dioClient);
});

// Services
final oneSignalServiceProvider = Provider<OneSignalService>((ref) {
  final service = OneSignalService();
  // Initialize with API service when ready
  ref.onDispose(() {
    // Cleanup if needed
  });
  return service;
});

// Utils
final deviceInfoUtilProvider = Provider<DeviceInfoUtil>((ref) {
  return DeviceInfoUtil();
});

final deviceUuidUtilProvider = Provider<DeviceUuidUtil>((ref) {
  return DeviceUuidUtil();
});

final locationUtilProvider = Provider<LocationUtil>((ref) {
  return LocationUtil();
});
