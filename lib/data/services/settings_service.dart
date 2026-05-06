import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that handles persisting and retrieving app settings.
class SettingsService {
  static const String _themeKey = 'settings_theme_mode';
  static const String _localeKey = 'settings_locale';
  static const String _notificationsKey = 'settings_notifications_enabled';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  /// Retrieves the persisted [ThemeMode].
  ThemeMode getThemeMode() {
    final String? themeValue = _prefs.getString(_themeKey);
    if (themeValue == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (e) => e.name == themeValue,
      orElse: () => ThemeMode.system,
    );
  }

  /// Persists the [ThemeMode].
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  /// Retrieves the persisted [Locale].
  Locale getLocale() {
    final String? localeCode = _prefs.getString(_localeKey);
    if (localeCode == null) return const Locale('en');
    return Locale(localeCode);
  }

  /// Checks if the user has explicitly selected a language.
  bool isLanguageSelected() {
    return _prefs.containsKey(_localeKey);
  }

  /// Persists the [Locale].
  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  /// Retrieves whether notifications are enabled.
  bool areNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  /// Persists notification preference.
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }
}
