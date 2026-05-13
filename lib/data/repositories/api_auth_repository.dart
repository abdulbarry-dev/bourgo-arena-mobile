import 'dart:async';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

/// Laravel API implementation of [AuthRepository].
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final SessionRepository _sessionRepository;
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  ApiAuthRepository(this._apiClient, this._sessionRepository);

  @override
  Future<Result<User, Failure>> login(String email, String password) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/auth/login', {
                'email': email,
                'password': password,
              })
              as Map<String, dynamic>;

      final token = response['token'] as String;
      _apiClient.setToken(token);

      // Persist the token to local session storage
      await _sessionRepository.saveAuthToken(token);

      // Fetch user profile after login
      final userResponse =
          await _apiClient.get('/user/profile') as Map<String, dynamic>;
      final userModel = UserProfileModel.fromJson(userResponse);
      final user = UserMapper.toEntity(userModel);

      _authStateController.add(user);
      return Success(user);
    });
  }

  @override
  Future<Result<void, Failure>> logout() {
    return executeApiCall(() async {
      try {
        await _apiClient.post('/auth/logout', {});
        return const Success(null);
      } finally {
        _apiClient.setToken(null);
        // Clear the persisted session (including the token)
        await _sessionRepository.clearSession();
        _authStateController.add(null);
      }
    });
  }

  @override
  Future<Result<void, Failure>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    bool isFamilyAccount = false,
  }) {
    return executeApiCall(() async {
      await _apiClient.post('/auth/register', {
        'name': '$firstName $lastName',
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password, // Ideally passed from UI
        'is_family_account': isFamilyAccount,
      });
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> sendOtp(String identifier) {
    return executeApiCall(() async {
      await _apiClient.post('/auth/send-otp', {'identifier': identifier});
      return const Success(null);
    });
  }

  @override
  Future<Result<bool, Failure>> verifyOtp(String identifier, String otp) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/auth/verify-otp', {
                'identifier': identifier,
                'otp': otp,
              })
              as Map<String, dynamic>;
      return Success(response['valid'] == true);
    });
  }

  @override
  Future<Result<void, Failure>> requestFamilyAccountOtp() {
    return executeApiCall(() async {
      await _apiClient.post('/auth/request-family-otp', {});
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> completeRegistration(User user) {
    return executeApiCall(() async {
      await _apiClient.post('/auth/complete-registration', {
        'name': '${user.firstName} ${user.lastName}',
        'email': user.email,
        'phone': user.phone,
        'is_parent_account': user.isParentAccount,
      });
      _authStateController.add(user);
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return executeApiCall(() async {
      await _apiClient.put('/user/password', {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      });
      return const Success(null);
    });
  }

  @override
  Future<Result<String?, Failure>> getToken() async {
    // Retrieve the persisted auth token from local session storage
    return _sessionRepository.getAuthToken();
  }

  @override
  Stream<User?> get onAuthStateChanged => _authStateController.stream;
}
