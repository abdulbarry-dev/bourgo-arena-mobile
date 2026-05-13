import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
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
  final DeviceTokenRegistrar _deviceTokenRegistrar;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  bool _notificationsEnabled = true;
  bool _languageSelected = false;

  /// Creates a new [SettingsViewModel] with sensible defaults.
  ///
  /// Call [initialize] after construction to load persisted values.
  SettingsViewModel(
    this._getThemeModeUseCase,
    this._setThemeModeUseCase,
    this._getLocaleUseCase,
    this._setLocaleUseCase,
    this._isLanguageSelectedUseCase,
    this._getNotificationsEnabledUseCase,
    this._setNotificationsEnabledUseCase,
    this._deviceTokenRegistrar,
  );

  /// The current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// The current [Locale].
  Locale get locale => _locale;

  /// Whether the user has explicitly selected a language.
  bool get isLanguageSelected => _languageSelected;

  /// Whether push notifications are enabled.
  bool get notificationsEnabled => _notificationsEnabled;

  /// Loads all persisted settings from storage.
  ///
  /// Must be called once after construction (e.g. during DI setup).
  Future<void> initialize() async {
    final results = await Future.wait([
      _getThemeModeUseCase(),
      _getLocaleUseCase(),
      _getNotificationsEnabledUseCase(),
      _isLanguageSelectedUseCase(),
    ]);

    final themeResult = results[0] as Result<ThemeMode, dynamic>;
    final localeResult = results[1] as Result<Locale, dynamic>;
    final notifResult = results[2] as Result<bool, dynamic>;
    final langResult = results[3] as Result<bool, dynamic>;

    if (themeResult.isSuccess) {
      _themeMode = (themeResult as Success<ThemeMode, dynamic>).data;
    }
    if (localeResult.isSuccess) {
      _locale = (localeResult as Success<Locale, dynamic>).data;
    }
    if (notifResult.isSuccess) {
      _notificationsEnabled = (notifResult as Success<bool, dynamic>).data;
    }
    if (langResult.isSuccess) {
      _languageSelected = (langResult as Success<bool, dynamic>).data;
    }

    notifyListeners();
  }

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
    // We persist before notifying so that GoRouter redirects see the updated
    // state in SharedPreferences, preventing a redirection loop.
    await _setLocaleUseCase(newLocale);
    _languageSelected = true;
    notifyListeners();
  }

  /// Toggles push notifications.
  Future<void> toggleNotifications(bool value) async {
    if (value == _notificationsEnabled) return;

    _notificationsEnabled = value;
    notifyListeners();
    await _setNotificationsEnabledUseCase(value);

    if (value) {
      await _deviceTokenRegistrar.registerIfPossible(
        requireNotificationsEnabled: false,
      );
    }
  }
}
