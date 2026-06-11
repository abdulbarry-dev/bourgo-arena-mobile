import 'package:bourgo_arena_mobile/data/models/child_booking_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';

class ChildBookingMapper {
  static ChildBooking toEntity(ChildBookingModel model) {
    return ChildBooking(
      id: model.id,
      sessionId: model.sessionId,
      courseId: model.courseId,
      courseName: model.courseName ?? '',
      date: model.date ?? '',
      startTime: model.startTime ?? '',
      endTime: model.endTime ?? '',
      status: model.status ?? 'pending',
      completedAt: model.completedAtDateTime,
    );
  }

  static ChildBookingModel fromEntity(ChildBooking entity) {
    return ChildBookingModel(
      id: entity.id,
      sessionId: entity.sessionId,
      courseId: entity.courseId,
      courseName: entity.courseName,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      completedAt: entity.completedAt?.toIso8601String(),
    );
  }
}
