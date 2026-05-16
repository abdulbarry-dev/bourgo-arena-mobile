import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late VerifyOtpUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = VerifyOtpUseCase(repository);
  });

  group('VerifyOtpUseCase', () {
    test('returns success when OTP verification succeeds', () async {
      when(
        () => repository.verifyOtp('alex@example.com', '123456'),
      ).thenAnswer((_) async => const Success<bool, Failure>(true));

      final result = await useCase('alex@example.com', '123456');

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isTrue);
      verify(
        () => repository.verifyOtp('alex@example.com', '123456'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = AuthFailure(
        AppErrorCode.invalidCredentials,
        'invalid otp',
      );

      when(
        () => repository.verifyOtp('alex@example.com', '123456'),
      ).thenAnswer((_) async => const FailureResult<bool, Failure>(failure));

      final result = await useCase('alex@example.com', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
      verify(
        () => repository.verifyOtp('alex@example.com', '123456'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards boundary OTP values unchanged', () async {
      when(
        () => repository.verifyOtp('', '000000'),
      ).thenAnswer((_) async => const Success<bool, Failure>(false));

      final result = await useCase('', '000000');

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isFalse);
      verify(() => repository.verifyOtp('', '000000')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
