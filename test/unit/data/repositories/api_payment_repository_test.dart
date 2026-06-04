import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_payment_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
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
  });

  group('ApiPaymentRepository', () {
    test('getUserPayments returns success with list of payments', () async {
      // Arrange
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
          }
        ]
      };
      when(() => mockApiClient.get(any())).thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.getUserPayments(page: 1, limit: 15);

      // Assert
      check(result).isA<Success>();
      final payments = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(payments.length).equals(1);
      check(payments.first.id).equals('pay_1');
      check(payments.first.amount).equals(50.0);
      
      verify(() => mockApiClient.get('/user/payments?page=1&per_page=15')).called(1);
    });

    test('getUserPayments returns failure on exception', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getUserPayments();

      // Assert
      check(result).isA<FailureResult>();
      final failure = result.fold(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (f) => f,
      );
      check(failure).isA<ServerFailure>();
      check(failure.code).equals(AppErrorCode.serverError);
    });
  });
}
