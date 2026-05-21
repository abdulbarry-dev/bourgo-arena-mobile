import '../../core/utils/device_utils.dart';

/// Provider interface for retrieving device NFC information.
abstract class NfcDeviceInfoProvider {
  Future<DeviceNfcInfo> getDeviceInfo();
}
