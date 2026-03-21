import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/env_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_service.dart';
import '../../core/utils/device_info_util.dart';

/// Callback types for OneSignal events
typedef OnNotificationReceived = void Function(String title, String body, String? type);
typedef OnNotificationTapped = void Function(String? type);

class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  final DeviceInfoUtil _deviceInfoUtil = DeviceInfoUtil();
  ApiService? _apiService;
  bool _initialized = false;

  // Callbacks for notification handling
  OnNotificationReceived? onNotificationReceived;
  OnNotificationTapped? onNotificationTapped;

  /// Initialize OneSignal
  Future<void> initialize({ApiService? apiService}) async {
    if (_initialized) return;

    _apiService = apiService;

    // Set log level based on environment
    OneSignal.Debug.setLogLevel(
      EnvConfig.isDevelopment ? OSLogLevel.verbose : OSLogLevel.none,
    );

    // Initialize OneSignal
    OneSignal.initialize(EnvConfig.oneSignalAppId);

    // Set up notification event handlers
    _setupNotificationHandlers();

    // Listen for subscription changes
    OneSignal.User.pushSubscription.addObserver((state) {
      _onSubscriptionChanged(state.current);
    });

    // Check if already subscribed
    final currentState = OneSignal.User.pushSubscription;
    if (currentState.id != null) {
      await _registerDeviceWithBackend(currentState.id!);
    }

    _initialized = true;
  }

  /// Set up notification event handlers
  void _setupNotificationHandlers() {
    // Handle notification received while app is open
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();

      final title = event.notification.title ?? 'أركاني';
      final body = event.notification.body ?? '';
      final additionalData = event.notification.additionalData;
      final type = additionalData?['type'] as String?;

      if (kDebugMode) {
        print('Notification received in foreground: $title - $body (type: $type)');
      }

      // Trigger the callback to show in-app snackbar
      onNotificationReceived?.call(title, body, type);

      // Display the notification
      event.notification.display();
    });

    // Handle notification tap (when app is in background or closed)
    OneSignal.Notifications.addClickListener((event) {
      final additionalData = event.notification.additionalData;
      final type = additionalData?['type'] as String?;

      if (kDebugMode) {
        print('Notification tapped (background/closed): type=$type');
      }

      // Trigger the callback for navigation
      onNotificationTapped?.call(type);
    });
  }

  /// Get the route based on notification type
  static String? getRouteForNotificationType(String? type) {
    switch (type) {
      case 'khulq':
        return '/'; // home
      case 'nafl':
        return '/'; // home
      case 'dua':
        return '/adhkar';
      case 'reminder':
        return '/';
      default:
        return '/';
    }
  }

  void _onSubscriptionChanged(OSPushSubscriptionState state) async {
    if (state.id != null) {
      await _registerDeviceWithBackend(state.id!);
    }
  }

  Future<void> _registerDeviceWithBackend(String playerId) async {
    if (_apiService == null) return;

    try {
      final deviceInfo = await _deviceInfoUtil.getDeviceInfo();
      
      // Save player ID locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.oneSignalPlayerIdKey, playerId);

      // Register with backend
      await _apiService!.registerDevice(
        deviceId: deviceInfo.deviceId,
        playerId: playerId,
        platform: deviceInfo.platform,
        appVersion: deviceInfo.appVersion,
      );

      if (kDebugMode) {
        print('Device registered successfully with playerId: $playerId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to register device: $e');
      }
    }
  }

  Future<String?> getPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.oneSignalPlayerIdKey);
  }

  // Set external user ID (if needed for user identification)
  Future<void> setExternalUserId(String userId) async {
    await OneSignal.login(userId);
  }

  // Logout user
  Future<void> logout() async {
    await OneSignal.logout();
  }

  // Add tag for segmentation
  Future<void> setTag(String key, String value) async {
    await OneSignal.User.addTagWithKey(key, value);
  }

  // Remove tag
  Future<void> removeTag(String key) async {
    await OneSignal.User.removeTag(key);
  }

  /// Check if permission has been requested before
  Future<bool> hasRequestedPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onesignal_permission_requested') ?? false;
  }

  /// Mark permission as requested
  Future<void> markPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onesignal_permission_requested', true);
  }

  /// Request notification permission (native dialog)
  Future<void> requestPermissionNative() async {
    await OneSignal.Notifications.requestPermission(true);
    await markPermissionRequested();
  }

  /// Get current notification permission status
  Future<bool> hasNotificationPermission() async {
    return OneSignal.Notifications.permission ?? false;
  }
}
