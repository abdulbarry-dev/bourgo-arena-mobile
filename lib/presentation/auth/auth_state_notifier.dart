import 'dart:async';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

/// Notifier for listening to authentication state changes.
class AuthStateNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _currentUser;
  StreamSubscription<User?>? _authSubscription;

  AuthStateNotifier(this._authRepository) {
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
