import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_payment.dart';
import 'package:bourgo_arena_mobile/domain/repositories/loyalty_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_loyalty_payments_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoyaltyRepository extends Mock implements LoyaltyRepository {}

void main() {
  late MockLoyaltyRepository repository;
  late GetLoyaltyPaymentsUseCase useCase;

  setUp(() {
    repository = MockLoyaltyRepository();
    useCase = GetLoyaltyPaymentsUseCase(repository);
  });

  test('returns payments on success', () async {
    final tPayments = [
      const LoyaltyPayment(
        id: 'lp_1',
        points: 100,
        description: 'Redeemed',
        status: 'completed',
        createdAt: '2026-06-10T08:00:00.000000Z',
      ),
    ];
    when(
      () => repository.getLoyaltyPayments(),
    ).thenAnswer((_) async => Success(tPayments));

    final result = await useCase();

    expect(result, isA<Success<List<LoyaltyPayment>, Failure>>());
    expect((result as Success).data, hasLength(1));
  });

  test('propagates repository failures', () async {
    when(() => repository.getLoyaltyPayments()).thenAnswer(
      (_) async => FailureResult(
        const NetworkFailure(AppErrorCode.networkUnavailable, 'offline'),
      ),
    );

    final result = await useCase();

    expect(result, isA<FailureResult<List<LoyaltyPayment>, Failure>>());
  });
}
