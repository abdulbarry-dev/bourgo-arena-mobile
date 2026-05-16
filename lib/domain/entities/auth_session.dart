import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Verification data for additional verification steps.
class VerificationData {
  final String unverifiedMethod;
  final String? email;
  final String? phone;

  const VerificationData({
    required this.unverifiedMethod,
    this.email,
    this.phone,
  });

  /// Creates a copy of this [VerificationData] but with the given fields replaced.
  VerificationData copyWith({
    String? unverifiedMethod,
    String? email,
    String? phone,
  }) {
    return VerificationData(
      unverifiedMethod: unverifiedMethod ?? this.unverifiedMethod,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

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

  /// Metadata for additional verification (e.g. phone).
  final VerificationData? verificationData;

  /// Whether the user needs to perform a secondary OTP verification upon login.
  /// This is only applicable for fully onboarded users who haven't opted out.
  final bool needsLoginVerification;

  /// Creates a new [AuthSession].
  const AuthSession({
    this.user,
    required this.state,
    this.token,
    this.pendingEmail,
    this.verificationData,
    this.needsLoginVerification = false,
  });

  /// Creates a copy of this [AuthSession] but with the given fields replaced.
  AuthSession copyWith({
    User? user,
    AuthState? state,
    String? token,
    String? pendingEmail,
    VerificationData? verificationData,
    bool? needsLoginVerification,
  }) {
    return AuthSession(
      user: user ?? this.user,
      state: state ?? this.state,
      token: token ?? this.token,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      verificationData: verificationData ?? this.verificationData,
      needsLoginVerification:
          needsLoginVerification ?? this.needsLoginVerification,
    );
  }

  /// Creates an unauthenticated session.
  factory AuthSession.unauthenticated() =>
      const AuthSession(state: AuthState.unauthenticated);

  /// Whether the session is fully authenticated.
  bool get isAuthenticated => state == AuthState.authenticated && user != null;
}
