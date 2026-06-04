/// Tracks which verification methods have been completed for a user.
class VerificationStatus {
  /// Whether the email has been verified.
  final bool emailVerified;

  /// Whether the phone has been verified.
  final bool phoneVerified;

  /// Whether the onboarding process has been completed.
  final bool onboardingCompleted;

  final bool? _isFullyVerified;

  /// The email address, if provided.
  final String? email;

  /// The phone number, if provided.
  final String? phone;

  final String? _unverifiedMethod;

  /// Creates a new [VerificationStatus].
  const VerificationStatus({
    required this.emailVerified,
    required this.phoneVerified,
    required this.onboardingCompleted,
    bool? isFullyVerified,
    this.email,
    this.phone,
    String? unverifiedMethod,
  }) : _isFullyVerified = isFullyVerified,
       _unverifiedMethod = unverifiedMethod;

  /// Returns true if at least one method is verified.
  bool get isPartiallyVerified => emailVerified || phoneVerified;

  /// Returns true when both email and phone are verified.
  bool get isFullyVerified =>
      _isFullyVerified ?? (emailVerified && phoneVerified);

  /// Returns the method that still needs verification (if any).
  String? get unverifiedMethod {
    if (_unverifiedMethod != null) return _unverifiedMethod;
    if (emailVerified && phoneVerified) return null;
    if (emailVerified && !phoneVerified) return 'phone';
    if (!emailVerified && phoneVerified) return 'email';
    // Neither verified; backend may decide what to request first.
    return null;
  }

  /// Factory to create from JSON response.
  factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? false,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      isFullyVerified: json['is_fully_verified'] as bool?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      unverifiedMethod: json['unverified_method'] as String?,
    );
  }

  /// Converts to JSON for requests.
  Map<String, dynamic> toJson() => {
    'email_verified': emailVerified,
    'phone_verified': phoneVerified,
    'onboarding_completed': onboardingCompleted,
    'is_fully_verified': isFullyVerified,
    'email': email,
    'phone': phone,
    'unverified_method': unverifiedMethod,
  };
}
