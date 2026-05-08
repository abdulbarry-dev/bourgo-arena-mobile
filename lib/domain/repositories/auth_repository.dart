import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with [email] and [password].
  Future<Result<User, Failure>> login(String email, String password);

  /// Registers a new user.
  Future<Result<void, Failure>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
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
  Future<String?> getToken();

  /// Completes the registration process and signs the user in.
  Future<Result<void, Failure>> completeRegistration(User user);

  /// Stream of authentication state changes.
  Stream<User?> get onAuthStateChanged;
}
