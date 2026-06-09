import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/data/models/course_session_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';

class CourseMapper {
  static Course toEntity(CourseModel model) {
    return Course(
      id: model.id,
      name: model.name ?? model.displayTitle,
      description: model.description,
      images: model.images ?? (model.imageUrl != null ? [model.imageUrl!] : const []),
      imageUrl: model.imageUrl,
      status: model.status,
    );
  }

  static CourseModel fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      name: course.name,
      description: course.description,
      images: course.images,
      imageUrl: course.imageUrl,
      status: course.status,
    );
  }

  static CourseSession toSessionEntity(CourseSessionModel model) {
    return CourseSession(
      id: model.id,
      title: model.title ?? '',
      startTime: model.startTime ?? '',
      endTime: model.endTime ?? '',
      dayOfWeek: model.dayOfWeek ?? 1,
      capacity: model.capacity ?? 0,
      enrolled: model.enrolled ?? 0,
      imageUrl: model.imageUrl,
      isBooked: model.isBooked ?? false,
    );
  }
}

extension CourseModelListX on List<CourseModel> {
  List<Course> toEntityList() => map(CourseMapper.toEntity).toList();
}

extension CourseSessionModelListX on List<CourseSessionModel> {
  List<CourseSession> toEntityList() =>
      map(CourseMapper.toSessionEntity).toList();
}
