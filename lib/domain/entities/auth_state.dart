/// Represents the possible authentication states of the application.
enum AuthState {
  /// User is not logged in.
  unauthenticated,

  /// User has registered or logged in but needs to verify at least one method (email or phone).
  pendingVerification,

  /// User has verified one method (email or phone) but must verify the other method.
  pendingAdditionalVerification,

  /// User is verified but has not completed the required onboarding steps.
  pendingOnboarding,

  /// User is fully authenticated and has completed all requirements.
  authenticated,

  /// User attempted login while their account is scheduled for deletion and must
  /// verify an OTP to cancel the deletion window.
  pendingDeletionCancellation,
}
