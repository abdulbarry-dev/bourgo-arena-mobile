import '../../repositories/nfc_device_info_provider.dart';
import '../../entities/digital_nfc_status.dart';
import '../../repositories/nfc_repository.dart';

/// Use case for retrieving the digital NFC configuration status.
class GetDigitalNfcStatusUseCase {
  final NfcRepository _repository;
  final NfcDeviceInfoProvider _deviceInfoProvider;

  const GetDigitalNfcStatusUseCase(this._repository, this._deviceInfoProvider);

  Future<DigitalNfcStatus> call() async {
    final deviceNfcInfo = await _deviceInfoProvider.getDeviceInfo();
    return _repository.getDigitalStatus(
      deviceModel: deviceNfcInfo.deviceModel,
      osVersion: deviceNfcInfo.osVersion,
      nfcEnabled: deviceNfcInfo.nfcEnabled,
      supportsHce: deviceNfcInfo.supportsHce,
    );
  }
}
