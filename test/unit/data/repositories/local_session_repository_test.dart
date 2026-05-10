import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/repositories/local_session_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences prefs;
  late LocalSessionRepository repository;

  setUp(() {
    prefs = MockSharedPreferences();
    repository = LocalSessionRepository(prefs);
  });

  group('LocalSessionRepository', () {
    group('auth token storage', () {
      test('saveAuthToken stores the token under the session key', () async {
        when(
          () => prefs.setString('auth_token', 'token-123'),
        ).thenAnswer((_) async => true);

        final result = await repository.saveAuthToken('token-123');

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.setString('auth_token', 'token-123')).called(1);
      });

      test('getAuthToken returns the stored token', () async {
        when(() => prefs.getString('auth_token')).thenReturn('token-123');

        final result = await repository.getAuthToken();

        expect(result, isA<Success<String?, Failure>>());
        expect((result as Success<String?, Failure>).data, 'token-123');
        verify(() => prefs.getString('auth_token')).called(1);
      });

      test('clearSession removes every session key atomically', () async {
        when(() => prefs.remove('auth_token')).thenAnswer((_) async => true);

        final result = await repository.clearSession();

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.remove('auth_token')).called(1);
        verifyNoMoreInteractions(prefs);
      });

      test(
        'saveAuthToken returns CacheFailure when SharedPreferences throws',
        () async {
          when(
            () => prefs.setString('auth_token', 'token-123'),
          ).thenThrow(Exception('boom'));

          final result = await repository.saveAuthToken('token-123');

          expect(result, isA<FailureResult<void, Failure>>());
          expect(
            (result as FailureResult<void, Failure>).failure,
            isA<CacheFailure>(),
          );
        },
      );
    });

    group('theme preferences', () {
      test('getThemeMode returns system when no value is stored', () async {
        when(() => prefs.getString('settings_theme_mode')).thenReturn(null);

        final result = await repository.getThemeMode();

        expect(result, isA<Success<ThemeMode, Failure>>());
        expect((result as Success<ThemeMode, Failure>).data, ThemeMode.system);
      });

      test('setThemeMode stores the mode name', () async {
        when(
          () => prefs.setString('settings_theme_mode', 'dark'),
        ).thenAnswer((_) async => true);

        final result = await repository.setThemeMode(ThemeMode.dark);

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.setString('settings_theme_mode', 'dark')).called(1);
      });
    });

    group('locale and onboarding', () {
      test('getLocale returns English when no locale is stored', () async {
        when(() => prefs.getString('settings_locale')).thenReturn(null);

        final result = await repository.getLocale();

        expect(result, isA<Success<Locale, Failure>>());
        expect((result as Success<Locale, Failure>).data.languageCode, 'en');
      });

      test(
        'setLocale stores the locale and marks language as selected',
        () async {
          when(
            () => prefs.setString('settings_locale', 'fr'),
          ).thenAnswer((_) async => true);
          when(
            () => prefs.setBool('settings_language_selected', true),
          ).thenAnswer((_) async => true);

          final result = await repository.setLocale(const Locale('fr'));

          expect(result, isA<Success<void, Failure>>());
          verify(() => prefs.setString('settings_locale', 'fr')).called(1);
          verify(
            () => prefs.setBool('settings_language_selected', true),
          ).called(1);
        },
      );

      test('isLanguageSelected falls back to locale presence', () async {
        when(() => prefs.containsKey('settings_locale')).thenReturn(true);
        when(
          () => prefs.getBool('settings_language_selected'),
        ).thenReturn(null);

        final result = await repository.isLanguageSelected();

        expect(result, isA<Success<bool, Failure>>());
        expect((result as Success<bool, Failure>).data, isTrue);
      });
    });

    group('notification preferences', () {
      test('areNotificationsEnabled defaults to true', () async {
        when(
          () => prefs.getBool('settings_notifications_enabled'),
        ).thenReturn(null);

        final result = await repository.areNotificationsEnabled();

        expect(result, isA<Success<bool, Failure>>());
        expect((result as Success<bool, Failure>).data, isTrue);
      });

      test('setNotificationsEnabled stores the preference', () async {
        when(
          () => prefs.setBool('settings_notifications_enabled', false),
        ).thenAnswer((_) async => true);

        final result = await repository.setNotificationsEnabled(false);

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => prefs.setBool('settings_notifications_enabled', false),
        ).called(1);
      });
    });
  });
}
