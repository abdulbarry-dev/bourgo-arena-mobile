import '../../domain/entities/digital_nfc_setup_response.dart';
import '../../domain/entities/digital_nfc_status.dart';
import '../../domain/entities/physical_nfc_status.dart';
import '../../domain/repositories/nfc_repository.dart';
import '../api/api_client.dart';
import '../mappers/nfc_mapper.dart';
import '../models/digital_nfc_setup_response_model.dart';
import '../models/digital_nfc_status_model.dart';
import '../models/physical_nfc_status_model.dart';

/// Implementation of the [NfcRepository] using [ApiClient].
class NfcRepositoryImpl implements NfcRepository {
  final ApiClient _apiClient;

  NfcRepositoryImpl(this._apiClient);

  @override
  Future<PhysicalNfcStatus> getPhysicalStatus() async {
    final response = await _apiClient.get('/member/nfc/physical-status');
    final model = PhysicalNfcStatusModel.fromJson(
      response as Map<String, dynamic>,
    );
    return model.toEntity();
  }

  @override
  Future<DigitalNfcStatus> getDigitalStatus({
    required String deviceModel,
    required String osVersion,
    required bool nfcEnabled,
    required bool supportsHce,
  }) async {
    final uri = Uri(
      path: '/member/nfc/digital-status',
      queryParameters: {
        'device_model': deviceModel,
        'os_version': osVersion,
        // Laravel boolean validation accepts 1/0 reliably in query strings.
        'nfc_enabled': nfcEnabled ? '1' : '0',
        'supports_hce': supportsHce ? '1' : '0',
      },
    );

    final response = await _apiClient.get(uri.toString());
    final model = DigitalNfcStatusModel.fromJson(
      response as Map<String, dynamic>,
    );
    return model.toEntity();
  }

  @override
  Future<DigitalNfcSetupResponse> setupDigitalNfc({
    required String deviceIdentifier,
    required String deviceModel,
    required String osVersion,
    required bool nfcEnabled,
    required bool supportsHce,
  }) async {
    final body = {
      'device_identifier': deviceIdentifier,
      'device_model': deviceModel,
      'os_version': osVersion,
      'nfc_enabled': nfcEnabled,
      'supports_hce': supportsHce,
    };

    final response = await _apiClient.post('/member/nfc/digital-setup', body);
    final model = DigitalNfcSetupResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
    return model.toEntity();
  }
}
