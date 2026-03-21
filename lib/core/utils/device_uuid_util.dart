import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';

class DeviceUuidUtil {
  static final DeviceUuidUtil _instance = DeviceUuidUtil._internal();
  factory DeviceUuidUtil() => _instance;
  DeviceUuidUtil._internal();

  String? _cachedUuid;

  Future<String> getDeviceUuid() async {
    if (_cachedUuid != null) return _cachedUuid!;

    final prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString(AppConstants.deviceUuidKey);

    if (uuid == null || uuid.isEmpty) {
      uuid = const Uuid().v4();
      await prefs.setString(AppConstants.deviceUuidKey, uuid);
    }

    _cachedUuid = uuid;
    return uuid;
  }

  Future<void> clearUuid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.deviceUuidKey);
    _cachedUuid = null;
  }
}
