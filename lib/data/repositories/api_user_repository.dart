import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'dart:developer' as developer;

/// Laravel API implementation of [UserRepository].
class ApiUserRepository implements UserRepository {
  final ApiClient _apiClient;

  ApiUserRepository(this._apiClient);

  @override
  Future<Result<User, Failure>> getUserProfile() async {
    try {
      final response =
          await _apiClient.get('/user/profile') as Map<String, dynamic>;
      final userModel = UserProfileModel.fromJson(response);
      return Result.success(UserMapper.toEntity(userModel));
    } catch (e, stack) {
      developer.log('Error fetching user profile', error: e, stackTrace: stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<User, Failure>> updateUserProfile(User user) async {
    try {
      final model = UserMapper.fromEntity(user);
      final response =
          await _apiClient.put('/user/profile', model.toJson())
              as Map<String, dynamic>;
      final updatedModel = UserProfileModel.fromJson(response);
      return Result.success(UserMapper.toEntity(updatedModel));
    } catch (e, stack) {
      developer.log('Error updating user profile', error: e, stackTrace: stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
