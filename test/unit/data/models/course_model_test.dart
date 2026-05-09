import 'package:bourgo_arena_mobile/data/models/course_model.dart';
import 'package:test/test.dart';

void main() {
  group('CourseModel', () {
    const defaultModel = CourseModel(
      id: 'course-1',
      title: 'Test Course',
      instructor: 'Coach',
      startTime: '10:00',
      endTime: '11:00',
      dayOfWeek: 1,
      category: 'Test',
      capacity: 10,
      enrolled: 0,
      icon: 'test',
    );

    test('isFull returns true when enrolled equals capacity', () {
      final model = CourseModel(
        id: defaultModel.id,
        title: defaultModel.title,
        instructor: defaultModel.instructor,
        startTime: defaultModel.startTime,
        endTime: defaultModel.endTime,
        dayOfWeek: defaultModel.dayOfWeek,
        category: defaultModel.category,
        capacity: 10,
        enrolled: 10,
        icon: defaultModel.icon,
      );
      expect(model.isFull, isTrue);
    });

    test('isFull returns true when enrolled exceeds capacity', () {
      final model = CourseModel(
        id: defaultModel.id,
        title: defaultModel.title,
        instructor: defaultModel.instructor,
        startTime: defaultModel.startTime,
        endTime: defaultModel.endTime,
        dayOfWeek: defaultModel.dayOfWeek,
        category: defaultModel.category,
        capacity: 10,
        enrolled: 11,
        icon: defaultModel.icon,
      );
      expect(model.isFull, isTrue);
    });

    test('isFull returns false when enrolled is less than capacity', () {
      final model = CourseModel(
        id: defaultModel.id,
        title: defaultModel.title,
        instructor: defaultModel.instructor,
        startTime: defaultModel.startTime,
        endTime: defaultModel.endTime,
        dayOfWeek: defaultModel.dayOfWeek,
        category: defaultModel.category,
        capacity: 10,
        enrolled: 9,
        icon: defaultModel.icon,
      );
      expect(model.isFull, isFalse);
    });

    test('remainingSpots returns difference between capacity and enrolled', () {
      final model = CourseModel(
        id: defaultModel.id,
        title: defaultModel.title,
        instructor: defaultModel.instructor,
        startTime: defaultModel.startTime,
        endTime: defaultModel.endTime,
        dayOfWeek: defaultModel.dayOfWeek,
        category: defaultModel.category,
        capacity: 10,
        enrolled: 3,
        icon: defaultModel.icon,
      );
      expect(model.remainingSpots, 7);
    });

    test('toJson and fromJson should be consistent', () {
      final json = defaultModel.toJson();
      final fromJson = CourseModel.fromJson(json);

      expect(fromJson.id, defaultModel.id);
      expect(fromJson.title, defaultModel.title);
      expect(fromJson.instructor, defaultModel.instructor);
      expect(fromJson.startTime, defaultModel.startTime);
      expect(fromJson.endTime, defaultModel.endTime);
      expect(fromJson.dayOfWeek, defaultModel.dayOfWeek);
      expect(fromJson.category, defaultModel.category);
      expect(fromJson.capacity, defaultModel.capacity);
      expect(fromJson.enrolled, defaultModel.enrolled);
      expect(fromJson.icon, defaultModel.icon);
    });
  });
}
