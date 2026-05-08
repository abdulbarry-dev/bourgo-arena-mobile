import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:flutter/material.dart';

/// Repository interface for managing application settings.
abstract interface class SettingsRepository {
  /// Retrieves the persisted [ThemeMode].
  Future<Result<ThemeMode, Failure>> getThemeMode();

  /// Persists the [ThemeMode].
  Future<Result<void, Failure>> setThemeMode(ThemeMode mode);

  /// Retrieves the persisted [Locale].
  Future<Result<Locale, Failure>> getLocale();

  /// Checks if the user has explicitly selected a language.
  Future<Result<bool, Failure>> isLanguageSelected();

  /// Persists the [Locale].
  Future<Result<void, Failure>> setLocale(Locale locale);

  /// Retrieves whether notifications are enabled.
  Future<Result<bool, Failure>> areNotificationsEnabled();

  /// Persists notification preference.
  Future<Result<void, Failure>> setNotificationsEnabled(bool enabled);
}
