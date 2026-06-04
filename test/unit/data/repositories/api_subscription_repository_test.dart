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
        'benefits': [{'label': 'access'}],
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
    test('subscribeToPlan returns success on API success', () async {
      when(
        () => apiClient.post('/subscriptions', {'plan_id': 'p1'}),
      ).thenAnswer((_) async => {});

      final result = await repository.subscribeToPlan('p1');

      expect(result, isA<Success<void, Failure>>());
      verify(() => apiClient.post('/subscriptions', {'plan_id': 'p1'})).called(1);
    });

    test('cancelSubscription returns success on API success', () async {
      when(
        () => apiClient.post('/subscriptions/sub1/cancel', {}),
      ).thenAnswer((_) async => {});

      final result = await repository.cancelSubscription('sub1');

      expect(result, isA<Success<void, Failure>>());
      verify(() => apiClient.post('/subscriptions/sub1/cancel', {})).called(1);
    });
  });
}
