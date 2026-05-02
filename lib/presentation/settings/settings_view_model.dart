import 'package:bourgo_arena_mobile/data/services/settings_service.dart';
import 'package:flutter/material.dart';

/// ViewModel for managing application-wide settings.
class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late Locale _locale;
  late bool _notificationsEnabled;

  SettingsViewModel(this._settingsService) {
    _themeMode = _settingsService.getThemeMode();
    _locale = _settingsService.getLocale();
    _notificationsEnabled = _settingsService.areNotificationsEnabled();
  }

  /// The current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// The current [Locale].
  Locale get locale => _locale;

  /// Whether push notifications are enabled.
  bool get notificationsEnabled => _notificationsEnabled;

  /// Updates the application's theme mode.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.setThemeMode(newThemeMode);
  }

  /// Updates the application's locale.
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null || newLocale == _locale) return;

    _locale = newLocale;
    notifyListeners();
    await _settingsService.setLocale(newLocale);
  }

  /// Toggles push notifications.
  Future<void> toggleNotifications(bool value) async {
    if (value == _notificationsEnabled) return;

    _notificationsEnabled = value;
    notifyListeners();
    await _settingsService.setNotificationsEnabled(value);
  }
}
