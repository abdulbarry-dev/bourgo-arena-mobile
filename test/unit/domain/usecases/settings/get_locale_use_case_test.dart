import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository repository;
  late GetLocaleUseCase useCase;
  late GetThemeModeUseCase getThemeUseCase;

  setUp(() {
    registerFallbackValue(const Locale('en'));
    repository = MockSessionRepository();
    useCase = GetLocaleUseCase(repository);
    getThemeUseCase = GetThemeModeUseCase(repository);
  });

  group('GetLocaleUseCase', () {
    test('returns the stored locale on success', () async {
      const locale = Locale('en');
      when(
        () => repository.getLocale(),
      ).thenAnswer((_) async => const Success<Locale, Failure>(locale));

      final result = await useCase();

      expect(result, isA<Success<Locale, Failure>>());
      expect((result as Success<Locale, Failure>).data, locale);
      verify(() => repository.getLocale()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = CacheFailure('locale missing');

      when(
        () => repository.getLocale(),
      ).thenAnswer((_) async => const FailureResult<Locale, Failure>(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<Locale, Failure>>());
      expect((result as FailureResult<Locale, Failure>).failure, same(failure));
      verify(() => repository.getLocale()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns a non-country locale unchanged', () async {
      const locale = Locale('fr');
      when(
        () => repository.getLocale(),
      ).thenAnswer((_) async => const Success<Locale, Failure>(locale));

      final result = await useCase();

      expect(result, isA<Success<Locale, Failure>>());
      expect((result as Success<Locale, Failure>).data.languageCode, 'fr');
      verify(() => repository.getLocale()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });

  group('GetThemeModeUseCase', () {
    test('returns the stored theme mode on success', () async {
      const mode = ThemeMode.dark;
      when(
        () => repository.getThemeMode(),
      ).thenAnswer((_) async => const Success<ThemeMode, Failure>(mode));

      final result = await getThemeUseCase();

      expect(result, isA<Success<ThemeMode, Failure>>());
      expect((result as Success<ThemeMode, Failure>).data, mode);
      verify(() => repository.getThemeMode()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = CacheFailure('theme mode missing');

      when(() => repository.getThemeMode()).thenAnswer(
        (_) async => const FailureResult<ThemeMode, Failure>(failure),
      );

      final result = await getThemeUseCase();

      expect(result, isA<FailureResult<ThemeMode, Failure>>());
      expect(
        (result as FailureResult<ThemeMode, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getThemeMode()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
