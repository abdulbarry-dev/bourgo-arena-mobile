import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_language_selection_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_theme_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_theme_selection_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// ViewModel for managing application-wide settings.
class SettingsViewModel extends BaseViewModel {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;
  final GetLocaleUseCase _getLocaleUseCase;
  final SetLocaleUseCase _setLocaleUseCase;
  final IsLanguageSelectedUseCase _isLanguageSelectedUseCase;
  final CompleteLanguageSelectionUseCase _completeLanguageSelectionUseCase;
  final IsThemeSelectedUseCase _isThemeSelectedUseCase;
  final CompleteThemeSelectionUseCase _completeThemeSelectionUseCase;
  final GetNotificationsEnabledUseCase _getNotificationsEnabledUseCase;
  final SetNotificationsEnabledUseCase _setNotificationsEnabledUseCase;
  final DeviceTokenRegistrar _deviceTokenRegistrar;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  bool _notificationsEnabled = true;
  bool _promoNotificationsEnabled = true;
  bool _accountNotificationsEnabled = true;
  bool _reservationsNotificationsEnabled = true;
  bool _subscriptionsNotificationsEnabled = true;
  bool _coursesNotificationsEnabled = true;
  bool _loyaltyNotificationsEnabled = true;
  bool _familyNotificationsEnabled = true;
  bool _languageSelected = false;
  bool _themeSelected = false;
  String _appVersion = '';

  SettingsViewModel(
    this._getThemeModeUseCase,
    this._setThemeModeUseCase,
    this._getLocaleUseCase,
    this._setLocaleUseCase,
    this._isLanguageSelectedUseCase,
    this._completeLanguageSelectionUseCase,
    this._isThemeSelectedUseCase,
    this._completeThemeSelectionUseCase,
    this._getNotificationsEnabledUseCase,
    this._setNotificationsEnabledUseCase,
    this._deviceTokenRegistrar,
    this._deleteAccountUseCase,
    this._sessionRepository,
    this._userRepository,
  );

