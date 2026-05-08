import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/course_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'dart:developer' as developer;

/// Laravel API implementation of [CourseRepository].
class ApiCourseRepository implements CourseRepository {
  final ApiClient _apiClient;

  ApiCourseRepository(this._apiClient);

  @override
  Future<Result<List<Course>, Failure>> getCourses() async {
    try {
      final response = await _apiClient.get('/courses') as List<dynamic>;
      final entities = response
          .map(
            (json) => CourseMapper.toEntity(
              CourseModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    } catch (e, stack) {
      developer.log('Error fetching courses', error: e, stackTrace: stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
