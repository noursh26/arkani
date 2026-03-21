import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

/// Service for managing local notifications for prayer times
class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _prayerNotificationChannelId = 'prayer_times_channel';
  static const String _prayerNotificationChannelName = 'مواقيت الصلاة';
  static const String _prayerNotificationChannelDesc = 'تنبيهات مواقيت الصلاة';

  /// Initialize the local notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');

    // iOS initialization
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    _initialized = true;

    if (kDebugMode) {
      print('LocalNotificationService initialized successfully');
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _prayerNotificationChannelId,
      _prayerNotificationChannelName,
      description: _prayerNotificationChannelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule a notification for a specific prayer time
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    if (!_initialized) await initialize();

    // Cancel existing notification with same ID
    await cancelNotification(id);

    // Check if prayer time is in the future
    final now = DateTime.now();
    if (prayerTime.isBefore(now)) {
      if (kDebugMode) {
        print('Prayer time $prayerName is in the past, skipping notification');
      }
      return;
    }

    final notificationText = 'حان وقت صلاة $prayerName، استجب لنداء ربك 🕌';

    final androidDetails = AndroidNotificationDetails(
      _prayerNotificationChannelId,
      _prayerNotificationChannelName,
      channelDescription: _prayerNotificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound('adhan'),
      styleInformation: const BigTextStyleInformation(''),
      autoCancel: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adhan.caf',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    // Convert to TZDateTime for scheduling
    final tzPrayerTime = tz.TZDateTime.from(prayerTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      'وقت الصلاة',
      notificationText,
      tzPrayerTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    if (kDebugMode) {
      print('Scheduled notification for $prayerName at $prayerTime');
    }
  }

  /// Schedule all 5 daily prayers
  Future<void> scheduleDailyPrayers({
    required DateTime fajrTime,
    required DateTime dhuhrTime,
    required DateTime asrTime,
    required DateTime maghribTime,
    required DateTime ishaTime,
  }) async {
    await schedulePrayerNotification(id: 1, prayerName: 'الفجر', prayerTime: fajrTime);
    await schedulePrayerNotification(id: 2, prayerName: 'الظهر', prayerTime: dhuhrTime);
    await schedulePrayerNotification(id: 3, prayerName: 'العصر', prayerTime: asrTime);
    await schedulePrayerNotification(id: 4, prayerName: 'المغرب', prayerTime: maghribTime);
    await schedulePrayerNotification(id: 5, prayerName: 'العشاء', prayerTime: ishaTime);

    if (kDebugMode) {
      print('All daily prayers scheduled successfully');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // Navigation is handled by the router based on notification type
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final iosPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return false;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (!_initialized) await initialize();

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? false;
    }

    return true; // For iOS, assume enabled
  }
}
