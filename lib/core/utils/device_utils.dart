import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// Holds hardware and NFC information for the current device.
class DeviceNfcInfo {
  final String deviceIdentifier;
  final String deviceModel;
  final String osVersion;
  final bool nfcEnabled;
  final bool supportsHce;

  const DeviceNfcInfo({
    required this.deviceIdentifier,
    required this.deviceModel,
    required this.osVersion,
    required this.nfcEnabled,
    required this.supportsHce,
  });
}

/// Utility for gathering device-specific information related to NFC.
class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Retrieves the current device's hardware info and NFC capabilities.
  static Future<DeviceNfcInfo> getDeviceNfcInfo() async {
    String deviceIdentifier = 'unknown';
    String deviceModel = 'unknown';
    String osVersion = 'unknown';
    bool nfcEnabled = false;
    bool supportsHce = false;

    try {
      final availability = await NfcManager.instance.checkAvailability();
      nfcEnabled = availability == NfcAvailability.enabled;
      // On Android HCE is typically supported if NFC is present.
      // On iOS, true HCE (Host Card Emulation) for access control is currently restricted.
      supportsHce = Platform.isAndroid && nfcEnabled;
    } catch (_) {
      nfcEnabled = false;
      supportsHce = false;
    }

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceIdentifier = androidInfo.id;
        deviceModel = androidInfo.model;
        osVersion = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor ?? 'unknown';
        deviceModel = iosInfo.name;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      }
    } catch (_) {
      // Fallback to unknown if device info fails
    }

    return DeviceNfcInfo(
      deviceIdentifier: deviceIdentifier,
      deviceModel: deviceModel,
      osVersion: osVersion,
      nfcEnabled: nfcEnabled,
      supportsHce: supportsHce,
    );
  }
}
