import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with [email] and [password].
  Future<User> login(String email, String password);

  /// Signs out the current user.
  Future<void> logout();

  /// Retrieves the current auth token, if any.
  Future<String?> getToken();

  /// Stream of authentication state changes.
  Stream<User?> get onAuthStateChanged;
}
