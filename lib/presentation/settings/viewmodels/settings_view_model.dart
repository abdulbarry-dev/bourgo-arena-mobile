import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for managing application-wide settings.
class SettingsViewModel extends ChangeNotifier {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;
  final GetLocaleUseCase _getLocaleUseCase;
  final SetLocaleUseCase _setLocaleUseCase;
  final IsLanguageSelectedUseCase _isLanguageSelectedUseCase;
  final GetNotificationsEnabledUseCase _getNotificationsEnabledUseCase;
  final SetNotificationsEnabledUseCase _setNotificationsEnabledUseCase;

  late ThemeMode _themeMode;
  late Locale _locale;
  late bool _notificationsEnabled;

  /// Creates a new [SettingsViewModel].
  SettingsViewModel(
    this._getThemeModeUseCase,
    this._setThemeModeUseCase,
    this._getLocaleUseCase,
    this._setLocaleUseCase,
    this._isLanguageSelectedUseCase,
    this._getNotificationsEnabledUseCase,
    this._setNotificationsEnabledUseCase,
  ) {
    _themeMode = _getThemeModeUseCase();
    _locale = _getLocaleUseCase();
    _notificationsEnabled = _getNotificationsEnabledUseCase();
  }

  /// The current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// The current [Locale].
  Locale get locale => _locale;

  /// Whether the user has explicitly selected a language.
  bool get isLanguageSelected => _isLanguageSelectedUseCase();

  /// Whether push notifications are enabled.
  bool get notificationsEnabled => _notificationsEnabled;

  /// Updates the application's theme mode.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _setThemeModeUseCase(newThemeMode);
  }

  /// Updates the application's locale.
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;

    // We only skip if the locale is the same AND it's already been persisted.
    if (newLocale == _locale && isLanguageSelected) return;

    _locale = newLocale;
    // We persist before notifying so that GoRouter redirects see the updated state
    // in SharedPreferences, preventing a redirection loop.
    await _setLocaleUseCase(newLocale);
    notifyListeners();
  }

  /// Toggles push notifications.
  Future<void> toggleNotifications(bool value) async {
    if (value == _notificationsEnabled) return;

    _notificationsEnabled = value;
    notifyListeners();
    await _setNotificationsEnabledUseCase(value);
  }
}
