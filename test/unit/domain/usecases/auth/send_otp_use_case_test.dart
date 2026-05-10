import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late SendOtpUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SendOtpUseCase(repository);
  });

  group('SendOtpUseCase', () {
    test('returns success when OTP send succeeds', () async {
      when(
        () => repository.sendOtp('alex@example.com'),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase('alex@example.com');

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.sendOtp('alex@example.com')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure('otp unavailable');

      when(
        () => repository.sendOtp('alex@example.com'),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase('alex@example.com');

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.sendOtp('alex@example.com')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards empty identifiers unchanged', () async {
      when(
        () => repository.sendOtp(''),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase('');

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.sendOtp('')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
