import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Laravel API implementation of [FamilyRepository].
class ApiFamilyRepository implements FamilyRepository {
  final ApiClient _apiClient;

  ApiFamilyRepository(this._apiClient);

  @override
  Future<Result<List<ChildProfile>, Failure>> getChildren() {
    return executeApiCall(() async {
      final response = await _apiClient.get('/family/children');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ?? []);
      final entities = data
          .map(
            (json) => ChildMapper.toEntity(
              ChildProfileModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<ChildProfile, Failure>> addChild({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/family/children', {
                'first_name': firstName,
                'last_name': lastName,
                'birth_date': birthDate.toIso8601String().split('T').first,
                'gender': gender,
                'avatar_url': avatarUrl,
              })
              as Map<String, dynamic>;

      return Result.success(
        ChildMapper.toEntity(ChildProfileModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<ChildProfile, Failure>> updateChild({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.put('/family/members/$id', {
                'first_name': firstName,
                'last_name': lastName,
                'birth_date': birthDate.toIso8601String().split('T').first,
                'gender': gender,
                'avatar_url': avatarUrl,
              })
              as Map<String, dynamic>;

      return Result.success(
        ChildMapper.toEntity(ChildProfileModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<void, Failure>> removeChild(String id) {
    return executeApiCall(() async {
      await _apiClient.delete('/family/children/$id');
      return Result.success(null);
    });
  }

  @override
  Future<Result<void, Failure>> disableFamilyFeature() {
    return executeApiCall(() async {
      await _apiClient.post('/family/disable-feature', {});
      return Result.success(null);
    });
  }

  @override
  Future<Result<void, Failure>> enableFamilyFeature() {
    return executeApiCall(() async {
      await _apiClient.post('/family/enable-feature', {});
      return Result.success(null);
    });
  }
}
