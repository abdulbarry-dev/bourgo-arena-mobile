import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:flutter/material.dart';

/// Repository interface for managing application session and preferences.
///
/// This repository consolidates auth session data (tokens) and user preferences
/// (theme, locale, notifications). It provides typed accessors for each concern
/// so no raw key strings are exposed outside this contract.
abstract interface class SessionRepository {
  // =========== Auth Session ===========

  /// Retrieves the current authentication token, if any.
  Future<Result<String?, Failure>> getAuthToken();

  /// Persists the authentication token.
  Future<Result<void, Failure>> saveAuthToken(String token);

  /// Clears all session data atomically (tokens and session-scoped metadata).
  /// This is a full session wipe, not a field-by-field removal.
  Future<Result<void, Failure>> clearSession();

  // =========== Theme Preference ===========

  /// Retrieves the persisted [ThemeMode].
  Future<Result<ThemeMode, Failure>> getThemeMode();

  /// Persists the [ThemeMode].
  Future<Result<void, Failure>> setThemeMode(ThemeMode mode);

  // =========== Locale & Onboarding ===========

  /// Retrieves the persisted [Locale].
  Future<Result<Locale, Failure>> getLocale();

  /// Persists the [Locale] and marks language as explicitly selected.
  Future<Result<void, Failure>> setLocale(Locale locale);

  /// Checks if the user has explicitly selected a language.
  Future<Result<bool, Failure>> isLanguageSelected();

  // =========== Notification Preference ===========

  /// Retrieves whether notifications are enabled.
  Future<Result<bool, Failure>> areNotificationsEnabled();

  /// Persists notification preference.
  Future<Result<void, Failure>> setNotificationsEnabled(bool enabled);
}
