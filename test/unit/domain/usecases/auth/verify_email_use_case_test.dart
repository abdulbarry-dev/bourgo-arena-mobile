import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_email_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late VerifyEmailUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = VerifyEmailUseCase(repository);
  });

  group('VerifyEmailUseCase', () {
    test('calls repository.verifyEmail with correct parameters', () async {
      when(
        () => repository.verifyEmail('alex@example.com', '123456'),
      ).thenAnswer((_) async => const Success(true));

      await useCase('alex@example.com', '123456');

      verify(
        () => repository.verifyEmail('alex@example.com', '123456'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns success when email verification succeeds', () async {
      when(
        () => repository.verifyEmail('alex@example.com', '123456'),
      ).thenAnswer((_) async => const Success(true));

      final result = await useCase('alex@example.com', '123456');

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isTrue);
    });

    test('returns failure when email verification fails', () async {
      const failure = ServerFailure('Invalid OTP');

      when(
        () => repository.verifyEmail('alex@example.com', '999999'),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase('alex@example.com', '999999');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
    });

    test('propagates auth failures from repository', () async {
      const failure = AuthFailure('Unauthorized');

      when(
        () => repository.verifyEmail('alex@example.com', '123456'),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase('alex@example.com', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
    });

    test('propagates network failures from repository', () async {
      const failure = NetworkFailure('Connection timeout');

      when(
        () => repository.verifyEmail('alex@example.com', '123456'),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase('alex@example.com', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
    });

    test('handles empty email string', () async {
      when(
        () => repository.verifyEmail('', '123456'),
      ).thenAnswer((_) async => FailureResult(AuthFailure('Invalid email')));

      final result = await useCase('', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      verify(() => repository.verifyEmail('', '123456')).called(1);
    });

    test('handles empty OTP string', () async {
      when(
        () => repository.verifyEmail('alex@example.com', ''),
      ).thenAnswer((_) async => FailureResult(AuthFailure('Invalid OTP')));

      final result = await useCase('alex@example.com', '');

      expect(result, isA<FailureResult<bool, Failure>>());
      verify(() => repository.verifyEmail('alex@example.com', '')).called(1);
    });

    test('returns false when verification returns false', () async {
      when(
        () => repository.verifyEmail('alex@example.com', '000000'),
      ).thenAnswer((_) async => const Success(false));

      final result = await useCase('alex@example.com', '000000');

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isFalse);
    });
  });
}
