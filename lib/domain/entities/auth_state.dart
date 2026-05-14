/// Represents the possible authentication states of the application.
enum AuthState {
  /// User is not logged in.
  unauthenticated,

  /// User has registered or logged in but needs to verify their email/OTP.
  pendingVerification,

  /// User is verified but has not completed the required onboarding steps.
  pendingOnboarding,

  /// User is fully authenticated and has completed all requirements.
  authenticated,
}
