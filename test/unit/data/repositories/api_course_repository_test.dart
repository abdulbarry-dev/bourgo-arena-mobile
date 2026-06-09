import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_course_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ApiCourseRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = ApiCourseRepository(mockApiClient);
  });

  group('ApiCourseRepository', () {
    test('getCourseDetails returns course details on 200', () async {
      when(
        () => mockApiClient.get('/courses/c1'),
      ).thenAnswer((_) async => {'data': testCourseJson()});

      final result = await repository.getCourseDetails('c1');

      expect((result as Success<Course, Failure>).data.id, 'course-1');
    });

    test('getCourseSessions returns sessions list on 200', () async {
      final tSessions = [
        {'id': 's1', 'date': '2026-06-04'},
      ];
      when(
        () => mockApiClient.get('/courses/c1/sessions'),
      ).thenAnswer((_) async => tSessions);

      final result = await repository.getCourseSessions('c1');

      expect(result, isA<Success<List<dynamic>, Failure>>());
      expect((result as Success<List<dynamic>, Failure>).data.length, 1);
    });

    test('getCourses returns list of courses', () async {
      // Arrange
      final jsonResponse = [
        {
          'id': 'c1',
          'title': 'Yoga',
          'instructor': 'Sarah',
          'start_time': '10:00:00',
          'end_time': '11:00:00',
          'day_of_week': 1,
          'category': 'Wellness',
          'capacity': 20,
          'enrolled': 10,
          'icon': 'yoga_icon',
        },
      ];
      when(
        () => mockApiClient.get(
          '/courses',
          fullResponse: any(named: 'fullResponse'),
        ),
      ).thenAnswer((_) async => {'data': jsonResponse});

      // Act
      final result = await repository.getCourses();

      // Assert
      check(result).isA<Success>();
      final courses = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(courses.length).equals(1);
      check(courses.first.name).equals('Yoga');

      verify(
        () => mockApiClient.get(
          '/courses',
          fullResponse: any(named: 'fullResponse'),
        ),
      ).called(1);
    });

    test('getCourseDetails returns course details', () async {
      // Arrange
      final jsonResponse = {
        'data': {
          'id': 'c1',
          'title': 'Yoga',
          'instructor': 'Sarah',
          'start_time': '10:00:00',
          'end_time': '11:00:00',
          'day_of_week': 1,
          'category': 'Wellness',
          'capacity': 20,
          'enrolled': 10,
          'icon': 'yoga_icon',
        },
      };
      when(
        () => mockApiClient.get(any()),
      ).thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.getCourseDetails('c1');

      // Assert
      check(result).isA<Success>();
      final course = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(course.id).equals('c1');

      verify(() => mockApiClient.get('/courses/c1')).called(1);
    });

    test('getCourseSessions returns sessions list', () async {
      // Arrange
      final jsonResponse = [
        {'id': 's1', 'date': '2026-06-04'},
      ];
      when(
        () => mockApiClient.get(any()),
      ).thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.getCourseSessions('c1');

      // Assert
      check(result).isA<Success>();
      final sessions = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(sessions.length).equals(1);

      verify(() => mockApiClient.get('/courses/c1/sessions')).called(1);
    });

    test('getSessionBooking returns booking status on 200', () async {
      final tBooking = {
        'data': {
          'id': '300',
          'session_id': '101',
          'status': 'booked',
          'booked_at': '2026-06-10T08:00:00.000000Z',
        },
      };
      when(
        () => mockApiClient.get('/courses/c1/sessions/s1/booking'),
      ).thenAnswer((_) async => tBooking);

      final result = await repository.getSessionBooking('c1', 's1');

      check(result).isA<Success>();
      final booking = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(booking.id).equals('300');
      check(booking.status).equals('booked');
    });

    test('getCourses returns failure on exception', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getCourses();

      // Assert
      check(result).isA<FailureResult>();
    });
  });
}
