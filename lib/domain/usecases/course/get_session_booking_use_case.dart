import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/session_booking.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

class GetSessionBookingUseCase {
  final CourseRepository _repository;

  const GetSessionBookingUseCase(this._repository);

  Future<Result<SessionBooking, Failure>> call(
    String courseId,
    String sessionId,
  ) {
    return _repository.getSessionBooking(courseId, sessionId);
  }
}
