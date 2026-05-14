import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/models/access_history_model.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';

/// Laravel API implementation of [UserRepository].
class ApiUserRepository implements UserRepository {
  final ApiClient _apiClient;

  ApiUserRepository(this._apiClient);

  @override
  Future<Result<User, Failure>> getUserProfile() {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/user/profile') as Map<String, dynamic>;
      final userModel = UserProfileModel.fromJson(response);
      return Result.success(UserMapper.toEntity(userModel));
    });
  }

  @override
  Future<Result<List<AccessHistoryEntry>, Failure>> getAccessHistory() {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/user/access-history') as List<dynamic>;

      final entries = response.map((json) {
        final model = AccessHistoryModel.fromJson(json as Map<String, dynamic>);
        return AccessHistoryEntry(
          id: model.id,
          checkedInAt: model.checkedInAt,
          location: model.location,
        );
      }).toList();

      return Result.success(entries);
    });
  }

  @override
  Future<Result<User, Failure>> updateUserProfile(User user) {
    return executeApiCall(() async {
      final model = UserMapper.fromEntity(user);
      final response =
          await _apiClient.put('/user/profile', model.toJson())
              as Map<String, dynamic>;
      final updatedModel = UserProfileModel.fromJson(response);
      return Result.success(UserMapper.toEntity(updatedModel));
    });
  }
}
