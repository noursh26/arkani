import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/env_config.dart';
import 'config/router.dart';
import 'core/constants/app_constants.dart';
import 'core/database/hive_config.dart';
import 'core/services/onesignal_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(AppConstants.systemUiOverlayStyle);

  // Initialize environment
  await EnvConfig.initialize(Environment.development);

  // Initialize Hive
  await HiveConfig.initialize();

  // Initialize OneSignal
  final oneSignalService = OneSignalService();
  await oneSignalService.initialize();

  runApp(
    const ProviderScope(
      child: ArkaniApp(),
    ),
  );
}

class ArkaniApp extends StatelessWidget {
  const ArkaniApp({super.key});

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
