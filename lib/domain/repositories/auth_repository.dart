import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/otp_delivery_method.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';

/// Interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with [identifier] (email or phone) and [password].
  Future<Result<AuthSession, Failure>> login(
    String identifier,
    String password,
  );

  /// Registers a new user.
  Future<Result<void, Failure>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required DateTime birthDate,
    bool isFamilyAccount = false,
  });

  /// Sends an OTP to the given [identifier].
  Future<Result<void, Failure>> sendOtp(String identifier);

  /// Verifies an OTP code for the given [identifier].
  /// Returns true if verification was successful.
  /// Checks full verification status and may transition to pending_additional_verification
  /// if only one method (email or phone) is verified.
  Future<Result<bool, Failure>> verifyOtp(String identifier, String otp);

  /// Verifies a user's email address via OTP.
  /// Used when a user has initially verified by phone and needs email verification.
  Future<Result<bool, Failure>> verifyEmail(String email, String otp);

  /// Verifies a user's phone number via OTP.
  /// Used when a user has initially verified by email and needs phone verification.
  Future<Result<bool, Failure>> verifyPhone(String phone, String otp);

  /// Allows the user to explicitly skip the secondary verification method.
  Future<Result<bool, Failure>> skipAdditionalVerification();

  /// Retrieves the current verification status for the authenticated user.
  /// Shows which methods (email/phone) have been verified.
  Future<Result<VerificationStatus, Failure>> getVerificationStatus();

  /// Requests an OTP for enabling family account mode.
  ///
  /// Returns the backend response message to display in UI feedback.
  Future<Result<String, Failure>> requestFamilyAccountOtp({
    OtpDeliveryMethod? method,
    String? identifier,
  });

  /// Requests account deletion. Requires the user's current password for confirmation.
  Future<Result<void, Failure>> deleteAccount({required String password});

  /// Signs out the current user.
  Future<Result<void, Failure>> logout();

  /// Updates the user's password.
  Future<Result<void, Failure>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Retrieves the current auth token, if any.
  Future<Result<String?, Failure>> getToken();

  /// Completes the registration process and signs the user in.
  Future<Result<void, Failure>> completeRegistration(User user);

  /// Requests a password reset OTP for the given [identifier].
  Future<Result<void, Failure>> forgotPassword(String identifier);

  /// Resets the user's password using an [identifier], [otp], and [newPassword].
  Future<Result<void, Failure>> resetPassword({
    required String identifier,
    required String otp,
    required String newPassword,
  });

  /// Fetches the profile of the currently authenticated user.
  Future<Result<AuthSession, Failure>> getUserProfile();

  /// Uploads a profile avatar image file.
  Future<Result<AuthSession, Failure>> uploadAvatar(String filePath);

  /// Deletes the current profile avatar.
  Future<Result<AuthSession, Failure>> deleteAvatar();

  /// Fetches the authenticated member's tier information.
  Future<Result<AuthSession, Failure>> getMemberTier();

  /// Stream of authentication state changes.
  Stream<AuthSession> get onAuthStateChanged;
}
