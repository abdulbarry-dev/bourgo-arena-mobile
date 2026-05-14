import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Represents an authentication session, including the user and current state.
class AuthSession {
  /// The authenticated user, if available.
  final User? user;

  /// The current authentication state.
  final AuthState state;

  /// The authentication token, if available.
  final String? token;

  /// The email address awaiting verification, if any.
  final String? pendingEmail;

  /// Creates a new [AuthSession].
  const AuthSession({
    this.user,
    required this.state,
    this.token,
    this.pendingEmail,
  });

  /// Creates an unauthenticated session.
  factory AuthSession.unauthenticated() =>
      const AuthSession(state: AuthState.unauthenticated);

  /// Whether the session is fully authenticated.
  bool get isAuthenticated => state == AuthState.authenticated && user != null;
}
