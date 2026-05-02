import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing authentication state and actions.
class AuthService extends ChangeNotifier {
  static const String _authKey = 'auth_token';
  final SharedPreferences _prefs;

  UserProfile? _currentUser;
  bool _isAuthenticated = false;

  AuthService(this._prefs) {
    _loadAuthState();
  }

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _isAuthenticated;

  /// The currently logged-in user.
  UserProfile? get currentUser => _currentUser;

  void _loadAuthState() {
    final token = _prefs.getString(_authKey);
    if (token != null) {
      _isAuthenticated = true;
      // TODO: Fetch real user data from API using token
      _currentUser = _mockUser;
    }
  }

  /// Logs in the user with [email] and [password].
  Future<bool> login(String email, String password) async {
    // Hardcoded Credentials for development
    if (email == 'test@testor.com' && password == 'password') {
      await _persistLogin('mock_token_123');
      return true;
    }

    // TODO: Implement real API authentication here
    // Example:
    // final response = await _api.post('/login', body: {'email': email, 'password': password});
    // if (response.statusCode == 200) {
    //   await _persistLogin(response.token);
    //   return true;
    // }

    return false;
  }

  /// Automatically logs in a mock user in Debug mode.
  Future<void> autoLoginDebug() async {
    if (kDebugMode) {
      await login('test@testor.com', 'password');
    }
  }

  Future<void> _persistLogin(String token) async {
    await _prefs.setString(_authKey, token);
    _isAuthenticated = true;
    _currentUser = _mockUser;
    notifyListeners();
  }

  /// Logs out the current user.
  Future<void> logout() async {
    await _prefs.remove(_authKey);
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  // Mock user for development
  static const UserProfile _mockUser = UserProfile(
    id: 'dev_user_1',
    name: 'Dev Tester',
    email: 'test@testor.com',
    avatarUrl: 'https://i.pravatar.cc/150?u=dev_user_1',
    loyaltyPoints: 1250,
    subscriptionLevel: 'Premium',
    subscriptionExpiry: '2026-12-31',
    totalCheckIns: 42,
  );
}
