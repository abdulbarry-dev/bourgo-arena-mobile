import '../../repositories/nfc_device_info_provider.dart';
import '../../entities/digital_nfc_setup_response.dart';
import '../../repositories/nfc_repository.dart';

/// Use case for setting up digital NFC.
class SetupDigitalNfcUseCase {
  final NfcRepository _repository;
  final NfcDeviceInfoProvider _deviceInfoProvider;

  const SetupDigitalNfcUseCase(this._repository, this._deviceInfoProvider);

  Future<DigitalNfcSetupResponse> call() async {
    final deviceNfcInfo = await _deviceInfoProvider.getDeviceInfo();
    return _repository.setupDigitalNfc(
      deviceIdentifier: deviceNfcInfo.deviceIdentifier,
      deviceModel: deviceNfcInfo.deviceModel,
      osVersion: deviceNfcInfo.osVersion,
      nfcEnabled: deviceNfcInfo.nfcEnabled,
      supportsHce: deviceNfcInfo.supportsHce,
    );
  }
}
