import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

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
  Future<Result<bool, Failure>> verifyOtp(String identifier, String otp);

  /// Requests an OTP for enabling family account mode.
  Future<Result<void, Failure>> requestFamilyAccountOtp();

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
  Future<Result<void, Failure>> completeRegistration(User user, String pin);

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

  /// Stream of authentication state changes.
  Stream<AuthSession> get onAuthStateChanged;
}
