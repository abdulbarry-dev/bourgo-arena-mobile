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

    test('subscribeToPlan returns subscription on API success', () async {
      final tSubResp = {
        'data': {
          'id': 43,
          'plan': {'id': '3', 'name': 'Premium', 'price': 149.999, 'has_all_courses': true},
          'service': {'id': '1', 'name': 'Fitness', 'slug': 'fitness', 'image_url': 'https://img.com/f.jpg', 'status': 'active'},
          'status': 'pending',
          'starts_at': '2026-06-15',
          'ends_at': null,
          'days_remaining': 0,
          'payment_method': 'konnect',
          'amount_paid': 0.0,
          'is_active': false,
          'receipt_url': null,
        },
      };
      when(
        () => apiClient.post('/subscriptions', {'plan_id': 'p1'}),
      ).thenAnswer((_) async => tSubResp);

      final result = await repository.subscribeToPlan('p1');

      expect(result, isA<Success<Subscription, Failure>>());
      final sub = (result as Success<Subscription, Failure>).data;
      expect(sub.id, '43');
      expect(sub.status, 'pending');
      expect(sub.amountPaid, 0.0);
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
