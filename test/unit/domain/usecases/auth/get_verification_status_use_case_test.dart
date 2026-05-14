import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../data/repositories/repository_test_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late GetVerificationStatusUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = GetVerificationStatusUseCase(repository);
  });

  group('GetVerificationStatusUseCase', () {
    test('calls repository.getVerificationStatus', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: true,
        phoneVerified: false,
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      await useCase();

      verify(() => repository.getVerificationStatus()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns verification status when both methods verified', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: true,
        phoneVerified: true,
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      final result = await useCase();

      expect(result, isA<Success<VerificationStatus, Failure>>());
      final status = (result as Success<VerificationStatus, Failure>).data;
      expect(status.emailVerified, isTrue);
      expect(status.phoneVerified, isTrue);
      expect(status.isFullyVerified, isTrue);
      expect(status.unverifiedMethod, isNull);
    });

    test('returns verification status when only email verified', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: true,
        phoneVerified: false,
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      final result = await useCase();

      expect(result, isA<Success<VerificationStatus, Failure>>());
      final status = (result as Success<VerificationStatus, Failure>).data;
      expect(status.emailVerified, isTrue);
      expect(status.phoneVerified, isFalse);
      expect(status.isPartiallyVerified, isTrue);
      expect(status.isFullyVerified, isFalse);
      expect(status.unverifiedMethod, 'phone');
    });

    test('returns verification status when only phone verified', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: false,
        phoneVerified: true,
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      final result = await useCase();

      expect(result, isA<Success<VerificationStatus, Failure>>());
      final status = (result as Success<VerificationStatus, Failure>).data;
      expect(status.emailVerified, isFalse);
      expect(status.phoneVerified, isTrue);
      expect(status.isPartiallyVerified, isTrue);
      expect(status.isFullyVerified, isFalse);
      expect(status.unverifiedMethod, 'email');
    });

    test('returns verification status when neither method verified', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: false,
        phoneVerified: false,
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      final result = await useCase();

      expect(result, isA<Success<VerificationStatus, Failure>>());
      final status = (result as Success<VerificationStatus, Failure>).data;
      expect(status.emailVerified, isFalse);
      expect(status.phoneVerified, isFalse);
      expect(status.isPartiallyVerified, isFalse);
      expect(status.isFullyVerified, isFalse);
    });

    test('returns failure when repository call fails', () async {
      const failure = ServerFailure('Failed to fetch status');

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<VerificationStatus, Failure>>());
      expect(
        (result as FailureResult<VerificationStatus, Failure>).failure,
        same(failure),
      );
    });

    test('propagates auth failures from repository', () async {
      const failure = AuthFailure('Unauthorized - token expired');

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<VerificationStatus, Failure>>());
      expect(
        (result as FailureResult<VerificationStatus, Failure>).failure,
        same(failure),
      );
    });

    test('propagates network failures from repository', () async {
      const failure = NetworkFailure('No internet connection');

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => FailureResult(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<VerificationStatus, Failure>>());
      expect(
        (result as FailureResult<VerificationStatus, Failure>).failure,
        same(failure),
      );
    });

    test('returns correct email and phone values', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: true,
        phoneVerified: false,
        email: 'user@example.com',
        phone: '+1234567890',
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      final result = await useCase();

      expect(result, isA<Success<VerificationStatus, Failure>>());
      final status = (result as Success<VerificationStatus, Failure>).data;
      expect(status.email, 'user@example.com');
      expect(status.phone, '+1234567890');
    });

    test('handles null email and phone values', () async {
      final verificationStatus = testVerificationStatusEntity(
        emailVerified: true,
        phoneVerified: false,
        email: null,
        phone: null,
      );

      when(
        () => repository.getVerificationStatus(),
      ).thenAnswer((_) async => Success(verificationStatus));

      final result = await useCase();

      expect(result, isA<Success<VerificationStatus, Failure>>());
      final status = (result as Success<VerificationStatus, Failure>).data;
      expect(status.email, isNull);
      expect(status.phone, isNull);
    });
  });
}
