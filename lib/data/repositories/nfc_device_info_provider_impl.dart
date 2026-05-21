import '../../core/utils/device_utils.dart';
import '../../domain/repositories/nfc_device_info_provider.dart';

/// Implementation of [NfcDeviceInfoProvider] using [DeviceUtils].
class NfcDeviceInfoProviderImpl implements NfcDeviceInfoProvider {
  const NfcDeviceInfoProviderImpl();

  @override
  Future<DeviceNfcInfo> getDeviceInfo() {
    return DeviceUtils.getDeviceNfcInfo();
  }
}
