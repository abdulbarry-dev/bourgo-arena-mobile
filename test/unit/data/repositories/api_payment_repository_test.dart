import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_payment_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ApiPaymentRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = ApiPaymentRepository(mockApiClient);
    registerFallbackValue({'dummy': 'data'});
  });

  group('ApiPaymentRepository', () {
    test('getUserPayments returns success with list of payments', () async {
      final jsonResponse = {
        'data': [
          {
            'id': 'pay_1',
            'type': 'subscription',
            'amount': 50.0,
            'currency': 'EUR',
            'status': 'completed',
            'gateway': 'stripe',
            'payment_reference': 'ref123',
            'created_at': '2026-06-04T12:00:00Z',
          },
        ],
      };
      when(
        () => mockApiClient.get(any()),
      ).thenAnswer((_) async => jsonResponse);

      final result = await repository.getUserPayments(page: 1, limit: 15);

      check(result).isA<Success<dynamic, Failure>>();
      final payments = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(payments.length).equals(1);
      check(payments.first.id).equals('pay_1');

      verify(
        () => mockApiClient.get('/user/payments?page=1&per_page=15'),
      ).called(1);
    });

    test('initiatePayment returns success', () async {
      final jsonResponse = {
        'success': true,
        'payment_url': 'https://gateway.com/pay/123',
        'payment_reference': 'konnect_123',
      };

      when(
        () => mockApiClient.post('/payments/initiate', any()),
      ).thenAnswer((_) async => jsonResponse);

      final result = await repository.initiatePayment(
        amount: 100.0,
        provider: 'konnect',
      );

      check(result).isA<Success<dynamic, Failure>>();
      final data = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(data['payment_url']).equals('https://gateway.com/pay/123');
      check(data['payment_reference']).equals('konnect_123');

      verify(
        () => mockApiClient.post('/payments/initiate', {
          'amount': 100.0,
          'currency': 'TND',
          'provider': 'konnect',
        }),
      ).called(1);
    });

    test('verifyPayment returns success', () async {
      final jsonResponse = {'success': true, 'status': 'paid'};

      when(
        () => mockApiClient.post('/payments/verify', any()),
      ).thenAnswer((_) async => jsonResponse);

      final result = await repository.verifyPayment(
        paymentReference: 'konnect_123',
      );

      check(result).isA<Success<dynamic, Failure>>();
      final data = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(data['status']).equals('paid');

      verify(
        () => mockApiClient.post('/payments/verify', {
          'payment_reference': 'konnect_123',
        }),
      ).called(1);
    });
  });
}
