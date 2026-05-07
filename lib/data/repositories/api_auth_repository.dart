import 'dart:async';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Laravel API implementation of [AuthRepository].
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  ApiAuthRepository(this._apiClient);

  @override
  Future<User> login(String email, String password) async {
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
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', {});
    } catch (_) {
      // Ignore logout errors (e.g. token already expired)
    } finally {
      _apiClient.setToken(null);
      _authStateController.add(null);
    }
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    bool isFamilyAccount = false,
  }) async {
    await _apiClient.post('/auth/register', {
      'name': '$firstName $lastName',
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': password, // Ideally passed from UI
      'is_family_account': isFamilyAccount,
    });
  }

  @override
  Future<void> sendOtp(String identifier) async {
    await _apiClient.post('/auth/send-otp', {'identifier': identifier});
  }

  @override
  Future<bool> verifyOtp(String identifier, String otp) async {
    final response =
        await _apiClient.post('/auth/verify-otp', {
              'identifier': identifier,
              'otp': otp,
            })
            as Map<String, dynamic>;
    return response['success'] == true;
  }

  @override
  Future<void> requestFamilyAccountOtp() async {
    await _apiClient.post('/auth/request-family-otp', {});
  }

  @override
  Future<void> completeRegistration(User user) async {
    await _apiClient.post('/auth/complete-registration', {
      'name': '${user.firstName} ${user.lastName}',
      'email': user.email,
      'phone': user.phone,
      'is_parent_account': user.isParentAccount,
    });
    _authStateController.add(user);
  }

  @override
  Future<String?> getToken() async {
    // In a production app, this would be retrieved from secure storage (e.g. flutter_secure_storage)
    return null;
  }

  @override
  Stream<User?> get onAuthStateChanged => _authStateController.stream;
}
