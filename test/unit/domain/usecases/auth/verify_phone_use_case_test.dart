import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_phone_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late VerifyPhoneUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = VerifyPhoneUseCase(repository);
  });

  group('VerifyPhoneUseCase', () {
    test('calls repository.verifyPhone with correct parameters', () async {
      when(
        () => repository.verifyPhone('+15550000000', '123456'),
      ).thenAnswer((_) async => const Success(true));

      await useCase('+15550000000', '123456');

      verify(() => repository.verifyPhone('+15550000000', '123456')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns success when phone verification succeeds', () async {
      when(
        () => repository.verifyPhone('+15550000000', '123456'),
      ).thenAnswer((_) async => const Success(true));

      final result = await useCase('+15550000000', '123456');

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isTrue);
    });

    test('returns failure when phone verification fails', () async {
      const failure = ServerFailure(AppErrorCode.serverError, 'Invalid OTP');

      when(
        () => repository.verifyPhone('+15550000000', '999999'),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase('+15550000000', '999999');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
    });

    test('propagates auth failures from repository', () async {
      const failure = AuthFailure(
        AppErrorCode.invalidCredentials,
        'Unauthorized',
      );

      when(
        () => repository.verifyPhone('+15550000000', '123456'),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase('+15550000000', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
    });

    test('propagates network failures from repository', () async {
      const failure = NetworkFailure(
        AppErrorCode.networkUnavailable,
        'Connection timeout',
      );

      when(
        () => repository.verifyPhone('+15550000000', '123456'),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase('+15550000000', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      expect((result as FailureResult<bool, Failure>).failure, same(failure));
    });

    test('handles empty phone string', () async {
      when(() => repository.verifyPhone('', '123456')).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'Invalid phone'),
        ),
      );

      final result = await useCase('', '123456');

      expect(result, isA<FailureResult<bool, Failure>>());
      verify(() => repository.verifyPhone('', '123456')).called(1);
    });

    test('handles empty OTP string', () async {
      when(() => repository.verifyPhone('+15550000000', '')).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'Invalid OTP'),
        ),
      );

      final result = await useCase('+15550000000', '');

      expect(result, isA<FailureResult<bool, Failure>>());
      verify(() => repository.verifyPhone('+15550000000', '')).called(1);
    });

    test('returns false when verification returns false', () async {
      when(
        () => repository.verifyPhone('+15550000000', '000000'),
      ).thenAnswer((_) async => const Success(false));

      final result = await useCase('+15550000000', '000000');

      expect(result, isA<Success<bool, Failure>>());
      expect((result as Success<bool, Failure>).data, isFalse);
    });

    test('handles different phone number formats', () async {
      final phoneNumbers = [
        '+1-555-000-0000',
        '555-000-0000',
        '5550000000',
        '+1 (555) 000-0000',
      ];

      for (final phone in phoneNumbers) {
        when(
          () => repository.verifyPhone(phone, '123456'),
        ).thenAnswer((_) async => const Success(true));

        final result = await useCase(phone, '123456');

        expect(result, isA<Success<bool, Failure>>());
        verify(() => repository.verifyPhone(phone, '123456')).called(1);
      }
    });
  });
}
