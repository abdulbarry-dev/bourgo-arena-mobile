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
    when(() => apiClient.hasToken).thenReturn(true);
    repository = ApiSubscriptionRepository(apiClient);
  });

  group('ApiSubscriptionRepository', () {
    test(
      'getActiveSubscriptions returns empty list when API returns empty data',
      () async {
        when(
          () => apiClient.get('/member/subscription', fullResponse: any(named: "fullResponse")),
        ).thenAnswer((_) async => {'data': []});

        final result = await repository.getActiveSubscriptions();

        expect(result, isA<Success<List<Subscription>, Failure>>());
        expect((result as Success<List<Subscription>, Failure>).data, isEmpty);
      },
    );

    test(
      'getActiveSubscriptions returns list of Subscriptions on success',
      () async {
        final tSubJson = {
          'data': [
            {
              'id': 1,
              'plan': {'id': 2, 'name': 'Gold', 'price': 100.0},
              'service': {'id': 1, 'name': 'Fitness & Gym', 'slug': 'fitness-gym'},
              'status': 'active',
              'starts_at': '2026-06-01',
              'ends_at': '2026-12-31',
              'days_remaining': 207,
              'payment_method': 'cash',
              'amount_paid': 129,
              'is_active': true,
              'receipt_url': null,
            },
          ],
        };
        when(
          () => apiClient.get('/member/subscription', fullResponse: any(named: "fullResponse")),
        ).thenAnswer((_) async => tSubJson);

        final result = await repository.getActiveSubscriptions();

        expect(result, isA<Success<List<Subscription>, Failure>>());
        final data = (result as Success<List<Subscription>, Failure>).data;
        expect(data, isNotEmpty);
        expect(data.first.plan?.name, 'Gold');
      },
    );

    test('subscribeToPlan returns success on API success', () async {
      when(
        () => apiClient.post('/subscriptions', {'plan_id': 'p1'}),
      ).thenAnswer((_) async => {});

      final result = await repository.subscribeToPlan('p1');

      expect(result, isA<Success<void, Failure>>());
      verify(
        () => apiClient.post('/subscriptions', {'plan_id': 'p1'}),
      ).called(1);
    });

    test('cancelSubscription returns success on API success', () async {
      when(
        () => apiClient.delete('/subscriptions/sub1'),
      ).thenAnswer((_) async => {});

      final result = await repository.cancelSubscription('sub1');

      expect(result, isA<Success<void, Failure>>());
      verify(() => apiClient.delete('/subscriptions/sub1')).called(1);
    });
  });
}
