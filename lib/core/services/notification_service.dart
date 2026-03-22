import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

/// Callback types for notification events
typedef OnNotificationReceived = void Function(String title, String body, String? type);
typedef OnNotificationTapped = void Function(String? type);

/// Service for managing local notifications (no external service required)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Callbacks for notification handling
  OnNotificationReceived? onNotificationReceived;
  OnNotificationTapped? onNotificationTapped;

  static const String _prayerNotificationChannelId = 'prayer_times_channel';
  static const String _prayerNotificationChannelName = 'مواقيت الصلاة';
  static const String _prayerNotificationChannelDesc = 'تنبيهات مواقيت الصلاة';
  
  static const String _adhkarNotificationChannelId = 'adhkar_channel';
  static const String _adhkarNotificationChannelName = 'الأذكار';
  static const String _adhkarNotificationChannelDesc = 'تنبيهات الأذكار اليومية';
  
  static const String _generalNotificationChannelId = 'general_channel';
  static const String _generalNotificationChannelName = 'إشعارات عامة';
  static const String _generalNotificationChannelDesc = 'إشعارات متنوعة';

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

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

    // Create notification channels for Android
    await _createNotificationChannels();

    _initialized = true;

    if (kDebugMode) {
      print('NotificationService initialized successfully');
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin == null) return;

    // Prayer times channel
    final prayerChannel = AndroidNotificationChannel(
      _prayerNotificationChannelId,
      _prayerNotificationChannelName,
      description: _prayerNotificationChannelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound('adhan'),
    );
    await androidPlugin.createNotificationChannel(prayerChannel);

    // Adhkar channel
    final adhkarChannel = AndroidNotificationChannel(
      _adhkarNotificationChannelId,
      _adhkarNotificationChannelName,
      description: _adhkarNotificationChannelDesc,
      importance: Importance.defaultImportance,
      playSound: true,
      enableVibration: true,
    );
    await androidPlugin.createNotificationChannel(adhkarChannel);

    // General channel
    final generalChannel = AndroidNotificationChannel(
      _generalNotificationChannelId,
      _generalNotificationChannelName,
      description: _generalNotificationChannelDesc,
      importance: Importance.defaultImportance,
      playSound: true,
      enableVibration: true,
    );
    await androidPlugin.createNotificationChannel(generalChannel);
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (kDebugMode) {
      print('Notification tapped: $payload');
    }
    onNotificationTapped?.call(payload);
  }

  /// Get the route based on notification type
  static String? getRouteForNotificationType(String? type) {
    switch (type) {
      case 'khulq':
        return '/';
      case 'nafl':
        return '/';
      case 'dua':
        return '/adhkar';
      case 'reminder':
        return '/';
      default:
        return '/';
    }
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? type,
    String channelId = _generalNotificationChannelId,
    String? channelName,
  }) async {
    if (!_initialized) await initialize();

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName ?? _generalNotificationChannelName,
      channelDescription: _generalNotificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      styleInformation: const BigTextStyleInformation(''),
      autoCancel: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: type,
    );

    // Trigger callback for in-app handling
    onNotificationReceived?.call(title, body, type);
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? type,
    String channelId = _generalNotificationChannelId,
  }) async {
    if (!_initialized) await initialize();

    // Cancel existing notification with same ID
    await cancelNotification(id);

    // Check if time is in the future
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      if (kDebugMode) {
        print('Scheduled time is in the past, skipping notification');
      }
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _generalNotificationChannelName,
      channelDescription: _generalNotificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      styleInformation: const BigTextStyleInformation(''),
      autoCancel: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: type,
    );

    if (kDebugMode) {
      print('Scheduled notification for $scheduledTime');
    }
  }

  /// Schedule a prayer time notification
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
      payload: 'prayer_$prayerName',
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

  /// Schedule a daily adhkar reminder
  Future<void> scheduleAdhkarReminder({
    required DateTime reminderTime,
  }) async {
    if (!_initialized) await initialize();

    const id = 100;
    
    // Cancel existing notification
    await cancelNotification(id);

    final androidDetails = AndroidNotificationDetails(
      _adhkarNotificationChannelId,
      _adhkarNotificationChannelName,
      channelDescription: _adhkarNotificationChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: true,
      styleInformation: const BigTextStyleInformation(''),
      autoCancel: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final tzReminderTime = tz.TZDateTime.from(reminderTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      'أذكار الصباح والمساء',
      'لا تنسَ أذكارك اليومية 📿',
      tzReminderTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'adhkar',
    );

    if (kDebugMode) {
      print('Adhkar reminder scheduled for $reminderTime');
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

  /// Check if permission has been requested before
  Future<bool> hasRequestedPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_permission_requested') ?? false;
  }

  /// Mark permission as requested
  Future<void> markPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_permission_requested', true);
  }
}
