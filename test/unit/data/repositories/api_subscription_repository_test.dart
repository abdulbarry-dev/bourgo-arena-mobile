import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_subscription_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiSubscriptionRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ApiSubscriptionRepository(apiClient);
  });

  group('ApiSubscriptionRepository', () {
    test('getActiveSubscription returns null when API returns null', () async {
      when(
        () => apiClient.get('/member/subscription'),
      ).thenAnswer((_) async => null);

      final result = await repository.getActiveSubscription();

      expect(result, isA<Success<Subscription?, Failure>>());
      expect((result as Success<Subscription?, Failure>).data, isNull);
    });

    test('getActiveSubscription returns Subscription on 200', () async {
      final tSubJson = {
        'id': '1',
        'name': 'Gold',
        'price': 100.0,
        'benefits': ['access'],
        'duration_months': 12,
      };
      when(
        () => apiClient.get('/member/subscription'),
      ).thenAnswer((_) async => tSubJson);

      final result = await repository.getActiveSubscription();

      expect(result, isA<Success<Subscription?, Failure>>());
      final data = (result as Success<Subscription?, Failure>).data;
      expect(data?.name, 'Gold');
    });
  });
}
