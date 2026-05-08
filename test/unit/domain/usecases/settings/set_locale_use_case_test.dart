import 'dart:ui';

import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository repository;
  late SetLocaleUseCase useCase;

  setUp(() {
    registerFallbackValue(const Locale('en'));
    repository = MockSessionRepository();
    useCase = SetLocaleUseCase(repository);
  });

  group('SetLocaleUseCase', () {
    test('returns success when locale persistence succeeds', () async {
      const locale = Locale('en', 'US');
      when(
        () => repository.setLocale(locale),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(locale);

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.setLocale(locale)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const locale = Locale('en', 'US');
      const failure = ValidationFailure('locale rejected');

      when(
        () => repository.setLocale(locale),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase(locale);

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.setLocale(locale)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards locale subtags unchanged', () async {
      final locale = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      when(
        () => repository.setLocale(locale),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(locale);

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.setLocale(locale)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
