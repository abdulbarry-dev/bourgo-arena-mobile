import 'package:flutter/material.dart';

/// Repository interface for managing application settings.
abstract class SettingsRepository {
  /// Retrieves the persisted [ThemeMode].
  ThemeMode getThemeMode();

  /// Persists the [ThemeMode].
  Future<void> setThemeMode(ThemeMode mode);

  /// Retrieves the persisted [Locale].
  Locale getLocale();

  /// Checks if the user has explicitly selected a language.
  bool isLanguageSelected();

  /// Persists the [Locale].
  Future<void> setLocale(Locale locale);

  /// Retrieves whether notifications are enabled.
  bool areNotificationsEnabled();

  /// Persists notification preference.
  Future<void> setNotificationsEnabled(bool enabled);
}
