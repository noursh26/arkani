import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'config/env_config.dart';
import 'config/router.dart';
import 'core/constants/app_constants.dart';
import 'core/database/hive_config.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(AppConstants.systemUiOverlayStyle);

  // Initialize timezone data
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  // Initialize environment
  await EnvConfig.initialize(Environment.development);

  // Initialize Hive
  await HiveConfig.initialize();

  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    const ProviderScope(
      child: ArkaniApp(),
    ),
  );
}

class ArkaniApp extends ConsumerStatefulWidget {
  const ArkaniApp({super.key});

  @override
  ConsumerState<ArkaniApp> createState() => _ArkaniAppState();
}

class _ArkaniAppState extends ConsumerState<ArkaniApp> {
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _setupNotificationCallbacks();
  }

  void _setupNotificationCallbacks() {
    // Handle notification received while app is open
    _notificationService.onNotificationReceived = (title, body, type) {
      _showInAppNotification(title, body);
    };

    // Handle notification tap when app is in background/closed
    _notificationService.onNotificationTapped = (type) {
      final route = NotificationService.getRouteForNotificationType(type);
      if (route != null && mounted) {
        context.go(route);
      }
    };
  }

  void _showInAppNotification(String title, String body) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (body.isNotEmpty)
              Text(
                body,
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'إغلاق',
          textColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Localization - Arabic only
      locale: const Locale('ar', ''),
      supportedLocales: const [
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // RTL Layout
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      // Router
      routerConfig: AppRouter.router,
    );
  }
}
