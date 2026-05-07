import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';

/// Laravel API implementation of [UserRepository].
class ApiUserRepository implements UserRepository {
  final ApiClient _apiClient;

  ApiUserRepository(this._apiClient);

  @override
  Future<User> getUserProfile() async {
    final response =
        await _apiClient.get('/user/profile') as Map<String, dynamic>;
    final userModel = UserProfileModel.fromJson(response);
    return UserMapper.toEntity(userModel);
  }

  @override
  Future<User> updateUserProfile(User user) async {
    final model = UserMapper.fromEntity(user);
    final response =
        await _apiClient.put('/user/profile', model.toJson())
            as Map<String, dynamic>;
    final updatedModel = UserProfileModel.fromJson(response);
    return UserMapper.toEntity(updatedModel);
  }
}
