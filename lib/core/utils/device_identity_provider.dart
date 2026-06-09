import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';

class DeviceIdentityProvider {
  final Uuid _uuid = const Uuid();

  String generateDeviceId() => _uuid.v4();

  Future<String> getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return '1.0.0';
    }
  }

  String getPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return Platform.operatingSystem;
  }

  Future<Map<String, dynamic>> getDeviceFingerprint() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        return {
          'manufacturer': webInfo.vendor ?? 'Unknown',
          'model': webInfo.browserName.toString(),
          'os_version': webInfo.appVersion ?? 'Web',
        };
      }

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          'model': androidInfo.model,
          'os_version': androidInfo.version.release,
          'manufacturer': androidInfo.manufacturer,
        };
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          'model': iosInfo.model,
          'os_version': iosInfo.systemVersion,
          'manufacturer': 'Apple',
        };
      }

      return {};
    } catch (_) {
      return {};
    }
  }
}
