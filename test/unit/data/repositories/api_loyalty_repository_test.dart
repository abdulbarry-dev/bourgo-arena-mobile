import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_loyalty_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_payment.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiLoyaltyRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    when(() => apiClient.hasToken).thenReturn(true);
    repository = ApiLoyaltyRepository(apiClient);
  });

  group('ApiLoyaltyRepository', () {
    group('getLoyaltyPayments', () {
      test('returns list of LoyaltyPayment on 200', () async {
        final tPayments = {
          'data': [
            {
              'id': 'lp_1',
              'points': 100,
              'description': 'Redeemed for Padel session',
              'status': 'completed',
              'created_at': '2026-06-10T08:00:00.000000Z',
            },
          ],
        };
        when(
          () => apiClient.get(
            '/loyalty/payments',
            fullResponse: any(named: 'fullResponse'),
          ),
        ).thenAnswer((_) async => tPayments);

        final result = await repository.getLoyaltyPayments();

        expect(result, isA<Success<List<LoyaltyPayment>, Failure>>());
        final data = (result as Success<List<LoyaltyPayment>, Failure>).data;
        expect(data, hasLength(1));
        expect(data.first.points, 100);
        expect(data.first.status, 'completed');
      });

      test('returns empty list when not authenticated', () async {
        when(() => apiClient.hasToken).thenReturn(false);

        final result = await repository.getLoyaltyPayments();

        expect(result, isA<Success<List<LoyaltyPayment>, Failure>>());
        expect(
          (result as Success<List<LoyaltyPayment>, Failure>).data,
          isEmpty,
        );
      });

      test('returns Failure on error', () async {
        when(
          () => apiClient.get(
            '/loyalty/payments',
            fullResponse: any(named: 'fullResponse'),
          ),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.getLoyaltyPayments();

        expect(result, isA<FailureResult<List<LoyaltyPayment>, Failure>>());
        expect(
          (result as FailureResult<List<LoyaltyPayment>, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });
  });
}
