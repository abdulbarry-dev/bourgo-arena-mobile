import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/course_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

/// Laravel API implementation of [CourseRepository].
class ApiCourseRepository implements CourseRepository {
  final ApiClient _apiClient;

  ApiCourseRepository(this._apiClient);

  @override
  Future<Result<List<Course>, Failure>> getCourses() {
    return executeApiCall(() async {
      final response = await _apiClient.get('/courses') as List<dynamic>;
      final entities = response
          .map(
            (json) => CourseMapper.toEntity(
              CourseModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<Course, Failure>> getCourseDetails(String courseId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/courses/$courseId') as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      final entity = CourseMapper.toEntity(CourseModel.fromJson(data));
      return Result.success(entity);
    });
  }

  @override
  Future<Result<List<dynamic>, Failure>> getCourseSessions(String courseId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/courses/$courseId/sessions') as List<dynamic>;
      // For now, return dynamic or map to SessionModel later
      return Result.success(response);
    });
  }
}
