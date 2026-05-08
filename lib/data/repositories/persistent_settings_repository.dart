import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [SettingsRepository] using [SharedPreferences].
class PersistentSettingsRepository implements SettingsRepository {
  static const String _themeKey = 'settings_theme_mode';
  static const String _localeKey = 'settings_locale';
  static const String _notificationsKey = 'settings_notifications_enabled';

  final SharedPreferences _prefs;

  /// Creates a new [PersistentSettingsRepository].
  PersistentSettingsRepository(this._prefs);

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
      return FailureResult(CacheFailure('Failed to load theme mode: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> setThemeMode(ThemeMode mode) async {
    try {
      await _prefs.setString(_themeKey, mode.name);
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to save theme mode: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Locale, Failure>> getLocale() async {
    try {
      final String? localeCode = _prefs.getString(_localeKey);
      if (localeCode == null) return const Success(Locale('en'));
      return Success(Locale(localeCode));
    } catch (e) {
      return FailureResult(CacheFailure('Failed to load locale: ${e.toString()}'));
    }
  }

  @override
  Future<Result<bool, Failure>> isLanguageSelected() async {
    try {
      return Success(_prefs.containsKey(_localeKey));
    } catch (e) {
      return FailureResult(CacheFailure('Failed to check language selection: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> setLocale(Locale locale) async {
    try {
      await _prefs.setString(_localeKey, locale.languageCode);
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to save locale: ${e.toString()}'));
    }
  }

  @override
  Future<Result<bool, Failure>> areNotificationsEnabled() async {
    try {
      final enabled = _prefs.getBool(_notificationsKey) ?? true;
      return Success(enabled);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to load notification settings: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> setNotificationsEnabled(bool enabled) async {
    try {
      await _prefs.setBool(_notificationsKey, enabled);
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to save notification settings: ${e.toString()}'));
    }
  }
}
