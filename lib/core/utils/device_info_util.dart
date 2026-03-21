import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/device_uuid_util.dart';

class DeviceInfo {
  final String deviceId;
  final String platform;
  final String appVersion;
  final String? model;
  final String? brand;
  final String? osVersion;

  DeviceInfo({
    required this.deviceId,
    required this.platform,
    required this.appVersion,
    this.model,
    this.brand,
    this.osVersion,
  });
}

class DeviceInfoUtil {
  static final DeviceInfoUtil _instance = DeviceInfoUtil._internal();
  factory DeviceInfoUtil() => _instance;
  DeviceInfoUtil._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final DeviceUuidUtil _uuidUtil = DeviceUuidUtil();

  Future<DeviceInfo> getDeviceInfo() async {
    final deviceId = await _uuidUtil.getDeviceUuid();
    final platform = Platform.operatingSystem;
    final packageInfo = await PackageInfo.fromPlatform();

    String? model;
    String? brand;
    String? osVersion;

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      model = androidInfo.model;
      brand = androidInfo.brand;
      osVersion = 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      model = iosInfo.model;
      brand = 'Apple';
      osVersion = 'iOS ${iosInfo.systemVersion}';
    }

    return DeviceInfo(
      deviceId: deviceId,
      platform: platform,
      appVersion: packageInfo.version,
      model: model,
      brand: brand,
      osVersion: osVersion,
    );
  }
}
