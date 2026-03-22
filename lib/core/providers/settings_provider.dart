import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for font size settings
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

/// Provider for timezone settings
final timezoneProvider = StateNotifierProvider<TimezoneNotifier, String>((ref) {
  return TimezoneNotifier();
});

const String _fontSizeKey = 'adhkar_font_size';
const double _defaultFontSize = 18.0;
const double _minFontSize = 14.0;
const double _maxFontSize = 28.0;
const double _fontSizeStep = 2.0;

const String _timezoneKey = 'user_timezone';
const String _defaultTimezone = 'Asia/Riyadh';

// Available timezones for prayer times
const Map<String, String> availableTimezones = {
  'Asia/Riyadh': 'الرياض (GMT+3)',
  'Asia/Makkah': 'مكة المكرمة (GMT+3)',
  'Asia/Dubai': 'دبي (GMT+4)',
  'Asia/Kuwait': 'الكويت (GMT+3)',
  'Asia/Qatar': 'قطر (GMT+3)',
  'Asia/Bahrain': 'البحرين (GMT+3)',
  'Asia/Amman': 'عمان (GMT+3)',
  'Asia/Beirut': 'بيروت (GMT+2)',
  'Asia/Cairo': 'القاهرة (GMT+2)',
  'Asia/Jerusalem': 'القدس (GMT+2)',
  'Africa/Casablanca': 'الدار البيضاء (GMT+1)',
  'Europe/London': 'لندن (GMT+0)',
  'Europe/Paris': 'باريس (GMT+1)',
  'America/New_York': 'نيويورك (GMT-5)',
  'America/Los_Angeles': 'لوس أنجلوس (GMT-8)',
  'Asia/Tokyo': 'طوكيو (GMT+9)',
  'Asia/Singapore': 'سنغافورة (GMT+8)',
  'Australia/Sydney': 'سيدني (GMT+10)',
};

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(_defaultFontSize) {
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSize = prefs.getDouble(_fontSizeKey);
    if (savedSize != null && savedSize >= _minFontSize && savedSize <= _maxFontSize) {
      state = savedSize;
    }
  }

  Future<void> setFontSize(double size) async {
    final clampedSize = size.clamp(_minFontSize, _maxFontSize);
    state = clampedSize;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, clampedSize);
  }

  Future<void> increaseFontSize() async {
    final newSize = (state + _fontSizeStep).clamp(_minFontSize, _maxFontSize);
    await setFontSize(newSize);
  }

  Future<void> decreaseFontSize() async {
    final newSize = (state - _fontSizeStep).clamp(_minFontSize, _maxFontSize);
    await setFontSize(newSize);
  }

  bool get canIncrease => state < _maxFontSize;
  bool get canDecrease => state > _minFontSize;
  
  double get minSize => _minFontSize;
  double get maxSize => _maxFontSize;
}

class TimezoneNotifier extends StateNotifier<String> {
  TimezoneNotifier() : super(_defaultTimezone) {
    _loadTimezone();
  }

  Future<void> _loadTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimezone = prefs.getString(_timezoneKey);
    if (savedTimezone != null && availableTimezones.containsKey(savedTimezone)) {
      state = savedTimezone;
    }
  }

  Future<void> setTimezone(String timezone) async {
    if (availableTimezones.containsKey(timezone)) {
      state = timezone;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_timezoneKey, timezone);
    }
  }

  String get currentTimezoneLabel => availableTimezones[state] ?? state;
  
  String get timezoneOffset {
    final offset = availableTimezones[state] ?? '';
    final match = RegExp(r'GMT([+-]\d+)').firstMatch(offset);
    return match != null ? 'UTC${match.group(1)}' : 'UTC+3';
  }
}
