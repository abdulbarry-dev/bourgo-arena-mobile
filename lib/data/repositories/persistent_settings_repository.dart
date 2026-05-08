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
  ThemeMode getThemeMode() {
    final String? themeValue = _prefs.getString(_themeKey);
    if (themeValue == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (e) => e.name == themeValue,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  @override
  Locale getLocale() {
    final String? localeCode = _prefs.getString(_localeKey);
    if (localeCode == null) return const Locale('en');
    return Locale(localeCode);
  }

  @override
  bool isLanguageSelected() {
    return _prefs.containsKey(_localeKey);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  @override
  bool areNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }
}
