import 'dart:async';

import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// Notifier for listening to authentication state changes.
class AuthStateNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final DeviceTokenRegistrar _deviceTokenRegistrar;

  AuthSession _session = AuthSession.unauthenticated();
  StreamSubscription<AuthSession>? _authSubscription;
  bool _skippedForSession = false;
  Map<String, dynamic>? _registrationDraft;

  AuthStateNotifier(
    this._authRepository,
    this._sessionRepository,
    this._deviceTokenRegistrar,
  ) {
    _init();
  }

  void _init() {
    _authSubscription = _authRepository.onAuthStateChanged.listen((session) {
      _applySession(session);
    });
  }

  void _applySession(AuthSession session) {
    try {
      // Log incoming session for debugging redirect issues
      // ignore: avoid_print
      // Use developer.log when available
    } catch (_) {}

    // Developer-visible log for session applied
    developer.log(
      'AuthStateNotifier._applySession: state=${session.state}, token=${session.token}, user=${session.user}',
      name: 'bourgo.auth.session',
    );
    if (_skippedForSession &&
        session.user != null &&
        (session.state == AuthState.pendingAdditionalVerification ||
            session.needsLoginVerification)) {
      _session = session.copyWith(
        state: AuthState.authenticated,
        needsLoginVerification: false,
      );
    } else {
      _session = session;
    }

    if (_session.state == AuthState.unauthenticated ||
        _session.state == AuthState.guest) {
      _registrationDraft = null;
    }

    if (_session.user?.preferences != null) {
      _syncPreferencesToLocal(_session.user!.preferences!);
    }

    if (_session.isAuthenticated) {
      unawaited(_deviceTokenRegistrar.registerIfPossible());
    }
    notifyListeners();
  }

  AuthState _parsePersistedState(String? stateStr) {
    switch (stateStr) {
      case 'guest':
        return AuthState.guest;
      case 'pending_verification':
        return AuthState.pendingVerification;
      case 'pending_additional_verification':
        return AuthState.pendingAdditionalVerification;
      case 'pending_onboarding':
        return AuthState.pendingOnboarding;
      case 'pending_deletion_cancellation':
        return AuthState.pendingDeletionCancellation;
      default:
        return AuthState.values.firstWhere(
          (e) => e.name == stateStr,
          orElse: () => AuthState.unauthenticated,
        );
    }
  }

  Future<void> _syncPreferencesToLocal(Map<String, dynamic> prefs) async {
    final appPrefs = prefs['app'] as Map<String, dynamic>?;
    if (appPrefs != null) {
      if (appPrefs['theme'] == 'dark') {
        await _sessionRepository.setThemeMode(ThemeMode.dark);
      } else if (appPrefs['theme'] == 'light') {
        await _sessionRepository.setThemeMode(ThemeMode.light);
      } else if (appPrefs['theme'] == 'system') {
        await _sessionRepository.setThemeMode(ThemeMode.system);
      }

      if (appPrefs['language'] is String) {
        await _sessionRepository.setLocale(Locale(appPrefs['language']));
      }
    }

    final notifPrefs = prefs['notifications'] as Map<String, dynamic>?;
    if (notifPrefs != null) {
      if (notifPrefs['push_enabled'] is bool) {
        await _sessionRepository.setNotificationsEnabled(
          notifPrefs['push_enabled'],
        );
      }
      if (notifPrefs['promotions'] is bool) {
        await _sessionRepository.setPromotionalNotificationsEnabled(
          notifPrefs['promotions'],
        );
      }
      if (notifPrefs['account_updates'] is bool) {
        await _sessionRepository.setAccountNotificationsEnabled(
          notifPrefs['account_updates'],
        );
      }
      if (notifPrefs['reservations'] is bool) {
        await _sessionRepository.setReservationsNotificationsEnabled(
          notifPrefs['reservations'],
        );
      }
      if (notifPrefs['subscriptions'] is bool) {
        await _sessionRepository.setSubscriptionsNotificationsEnabled(
          notifPrefs['subscriptions'],
        );
      }
      if (notifPrefs['courses'] is bool) {
        await _sessionRepository.setCoursesNotificationsEnabled(
          notifPrefs['courses'],
        );
      }
      if (notifPrefs['loyalty'] is bool) {
        await _sessionRepository.setLoyaltyNotificationsEnabled(
          notifPrefs['loyalty'],
        );
      }
      if (notifPrefs['family'] is bool) {
        await _sessionRepository.setFamilyNotificationsEnabled(
          notifPrefs['family'],
        );
      }
    }
  }

  /// Whether the user has skipped the additional verification for this session.
  bool get skippedForSession => _skippedForSession;

  /// Sets the flag to skip login OTP verification for the current session only.
  void skipForSession() {
    _skippedForSession = true;
    _applySession(_session);
  }

  /// Sets the persistent preference to skip login OTP verification forever.
  Future<void> skipForever() async {
    _skippedForSession = true;
    await _sessionRepository.setSkipLoginOtpForever(true);
    _applySession(_session);
  }

  /// Initializes the auth state by fetching the current user profile if a
  /// token exists, or restoring a pending state from persistence.
  Future<void> initialize() async {
    final skipResult = await _sessionRepository.shouldSkipLoginOtpForever();
    _skippedForSession = skipResult.fold(
      onSuccess: (v) => v,
      onFailure: (_) => false,
    );

    final draftResult = await _sessionRepository.getRegistrationDraft();
    _registrationDraft = draftResult.fold(
      onSuccess: (draft) => draft,
      onFailure: (_) => null,
    );

    final stateResult = await _sessionRepository.getAuthState();
    final stateStr = stateResult.fold(
      onSuccess: (state) => state,
      onFailure: (_) => null,
    );

    final persistedState = _parsePersistedState(stateStr);

    final tokenResult = await _authRepository.getToken();
    final token = tokenResult.fold(
      onSuccess: (token) => token,
      onFailure: (_) => null,
    );

    if (token == null &&
        (persistedState == AuthState.pendingVerification ||
            persistedState == AuthState.pendingAdditionalVerification ||
            persistedState == AuthState.pendingOnboarding ||
            persistedState == AuthState.pendingDeletionCancellation)) {
      final emailResult = await _sessionRepository
          .getPendingVerificationEmail();
      final pendingEmail = emailResult.fold(
        onSuccess: (email) => email,
        onFailure: (_) => null,
      );

      _session = AuthSession(
        state: persistedState,
        token: token,
        pendingEmail: pendingEmail,
      );
      notifyListeners();
      return;
    }

    if (token != null) {
      final result = await _authRepository.getUserProfile();
      result.fold(
        onSuccess: (session) {
          _session = session;
          if (_session.isAuthenticated) {
            unawaited(_deviceTokenRegistrar.registerIfPossible());
          }
          notifyListeners();
        },
        onFailure: (failure) {
          // If it's a network error, we shouldn't wipe the session entirely
          // as the user might just be offline.
          if (failure is NetworkFailure || failure is ServerFailure) {
            // Keep the token but maybe flag as offline?
            // For now, we'll keep the session as authenticated with the token.
            _session = AuthSession(
              state: AuthState.authenticated,
              token: token,
              // We don't have the user object if we couldn't fetch it,
              // but we keep the token so they aren't forced to login again
            );
          } else {
            if (!_session.isAuthenticated) {
              _session = AuthSession.unauthenticated();
            }
          }
          notifyListeners();
        },
      );
    } else {
      if (persistedState != AuthState.unauthenticated) {
        final emailResult = await _sessionRepository
            .getPendingVerificationEmail();
        final pendingEmail = emailResult.fold(
          onSuccess: (email) => email,
          onFailure: (_) => null,
        );

        _session = AuthSession(
          state: persistedState,
          pendingEmail: pendingEmail,
        );
        notifyListeners();
      }
    }
  }

  /// Sets the authentication state to guest mode and persists it.
  Future<void> setGuestMode() async {
    _registrationDraft = null;
    _session = AuthSession.guest();
    await _sessionRepository.saveAuthState(AuthState.guest.name);
    notifyListeners();
  }

  /// The current authentication session.
  AuthSession get session => _session;

  /// The currently logged-in user.
  User? get currentUser => _session.user;

  /// The current authentication state.
  AuthState get state => _session.state;

  /// The persisted registration draft, if any.
  Map<String, dynamic>? get registrationDraft => _registrationDraft;

  /// The route that should resume the persisted registration draft, if any.
  String? get registrationRoute {
    final route = _registrationDraft?['route'];
    return route is String && route.isNotEmpty ? route : null;
  }

  /// The extra payload associated with the persisted registration draft.
  Map<String, dynamic>? get registrationData {
    final data = _registrationDraft?['extra'];
    return data is Map<String, dynamic> ? data : null;
  }

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _session.isAuthenticated;

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
