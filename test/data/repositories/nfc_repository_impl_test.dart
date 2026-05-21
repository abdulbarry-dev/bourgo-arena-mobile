import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/nfc_repository_impl.dart';
import 'package:bourgo_arena_mobile/domain/entities/physical_nfc_status.dart';
import 'package:bourgo_arena_mobile/domain/entities/digital_nfc_status.dart';
import 'package:bourgo_arena_mobile/domain/entities/digital_nfc_setup_response.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient apiClient;
  late NfcRepositoryImpl repository;

  setUp(() {
    apiClient = _MockApiClient();
    repository = NfcRepositoryImpl(apiClient);
  });

  group('NfcRepositoryImpl', () {
    test('getPhysicalStatus returns mapped entity', () async {
      final response = {
        'has_card': true,
        'card_uid': 'ABC123',
        'card_status': 'active',
        'is_ready': true,
        'fallback_methods': ['qr'],
      };

      when(() => apiClient.get(any())).thenAnswer((_) async => response);

      final result = await repository.getPhysicalStatus();

      expect(result, isA<PhysicalNfcStatus>());
      expect(result.hasCard, true);
      expect(result.cardUid, 'ABC123');
      expect(result.cardStatus, 'active');
      expect(result.isReady, true);
      expect(result.fallbackMethods, ['qr']);
      verify(() => apiClient.get('/api/v1/member/nfc/physical-status'));
    });

    test('getDigitalStatus sends query and returns mapped entity', () async {
      final response = {
        'supported': true,
        'configured': false,
        'eligible': true,
        'is_ready': false,
        'setup_status': 'not_configured',
        'reasons': ['hardware'],
        'fallback_methods': ['qr'],
      };

      when(() => apiClient.get(any())).thenAnswer((_) async => response);

      final result = await repository.getDigitalStatus(
        deviceModel: 'Pixel',
        osVersion: '13',
        nfcEnabled: true,
        supportsHce: false,
      );

      expect(result, isA<DigitalNfcStatus>());
      expect(result.supported, true);
      expect(result.configured, false);
      expect(result.eligible, true);
      expect(result.setupStatus, 'not_configured');
      expect(result.reasons, ['hardware']);
      expect(result.fallbackMethods, ['qr']);

      verify(
        () => apiClient.get(
          any(that: contains('/api/v1/member/nfc/digital-status')),
        ),
      );
    });

    test('setupDigitalNfc posts body and returns mapped entity', () async {
      final response = {
        'setup_status': 'completed',
        'supported': true,
        'eligible': true,
      };

      when(
        () => apiClient.post(any(), any()),
      ).thenAnswer((_) async => response);

      final result = await repository.setupDigitalNfc(
        deviceIdentifier: 'dev-1',
        deviceModel: 'Pixel',
        osVersion: '13',
        nfcEnabled: true,
        supportsHce: true,
      );

      expect(result, isA<DigitalNfcSetupResponse>());
      expect(result.setupStatus, 'completed');
      expect(result.supported, true);
      expect(result.eligible, true);

      verify(() => apiClient.post('/api/v1/member/nfc/digital-setup', any()));
    });
  });
}
