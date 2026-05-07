import 'dart:async';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Laravel API implementation of [AuthRepository].
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  ApiAuthRepository(this._apiClient);

  @override
  Future<Result<User, Failure>> login(String email, String password) async {
    try {
      final response =
          await _apiClient.post('/auth/login', {
                'email': email,
                'password': password,
              })
              as Map<String, dynamic>;

      final token = response['token'] as String;
      _apiClient.setToken(token);

      // Fetch user profile after login
      final userResponse =
          await _apiClient.get('/user/profile') as Map<String, dynamic>;
      final userModel = UserProfileModel.fromJson(userResponse);
      final user = UserMapper.toEntity(userModel);

      _authStateController.add(user);
      return Success(user);
    } catch (e) {
      return FailureResult(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> logout() async {
    try {
      await _apiClient.post('/auth/logout', {});
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure('Logout failed: ${e.toString()}'));
    } finally {
      _apiClient.setToken(null);
      _authStateController.add(null);
    }
  }

  @override
  Future<Result<void, Failure>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    bool isFamilyAccount = false,
  }) async {
    try {
      await _apiClient.post('/auth/register', {
        'name': '$firstName $lastName',
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password, // Ideally passed from UI
        'is_family_account': isFamilyAccount,
      });
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> sendOtp(String identifier) async {
    try {
      await _apiClient.post('/auth/send-otp', {'identifier': identifier});
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure('Send OTP failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<bool, Failure>> verifyOtp(String identifier, String otp) async {
    try {
      final response =
          await _apiClient.post('/auth/verify-otp', {
                'identifier': identifier,
                'otp': otp,
              })
              as Map<String, dynamic>;
      return Success(response['success'] == true);
    } catch (e) {
      return FailureResult(ServerFailure('Verify OTP failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> requestFamilyAccountOtp() async {
    try {
      await _apiClient.post('/auth/request-family-otp', {});
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure('Request family OTP failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> completeRegistration(User user) async {
    try {
      await _apiClient.post('/auth/complete-registration', {
        'name': '${user.firstName} ${user.lastName}',
        'email': user.email,
        'phone': user.phone,
        'is_parent_account': user.isParentAccount,
      });
      _authStateController.add(user);
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure('Complete registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<String?> getToken() async {
    // In a production app, this would be retrieved from secure storage (e.g. flutter_secure_storage)
    return null;
  }

  @override
  Stream<User?> get onAuthStateChanged => _authStateController.stream;
}
