import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, production }

class EnvConfig {
  EnvConfig._();

  static late Environment _environment;
  static bool _initialized = false;

  static Future<void> initialize(Environment env) async {
    if (_initialized) return;
    
    _environment = env;
    final envFile = env == Environment.production 
        ? '.env.production' 
        : '.env.development';
    
    await dotenv.load(fileName: envFile);
    _initialized = true;
  }

  static Environment get environment => _environment;
  
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;

  static String get appName => _getOrDefault('APP_NAME', 'أركاني');
  static String get apiBaseUrl => _getOrDefault('API_BASE_URL', 'https://arkani.almostfa.site/api/v1/');

  static String _getOrDefault(String key, String defaultValue) {
    if (!_initialized) {
      debugPrint('WARNING: EnvConfig not initialized. Returning default value for $key');
      return defaultValue;
    }
    return dotenv.env[key] ?? defaultValue;
  }
}
