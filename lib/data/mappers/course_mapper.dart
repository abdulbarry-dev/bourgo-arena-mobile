import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;

/// Mapper to convert between [CourseModel] and [entity.Course].
class CourseMapper {
  /// Converts [CourseModel] to [entity.Course].
  static entity.Course toEntity(CourseModel course) {
    return entity.Course(
      id: course.id,
      title: course.title,
      instructor: course.instructor,
      startTime: course.startTime,
      endTime: course.endTime,
      dayOfWeek: course.dayOfWeek,
      category: course.category,
      capacity: course.capacity,
      enrolled: course.enrolled,
      icon: course.icon,
    );
  }

  /// Converts [entity.Course] to [CourseModel].
  static CourseModel fromEntity(entity.Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      instructor: course.instructor,
      startTime: course.startTime,
      endTime: course.endTime,
      dayOfWeek: course.dayOfWeek,
      category: course.category,
      capacity: course.capacity,
      enrolled: course.enrolled,
      icon: course.icon,
    );
  }
}

/// Extension for convenient mapping of [CourseModel] list.
extension CourseModelListX on List<CourseModel> {
  /// Converts a list of [CourseModel] to a list of [entity.Course].
  List<entity.Course> toEntityList() => map(CourseMapper.toEntity).toList();
}
