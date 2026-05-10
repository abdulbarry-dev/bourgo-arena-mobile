import 'package:bourgo_arena_mobile/data/mappers/course_mapper.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('CourseMapper', () {
    test('maps a fully populated DTO to an entity', () {
      final dto = testCourseModel();

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.id, dto.id);
      expect(mapped.title, dto.title);
      expect(mapped.instructor, dto.instructor);
      expect(mapped.startTime, dto.startTime);
      expect(mapped.endTime, dto.endTime);
      expect(mapped.dayOfWeek, dto.dayOfWeek);
      expect(mapped.category, dto.category);
      expect(mapped.capacity, dto.capacity);
      expect(mapped.enrolled, dto.enrolled);
      expect(mapped.icon, dto.icon);
    });

    test('handles boundary values like full capacity and zero enrollment', () {
      final dto = testCourseModel(capacity: 0, enrolled: 0);

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.capacity, 0);
      expect(mapped.enrolled, 0);
      expect(mapped.isFull, isTrue);
      expect(mapped.remainingSpots, 0);
    });

    test('correctly calculates remaining spots and fullness', () {
      final dto = testCourseModel(capacity: 10, enrolled: 4);

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.capacity, 10);
      expect(mapped.enrolled, 4);
      expect(mapped.isFull, isFalse);
      expect(mapped.remainingSpots, 6);
    });

    test('preserves the icon field exactly', () {
      final dto = testCourseModel(icon: 'self_improvement');

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.icon, 'self_improvement');
    });

    test('maps an entity back to the DTO', () {
      final course = entity.Course(
        id: 'course-2',
        title: 'Yoga Flow',
        instructor: 'Coach Ana',
        startTime: '07:00',
        endTime: '08:00',
        dayOfWeek: 7,
        category: 'Wellness',
        capacity: 12,
        enrolled: 3,
        icon: 'self_improvement',
      );

      final dto = CourseMapper.fromEntity(course);

      expect(dto.id, course.id);
      expect(dto.icon, course.icon);
      expect(course.remainingSpots, 9);
      expect(dto.capacity, course.capacity);
      expect(dto.enrolled, course.enrolled);
    });

    test('toEntityList converts a list of DTOs', () {
      final dtos = [testCourseModel(id: 'c1'), testCourseModel(id: 'c2')];

      final entities = dtos.toEntityList();

      expect(entities.length, 2);
      expect(entities[0].id, 'c1');
      expect(entities[1].id, 'c2');
    });
  });
}