  /// Deletes the user's account.
  Future<bool> deleteAccount({required String password}) async {
    clearError();
    notifyListeners();

    final result = await _deleteAccountUseCase.execute(password: password);
    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        setErrorMessage(failure.message);
        notifyListeners();
        return false;
      },
    );
  }

  /// The current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// The current [Locale].
  Locale get locale => _locale;

  /// Whether the user has explicitly selected a language.
  bool get isLanguageSelected => _languageSelected;

  /// Whether the user has explicitly selected a theme.
  bool get isThemeSelected => _themeSelected;

  /// Whether push notifications are enabled.
  bool get notificationsEnabled => _notificationsEnabled;

  /// The formatted app version string (e.g., "1.0.0 (1)").
  String get appVersion => _appVersion;

  /// Whether promotional notifications are enabled.
  bool get promoNotificationsEnabled => _promoNotificationsEnabled;

  /// Whether account notifications are enabled.
  bool get accountNotificationsEnabled => _accountNotificationsEnabled;

  /// Whether reservations notifications are enabled.
  bool get reservationsNotificationsEnabled =>
      _reservationsNotificationsEnabled;

  /// Whether subscriptions notifications are enabled.
  bool get subscriptionsNotificationsEnabled =>
      _subscriptionsNotificationsEnabled;

  /// Whether courses notifications are enabled.
  bool get coursesNotificationsEnabled => _coursesNotificationsEnabled;

  /// Whether loyalty notifications are enabled.
  bool get loyaltyNotificationsEnabled => _loyaltyNotificationsEnabled;

  /// Whether family notifications are enabled.
  bool get familyNotificationsEnabled => _familyNotificationsEnabled;

  /// Loads all persisted settings from storage.
  ///
  /// Must be called once after construction (e.g. during DI setup).
  Future<void> initialize() async {
    final results = await Future.wait([
      _getThemeModeUseCase(),
      _getLocaleUseCase(),
      _getNotificationsEnabledUseCase(),
      _isLanguageSelectedUseCase(),
      _isThemeSelectedUseCase(),
      PackageInfo.fromPlatform(),
      _sessionRepository.arePromotionalNotificationsEnabled(),
      _sessionRepository.areAccountNotificationsEnabled(),
      _sessionRepository.areReservationsNotificationsEnabled(),
      _sessionRepository.areSubscriptionsNotificationsEnabled(),
      _sessionRepository.areCoursesNotificationsEnabled(),
      _sessionRepository.areLoyaltyNotificationsEnabled(),
      _sessionRepository.areFamilyNotificationsEnabled(),
    ]);

    final themeResult = results[0] as Result<ThemeMode, Failure>;
    final localeResult = results[1] as Result<Locale, Failure>;
    final notifResult = results[2] as Result<bool, Failure>;
    final langResult = results[3] as Result<bool, Failure>;
    final themeSelResult = results[4] as Result<bool, Failure>;
    final packageInfo = results[5] as PackageInfo;
    final promoResult = results[6] as Result<bool, Failure>;
    final accountResult = results[7] as Result<bool, Failure>;
    final reservationsResult = results[8] as Result<bool, Failure>;
    final subscriptionsResult = results[9] as Result<bool, Failure>;
    final coursesResult = results[10] as Result<bool, Failure>;
    final loyaltyResult = results[11] as Result<bool, Failure>;
    final familyResult = results[12] as Result<bool, Failure>;

    _themeMode = themeResult.isSuccess
        ? (themeResult as Success<ThemeMode, Failure>).data
        : ThemeMode.system;
    _locale = localeResult.isSuccess
        ? (localeResult as Success<Locale, Failure>).data
        : const Locale('en');
    _notificationsEnabled = notifResult.isSuccess
        ? (notifResult as Success<bool, Failure>).data
        : true;
    _languageSelected = langResult.isSuccess
        ? (langResult as Success<bool, Failure>).data
        : false;
    _themeSelected = themeSelResult.isSuccess
        ? (themeSelResult as Success<bool, Failure>).data
        : false;
    _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    _promoNotificationsEnabled = promoResult.isSuccess
        ? (promoResult as Success<bool, Failure>).data
        : true;
    _accountNotificationsEnabled = accountResult.isSuccess
        ? (accountResult as Success<bool, Failure>).data
        : true;
    _reservationsNotificationsEnabled = reservationsResult.isSuccess
        ? (reservationsResult as Success<bool, Failure>).data
        : true;
    _subscriptionsNotificationsEnabled = subscriptionsResult.isSuccess
        ? (subscriptionsResult as Success<bool, Failure>).data
        : true;
    _coursesNotificationsEnabled = coursesResult.isSuccess
        ? (coursesResult as Success<bool, Failure>).data
        : true;
    _loyaltyNotificationsEnabled = loyaltyResult.isSuccess
        ? (loyaltyResult as Success<bool, Failure>).data
        : true;
    _familyNotificationsEnabled = familyResult.isSuccess
        ? (familyResult as Success<bool, Failure>).data
        : true;
    _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

    notifyListeners();
  }

  /// Updates the application's theme mode.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _setThemeModeUseCase(newThemeMode);
    await _syncPreferences();
  }

  /// Updates the application's locale.
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;

    // If the locale is the same, we don't need to do anything.
    if (newLocale == _locale) return;

    _locale = newLocale;
    notifyListeners();
    await _setLocaleUseCase(newLocale);
    await _syncPreferences();
  }

  /// Confirms the language selection and marks it as complete.
  ///
  /// This will trigger the router to redirect the user away from the language
  /// selection screen.
  Future<void> confirmLanguageSelection() async {
    _languageSelected = true;
    notifyListeners();
    await _completeLanguageSelectionUseCase();
  }

  /// Confirms the theme selection and marks it as complete.
  ///
  /// This will trigger the router to redirect the user away from the theme
  /// selection screen.
  Future<void> confirmThemeSelection() async {
    _themeSelected = true;
    notifyListeners();
    await _completeThemeSelectionUseCase();
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
    } else {
      await _deviceTokenRegistrar.unregister();
    }
    await _syncPreferences();
  }

  /// Toggles promotional notifications.
  Future<void> togglePromoNotifications(bool value) async {
    if (value == _promoNotificationsEnabled) return;

    _promoNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setPromotionalNotificationsEnabled(value);
    await _syncPreferences();
  }

  /// Toggles account notifications.
  Future<void> toggleAccountNotifications(bool value) async {
    if (value == _accountNotificationsEnabled) return;

    _accountNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setAccountNotificationsEnabled(value);
    await _syncPreferences();
  }

  /// Toggles reservations notifications.
  Future<void> toggleReservationsNotifications(bool value) async {
    if (value == _reservationsNotificationsEnabled) return;

    _reservationsNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setReservationsNotificationsEnabled(value);
    await _syncPreferences();
  }

  /// Toggles subscriptions notifications.
  Future<void> toggleSubscriptionsNotifications(bool value) async {
    if (value == _subscriptionsNotificationsEnabled) return;

    _subscriptionsNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setSubscriptionsNotificationsEnabled(value);
    await _syncPreferences();
  }

  /// Toggles courses notifications.
  Future<void> toggleCoursesNotifications(bool value) async {
    if (value == _coursesNotificationsEnabled) return;

    _coursesNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setCoursesNotificationsEnabled(value);
    await _syncPreferences();
  }

  /// Toggles loyalty notifications.
  Future<void> toggleLoyaltyNotifications(bool value) async {
    if (value == _loyaltyNotificationsEnabled) return;

    _loyaltyNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setLoyaltyNotificationsEnabled(value);
    await _syncPreferences();
  }

  /// Toggles family notifications.
  Future<void> toggleFamilyNotifications(bool value) async {
    if (value == _familyNotificationsEnabled) return;

    _familyNotificationsEnabled = value;
    notifyListeners();
    await _sessionRepository.setFamilyNotificationsEnabled(value);
    await _syncPreferences();
  }

  Future<void> _syncPreferences() async {
    final preferences = {
      'app': {'theme': _themeMode.name, 'language': _locale.languageCode},
      'notifications': {
        'push_enabled': _notificationsEnabled,
        'promotions': _promoNotificationsEnabled,
        'account_updates': _accountNotificationsEnabled,
        'reservations': _reservationsNotificationsEnabled,
        'subscriptions': _subscriptionsNotificationsEnabled,
        'courses': _coursesNotificationsEnabled,
        'loyalty': _loyaltyNotificationsEnabled,
        'family': _familyNotificationsEnabled,
      },
    };

    await _userRepository.updatePreferences(preferences);
  }
}
