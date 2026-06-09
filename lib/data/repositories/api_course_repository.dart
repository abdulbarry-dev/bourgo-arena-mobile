import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/course_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/data/models/course_session_model.dart';
import 'package:bourgo_arena_mobile/data/models/session_booking_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/session_booking.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

class ApiCourseRepository implements CourseRepository {
  final ApiClient _apiClient;

  ApiCourseRepository(this._apiClient);

  @override
  Future<Result<List<Course>, Failure>> getCourses() {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/courses', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final entities = data
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
      return Result.success(CourseMapper.toEntity(CourseModel.fromJson(data)));
    });
  }

  @override
  Future<Result<List<CourseSession>, Failure>> getCourseSessions(
    String courseId,
  ) {
    return executeApiCall(() async {
      final response = await _apiClient.get('/courses/$courseId/sessions');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
                []);
      final entities = data
          .map(
            (json) => CourseMapper.toSessionEntity(
              CourseSessionModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<void, Failure>> bookSession(
    String courseId,
    String sessionId,
    String date,
  ) {
    return executeApiCall(() async {
      await _apiClient.post('/courses/$courseId/sessions/$sessionId/book', {
        'date': date,
      });
      return Result.success(null);
    });
  }

  @override
  Future<Result<SessionBooking, Failure>> getSessionBooking(
    String courseId,
    String sessionId,
  ) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/courses/$courseId/sessions/$sessionId/booking')
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      return Result.success(SessionBookingModel.fromJson(data).toEntity());
    });
  }
}
