import 'dart:async';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

/// Service for managing authentication state and actions.
class AuthService extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _currentUser;
  bool _isLoading = false;
  StreamSubscription<User?>? _authSubscription;

  AuthService(this._authRepository) {
    _init();
  }

  void _init() {
    _authSubscription = _authRepository.onAuthStateChanged.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// The currently logged-in user.
  User? get currentUser => _currentUser;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _currentUser != null;

  /// Whether an auth operation is in progress.
  bool get isLoading => _isLoading;

  /// Logs in the user with [email] and [password].
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepository.login(email, password);
    } catch (e) {
      developer.log('Login failed', error: e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
    } catch (e) {
      developer.log('Logout failed', error: e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sends an OTP to the given [identifier].
  Future<void> sendOtp(String identifier) async {
    _setLoading(true);
    try {
      await _authRepository.sendOtp(identifier);
    } catch (e) {
      developer.log('Send OTP failed', error: e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Verifies the [otp] for the given [identifier].
  Future<bool> verifyOtp(String identifier, String otp) async {
    _setLoading(true);
    try {
      return await _authRepository.verifyOtp(identifier, otp);
    } catch (e) {
      developer.log('Verify OTP failed', error: e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
