import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with [email] and [password].
  Future<User> login(String email, String password);

  /// Registers a new user.
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    bool isFamilyAccount = false,
  });

  /// Sends an OTP to the given [identifier].
  Future<void> sendOtp(String identifier);

  /// Verifies an OTP code for the given [identifier].
  Future<bool> verifyOtp(String identifier, String otp);

  /// Requests an OTP for enabling family account mode.
  Future<void> requestFamilyAccountOtp();

  /// Signs out the current user.
  Future<void> logout();

  /// Retrieves the current auth token, if any.
  Future<String?> getToken();

  /// Completes the registration process and signs the user in.
  Future<void> completeRegistration(User user);

  /// Stream of authentication state changes.
  Stream<User?> get onAuthStateChanged;
}
