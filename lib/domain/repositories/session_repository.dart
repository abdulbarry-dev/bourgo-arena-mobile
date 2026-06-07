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

  /// Retrieves the current [AuthState].
  Future<Result<String?, Failure>> getAuthState();

  /// Persists the [AuthState].
  Future<Result<void, Failure>> saveAuthState(String state);

  /// Retrieves the pending verification email, if any.
  Future<Result<String?, Failure>> getPendingVerificationEmail();

  /// Persists the pending verification email.
  Future<Result<void, Failure>> savePendingVerificationEmail(String email);

  /// Clears all session data atomically (tokens and session-scoped metadata).
  /// This is a full session wipe, not a field-by-field removal.
  Future<Result<void, Failure>> clearSession();

  // =========== Theme Preference ===========

  /// Retrieves the persisted [ThemeMode].
  Future<Result<ThemeMode, Failure>> getThemeMode();

  /// Persists the [ThemeMode].
  Future<Result<void, Failure>> setThemeMode(ThemeMode mode);

  /// Checks if the user has explicitly selected a theme.
  Future<Result<bool, Failure>> isThemeSelected();

  /// Marks the theme selection process as complete.
  Future<Result<void, Failure>> completeThemeSelection();

  // =========== Locale & Onboarding ===========

  /// Retrieves the persisted [Locale].
  Future<Result<Locale, Failure>> getLocale();

  /// Persists the [Locale].
  Future<Result<void, Failure>> setLocale(Locale locale);

  /// Marks the language selection process as complete.
  Future<Result<void, Failure>> completeLanguageSelection();

  /// Checks if the user has explicitly selected a language.
  Future<Result<bool, Failure>> isLanguageSelected();

  /// Checks if the onboarding flow has been completed.
  Future<Result<bool, Failure>> isOnboardingCompleted();

  /// Persists the onboarding completion status.
  Future<Result<void, Failure>> setOnboardingCompleted(bool completed);

  // =========== Notification Preference ===========

  /// Retrieves whether notifications are enabled.
  Future<Result<bool, Failure>> areNotificationsEnabled();

  /// Persists notification preference.
  Future<Result<void, Failure>> setNotificationsEnabled(bool enabled);

  /// Retrieves whether promotional notifications are enabled.
  Future<Result<bool, Failure>> arePromotionalNotificationsEnabled();

  /// Persists promotional notification preference.
  Future<Result<void, Failure>> setPromotionalNotificationsEnabled(
    bool enabled,
  );

  /// Retrieves whether account updates notifications are enabled.
  Future<Result<bool, Failure>> areAccountNotificationsEnabled();

  /// Persists account updates notification preference.
  Future<Result<void, Failure>> setAccountNotificationsEnabled(bool enabled);

  // =========== Device Token ==========

  /// Retrieves the stored device push token, if any.
  Future<Result<String?, Failure>> getDeviceToken();

  /// Persists the device push token.
  Future<Result<void, Failure>> saveDeviceToken(String token);

  /// Retrieves the stored device platform, if any.
  Future<Result<String?, Failure>> getDevicePlatform();

  /// Persists the device platform (e.g. android, ios).
  Future<Result<void, Failure>> saveDevicePlatform(String platform);

  // =========== Remember Me ===========

  /// Retrieves the persisted identifier for "Remember Me".
  Future<Result<String?, Failure>> getRememberedIdentifier();

  /// Persists the identifier for "Remember Me".
  Future<Result<void, Failure>> saveRememberedIdentifier(String identifier);

  /// Clears the persisted identifier for "Remember Me".
  Future<Result<void, Failure>> clearRememberedIdentifier();

  // =========== Registration Draft ===========

  /// Persists the current registration/onboarding draft.
  Future<Result<void, Failure>> saveRegistrationDraft(
    Map<String, dynamic> draft,
  );

  /// Retrieves the current registration/onboarding draft, if any.
  Future<Result<Map<String, dynamic>?, Failure>> getRegistrationDraft();

  /// Clears the persisted registration/onboarding draft.
  Future<Result<void, Failure>> clearRegistrationDraft();

  // =========== Login OTP Verification ===========

  /// Checks if the user has opted out of login OTP verification reminders.
  Future<Result<bool, Failure>> shouldSkipLoginOtpForever();

  /// Persists the user's preference to skip login OTP verification reminders forever.
  Future<Result<void, Failure>> setSkipLoginOtpForever(bool skip);
}
