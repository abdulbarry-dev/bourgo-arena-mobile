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
    final response = await _apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final token = response['token'] as String;
    _apiClient.setToken(token);

    // Fetch user profile after login
    final userResponse = await _apiClient.get('/user/profile');
    final userModel = UserProfileModel.fromJson(userResponse);
    final user = UserMapper.toEntity(userModel);

    _authStateController.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _apiClient.post('/auth/logout', {});
    _apiClient.setToken(null);
    _authStateController.add(null);
  }

  @override
  Future<String?> getToken() async {
    // In a real app, this might come from secure storage
    return null;
  }

  @override
  Stream<User?> get onAuthStateChanged => _authStateController.stream;
}
