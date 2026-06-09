import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/session_booking.dart';

abstract interface class CourseRepository {
  Future<Result<List<Course>, Failure>> getCourses();
  Future<Result<Course, Failure>> getCourseDetails(String courseId);
  Future<Result<List<CourseSession>, Failure>> getCourseSessions(
    String courseId,
  );
  Future<Result<void, Failure>> bookSession(
    String courseId,
    String sessionId,
    String date,
  );
  Future<Result<SessionBooking, Failure>> getSessionBooking(
    String courseId,
    String sessionId,
  );
}
