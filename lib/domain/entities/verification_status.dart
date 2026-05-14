/// Tracks which verification methods have been completed for a user.
class VerificationStatus {
  /// Whether the email has been verified.
  final bool emailVerified;

  /// Whether the phone has been verified.
  final bool phoneVerified;

  /// The email address, if provided.
  final String? email;

  /// The phone number, if provided.
  final String? phone;

  /// Creates a new [VerificationStatus].
  const VerificationStatus({
    required this.emailVerified,
    required this.phoneVerified,
    this.email,
    this.phone,
  });

  /// Returns true if at least one method is verified.
  bool get isPartiallyVerified => emailVerified || phoneVerified;

  /// Returns true if both methods are verified.
  bool get isFullyVerified => emailVerified && phoneVerified;

  /// Returns the unverified method, or null if both are verified.
  String? get unverifiedMethod {
    if (!emailVerified && email != null) return 'email';
    if (!phoneVerified && phone != null) return 'phone';
    return null;
  }

  /// Factory to create from JSON response.
  factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? false,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  /// Converts to JSON for requests.
  Map<String, dynamic> toJson() => {
    'email_verified': emailVerified,
    'phone_verified': phoneVerified,
    'email': email,
    'phone': phone,
  };
}
