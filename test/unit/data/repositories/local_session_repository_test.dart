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
        const sessionKeys = [
          'auth_token',
          'auth_state',
          'pending_verification_email',
          'device_token',
          'device_platform',
          'onboarding_completed',
        ];

        for (final key in sessionKeys) {
          when(() => prefs.remove(key)).thenAnswer((_) async => true);
        }

        final result = await repository.clearSession();

        expect(result, isA<Success<void, Failure>>());
        for (final key in sessionKeys) {
          verify(() => prefs.remove(key)).called(1);
        }
        verifyNoMoreInteractions(prefs);
      });

      test('saveAuthState stores the state under the auth_state key', () async {
        when(
          () => prefs.setString('auth_state', 'unverified'),
        ).thenAnswer((_) async => true);

        final result = await repository.saveAuthState('unverified');

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.setString('auth_state', 'unverified')).called(1);
      });

      test('getAuthState returns the stored state', () async {
        when(() => prefs.getString('auth_state')).thenReturn('unverified');

        final result = await repository.getAuthState();

        expect(result, isA<Success<String?, Failure>>());
        expect((result as Success<String?, Failure>).data, 'unverified');
        verify(() => prefs.getString('auth_state')).called(1);
      });

      test(
        'savePendingVerificationEmail stores the email under the pending_verification_email key',
        () async {
          when(
            () =>
                prefs.setString('pending_verification_email', 'test@test.com'),
          ).thenAnswer((_) async => true);

          final result = await repository.savePendingVerificationEmail(
            'test@test.com',
          );

          expect(result, isA<Success<void, Failure>>());
          verify(
            () =>
                prefs.setString('pending_verification_email', 'test@test.com'),
          ).called(1);
        },
      );

      test('getPendingVerificationEmail returns the stored email', () async {
        when(
          () => prefs.getString('pending_verification_email'),
        ).thenReturn('test@test.com');

        final result = await repository.getPendingVerificationEmail();

        expect(result, isA<Success<String?, Failure>>());
        expect((result as Success<String?, Failure>).data, 'test@test.com');
        verify(() => prefs.getString('pending_verification_email')).called(1);
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

      test(
        'clearSession returns CacheFailure when SharedPreferences throws',
        () async {
          when(() => prefs.remove(any())).thenThrow(Exception('boom'));

          final result = await repository.clearSession();

          expect(result, isA<FailureResult<void, Failure>>());
          expect(
            (result as FailureResult<void, Failure>).failure,
            isA<CacheFailure>(),
          );
        },
      );
    });

    group('device and onboarding', () {
      test('saveDeviceToken stores the token', () async {
        when(
          () => prefs.setString('device_token', 'd-123'),
        ).thenAnswer((_) async => true);

        final result = await repository.saveDeviceToken('d-123');

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.setString('device_token', 'd-123')).called(1);
      });

      test('getDeviceToken returns the token', () async {
        when(() => prefs.getString('device_token')).thenReturn('d-123');

        final result = await repository.getDeviceToken();

        expect(result, isA<Success<String?, Failure>>());
        expect((result as Success<String?, Failure>).data, 'd-123');
      });

      test('isOnboardingCompleted defaults to false', () async {
        when(() => prefs.getBool('onboarding_completed')).thenReturn(null);

        final result = await repository.isOnboardingCompleted();

        expect(result, isA<Success<bool, Failure>>());
        expect((result as Success<bool, Failure>).data, isFalse);
      });

      test('setOnboardingCompleted stores the value', () async {
        when(
          () => prefs.setBool('onboarding_completed', true),
        ).thenAnswer((_) async => true);

        final result = await repository.setOnboardingCompleted(true);

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.setBool('onboarding_completed', true)).called(1);
      });
    });

    group('remember me', () {
      test('saveRememberedIdentifier stores the identifier', () async {
        when(
          () => prefs.setString('remembered_identifier', 'user@example.com'),
        ).thenAnswer((_) async => true);

        final result = await repository.saveRememberedIdentifier(
          'user@example.com',
        );

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => prefs.setString('remembered_identifier', 'user@example.com'),
        ).called(1);
      });

      test('getRememberedIdentifier returns the identifier', () async {
        when(
          () => prefs.getString('remembered_identifier'),
        ).thenReturn('user@example.com');

        final result = await repository.getRememberedIdentifier();

        expect(result, isA<Success<String?, Failure>>());
        expect((result as Success<String?, Failure>).data, 'user@example.com');
      });

      test('clearRememberedIdentifier removes the key', () async {
        when(
          () => prefs.remove('remembered_identifier'),
        ).thenAnswer((_) async => true);

        final result = await repository.clearRememberedIdentifier();

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.remove('remembered_identifier')).called(1);
      });
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

      test('setLocale stores the locale', () async {
        when(
          () => prefs.setString('settings_locale', 'fr'),
        ).thenAnswer((_) async => true);

        final result = await repository.setLocale(const Locale('fr'));

        expect(result, isA<Success<void, Failure>>());
        verify(() => prefs.setString('settings_locale', 'fr')).called(1);
        verifyNever(() => prefs.setBool('settings_language_selected', true));
      });

      test('completeLanguageSelection marks language as selected', () async {
        when(
          () => prefs.setBool('settings_language_selected', true),
        ).thenAnswer((_) async => true);

        final result = await repository.completeLanguageSelection();

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => prefs.setBool('settings_language_selected', true),
        ).called(1);
      });

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
