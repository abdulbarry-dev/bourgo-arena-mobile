import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository repository;
  late SetNotificationsEnabledUseCase useCase;

  setUp(() {
    repository = MockSessionRepository();
    useCase = SetNotificationsEnabledUseCase(repository);
  });

  group('SetNotificationsEnabledUseCase', () {
    test('returns success when enabled is persisted', () async {
      when(
        () => repository.setNotificationsEnabled(true),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(true);

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.setNotificationsEnabled(true)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ValidationFailure(
        AppErrorCode.validationFailed,
        'preference rejected',
      );

      when(
        () => repository.setNotificationsEnabled(true),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase(true);

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.setNotificationsEnabled(true)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards false boundary values unchanged', () async {
      when(
        () => repository.setNotificationsEnabled(false),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(false);

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.setNotificationsEnabled(false)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
