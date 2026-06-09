import 'package:bourgo_arena_mobile/data/mappers/course_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:bourgo_arena_mobile/data/models/course_session_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('CourseMapper', () {
    test('maps a fully populated DTO to a Course entity', () {
      final dto = testCourseModel();

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.id, dto.id);
      expect(mapped.name, dto.displayTitle);
      expect(mapped.description, dto.description);
      expect(mapped.images, isNotEmpty);
      expect(mapped.status, dto.status);
    });

    test('handles missing optional fields with defaults', () {
      final dto = CourseModel(id: 'c1');

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.description, isNull);
      expect(mapped.status, isNull);
      expect(mapped.images, isEmpty);
    });

    test('preserves image URL when images list is empty', () {
      final dto = testCourseModel(images: []);

      final mapped = CourseMapper.toEntity(dto);

      expect(mapped.imageUrl, dto.imageUrl);
    });

    test('maps a CourseSessionModel to a CourseSession entity', () {
      final model = CourseSessionModel(
        id: 's1',
        title: 'Morning Yoga',
        startTime: '08:00',
        endTime: '09:00',
        dayOfWeek: 1,
        capacity: 20,
        enrolled: 12,
        imageUrl: 'https://example.com/img.jpg',
      );

      final session = CourseMapper.toSessionEntity(model);

      expect(session.id, 's1');
      expect(session.title, 'Morning Yoga');
      expect(session.startTime, '08:00');
      expect(session.endTime, '09:00');
      expect(session.dayOfWeek, 1);
      expect(session.capacity, 20);
      expect(session.enrolled, 12);
      expect(session.imageUrl, 'https://example.com/img.jpg');
      expect(session.isFull, isFalse);
      expect(session.remainingSpots, 8);
    });

    test('handles session with defaults for null fields', () {
      final model = CourseSessionModel(id: 's2');

      final session = CourseMapper.toSessionEntity(model);

      expect(session.title, '');
      expect(session.startTime, '');
      expect(session.endTime, '');
      expect(session.capacity, 0);
      expect(session.enrolled, 0);
    });
  });
}
