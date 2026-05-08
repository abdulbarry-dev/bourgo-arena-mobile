import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RequestFamilyAccountOtpUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = RequestFamilyAccountOtpUseCase(repository);
  });

  group('RequestFamilyAccountOtpUseCase', () {
    test('returns success when request succeeds', () async {
      when(
        () => repository.requestFamilyAccountOtp(),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase();

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.requestFamilyAccountOtp()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure('otp request failed');

      when(
        () => repository.requestFamilyAccountOtp(),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.requestFamilyAccountOtp()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('can be invoked more than once without parameters', () async {
      when(
        () => repository.requestFamilyAccountOtp(),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      await useCase();
      await useCase();

      verify(() => repository.requestFamilyAccountOtp()).called(2);
      verifyNoMoreInteractions(repository);
    });
  });
}
