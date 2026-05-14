import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local implementation of [SessionRepository] using [SharedPreferences].
///
/// This is the single authoritative source for all local persistence in the app.
/// All storage keys are private constants here; no raw key strings may appear
/// elsewhere in the codebase.
///
/// The [clearSession] method performs an atomic wipe of all session-scoped keys.
/// Every new session field MUST be added to [_sessionKeys] — this is a hard rule.
class LocalSessionRepository implements SessionRepository {
  // =========== Storage Keys (Private) ===========
  // Auth Session
  static const String _authTokenKey = 'auth_token';
  static const String _authStateKey = 'auth_state';
  static const String _pendingEmailKey = 'pending_verification_email';

  // Theme Preference
  static const String _themeKey = 'settings_theme_mode';

  // Locale & Onboarding
  static const String _localeKey = 'settings_locale';
  static const String _languageSelectedKey = 'settings_language_selected';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // Notification Preference
  static const String _notificationsKey = 'settings_notifications_enabled';

  // Device Token
  static const String _deviceTokenKey = 'device_token';
  static const String _devicePlatformKey = 'device_platform';

  // Remember Me
  static const String _rememberedIdentifierKey = 'remembered_identifier';

  /// All session-scoped keys that should be wiped atomically by [clearSession].
  /// This list is the source of truth for session-wide data; every session field
  /// added in the future MUST be added here.
  static const List<String> _sessionKeys = [
    _authTokenKey,
    _authStateKey,
    _pendingEmailKey,
    _deviceTokenKey,
    _devicePlatformKey,
    _onboardingCompletedKey,
  ];

  final SharedPreferences _prefs;

  /// Creates a new [LocalSessionRepository].
  LocalSessionRepository(this._prefs);

  // =========== Auth Session ===========

  @override
  Future<Result<String?, Failure>> getAuthToken() async {
    try {
      final token = _prefs.getString(_authTokenKey);
      return Success(token);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to retrieve auth token: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> saveAuthToken(String token) async {
    try {
      await _prefs.setString(_authTokenKey, token);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save auth token: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<String?, Failure>> getAuthState() async {
    try {
      final state = _prefs.getString(_authStateKey);
      return Success(state);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to retrieve auth state: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> saveAuthState(String state) async {
    try {
      await _prefs.setString(_authStateKey, state);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save auth state: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<String?, Failure>> getPendingVerificationEmail() async {
    try {
      final email = _prefs.getString(_pendingEmailKey);
      return Success(email);
    } catch (e) {
      return FailureResult(
        CacheFailure(
          'Failed to retrieve pending verification email: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void, Failure>> savePendingVerificationEmail(
    String email,
  ) async {
    try {
      await _prefs.setString(_pendingEmailKey, email);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure(
          'Failed to save pending verification email: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void, Failure>> clearSession() async {
    try {
      for (final key in _sessionKeys) {
        await _prefs.remove(key);
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to clear session: ${e.toString()}'),
      );
    }
  }

  // =========== Theme Preference ===========

  @override
  Future<Result<ThemeMode, Failure>> getThemeMode() async {
    try {
      final String? themeValue = _prefs.getString(_themeKey);
      if (themeValue == null) return const Success(ThemeMode.system);

      final mode = ThemeMode.values.firstWhere(
        (e) => e.name == themeValue,
        orElse: () => ThemeMode.system,
      );
      return Success(mode);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to load theme mode: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> setThemeMode(ThemeMode mode) async {
    try {
      await _prefs.setString(_themeKey, mode.name);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save theme mode: ${e.toString()}'),
      );
    }
  }

  // =========== Locale & Onboarding ===========

  @override
  Future<Result<Locale, Failure>> getLocale() async {
    try {
      final String? localeCode = _prefs.getString(_localeKey);
      if (localeCode == null) return const Success(Locale('en'));
      return Success(Locale(localeCode));
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to load locale: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> setLocale(Locale locale) async {
    try {
      await _prefs.setString(_localeKey, locale.languageCode);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save locale: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> completeLanguageSelection() async {
    try {
      await _prefs.setBool(_languageSelectedKey, true);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to complete language selection: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool, Failure>> isLanguageSelected() async {
    try {
      // Legacy fallback: if a locale is persisted, consider the language selected.
      // For new installs, the explicit flag is set when setLocale is called.
      final hasLocale = _prefs.containsKey(_localeKey);
      final isSelected = _prefs.getBool(_languageSelectedKey) ?? hasLocale;
      return Success(isSelected);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to check language selection: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool, Failure>> isOnboardingCompleted() async {
    try {
      final completed = _prefs.getBool(_onboardingCompletedKey) ?? false;
      return Success(completed);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to check onboarding completion: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> setOnboardingCompleted(bool completed) async {
    try {
      await _prefs.setBool(_onboardingCompletedKey, completed);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save onboarding completion: ${e.toString()}'),
      );
    }
  }

  // =========== Notification Preference ===========

  @override
  Future<Result<bool, Failure>> areNotificationsEnabled() async {
    try {
      final enabled = _prefs.getBool(_notificationsKey) ?? true;
      return Success(enabled);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to load notification settings: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> setNotificationsEnabled(bool enabled) async {
    try {
      await _prefs.setBool(_notificationsKey, enabled);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save notification settings: ${e.toString()}'),
      );
    }
  }

  // =========== Device Token ==========

  @override
  Future<Result<String?, Failure>> getDeviceToken() async {
    try {
      final token = _prefs.getString(_deviceTokenKey);
      return Success(token);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to retrieve device token: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> saveDeviceToken(String token) async {
    try {
      await _prefs.setString(_deviceTokenKey, token);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save device token: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<String?, Failure>> getDevicePlatform() async {
    try {
      final platform = _prefs.getString(_devicePlatformKey);
      return Success(platform);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to retrieve device platform: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> saveDevicePlatform(String platform) async {
    try {
      await _prefs.setString(_devicePlatformKey, platform);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save device platform: ${e.toString()}'),
      );
    }
  }

  // =========== Remember Me ===========

  @override
  Future<Result<String?, Failure>> getRememberedIdentifier() async {
    try {
      final identifier = _prefs.getString(_rememberedIdentifierKey);
      return Success(identifier);
    } catch (e) {
      return FailureResult(
        CacheFailure(
          'Failed to retrieve remembered identifier: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void, Failure>> saveRememberedIdentifier(
    String identifier,
  ) async {
    try {
      await _prefs.setString(_rememberedIdentifierKey, identifier);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to save remembered identifier: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> clearRememberedIdentifier() async {
    try {
      await _prefs.remove(_rememberedIdentifierKey);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Failed to clear remembered identifier: ${e.toString()}'),
      );
    }
  }
}
