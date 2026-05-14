import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:flutter/foundation.dart';

/// Notifier for listening to authentication state changes.
class AuthStateNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final DeviceTokenRegistrar _deviceTokenRegistrar;

  AuthSession _session = AuthSession.unauthenticated();
  StreamSubscription<AuthSession>? _authSubscription;

  AuthStateNotifier(
    this._authRepository,
    this._sessionRepository,
    this._deviceTokenRegistrar,
  ) {
    _init();
  }

  void _init() {
    _authSubscription = _authRepository.onAuthStateChanged.listen((session) {
      _session = session;
      if (session.isAuthenticated) {
        unawaited(_deviceTokenRegistrar.registerIfPossible());
      }
      notifyListeners();
    });
  }

  /// Initializes the auth state by fetching the current user profile if a
  /// token exists, or restoring a pending state from persistence.
  Future<void> initialize() async {
    final tokenResult = await _authRepository.getToken();
    final token = tokenResult.fold(
      onSuccess: (token) => token,
      onFailure: (_) => null,
    );

    if (token != null) {
      final result = await _authRepository.getUserProfile();
      if (result is FailureResult<AuthSession, Failure>) {
        _session = AuthSession.unauthenticated();
        notifyListeners();
      }
    } else {
      // If no token, check if we have a persisted auth state (e.g. pending_verification)
      final stateResult = await _sessionRepository.getAuthState();
      final stateStr = stateResult.fold(
        onSuccess: (state) => state,
        onFailure: (_) => null,
      );

      if (stateStr != null) {
        final state = AuthState.values.firstWhere(
          (e) => e.name == stateStr,
          orElse: () => AuthState.unauthenticated,
        );

        final emailResult = await _sessionRepository
            .getPendingVerificationEmail();
        final pendingEmail = emailResult.fold(
          onSuccess: (email) => email,
          onFailure: (_) => null,
        );

        _session = AuthSession(state: state, pendingEmail: pendingEmail);
        notifyListeners();
      }
    }
  }

  /// The current authentication session.
  AuthSession get session => _session;

  /// The currently logged-in user.
  User? get currentUser => _session.user;

  /// The current authentication state.
  AuthState get state => _session.state;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _session.isAuthenticated;

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
