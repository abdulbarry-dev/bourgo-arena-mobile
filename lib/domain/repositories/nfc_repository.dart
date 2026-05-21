import '../entities/digital_nfc_setup_response.dart';
import '../entities/digital_nfc_status.dart';
import '../entities/physical_nfc_status.dart';

/// Repository interface for NFC operations.
abstract class NfcRepository {
  /// Retrieves the physical NFC card status for the current member.
  Future<PhysicalNfcStatus> getPhysicalStatus();

  /// Retrieves the digital NFC configuration status for the current member.
  ///
  /// The payload requires device information to determine if the device is supported.
  Future<DigitalNfcStatus> getDigitalStatus({
    required String deviceModel,
    required String osVersion,
    required bool nfcEnabled,
    required bool supportsHce,
  });

  /// Initiates or completes the digital NFC setup for the given device.
  Future<DigitalNfcSetupResponse> setupDigitalNfc({
    required String deviceIdentifier,
    required String deviceModel,
    required String osVersion,
    required bool nfcEnabled,
    required bool supportsHce,
  });
}
