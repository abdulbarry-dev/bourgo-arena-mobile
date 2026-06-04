import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_course_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiCourseRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ApiCourseRepository(apiClient);
  });

  group('ApiCourseRepository', () {
    test('returns Success on 200 with mapped courses', () async {
      when(
        () => apiClient.get('/courses'),
      ).thenAnswer((_) async => [testCourseJson()]);

      final result = await repository.getCourses();

      expect(result, isA<Success<List<Course>, Failure>>());
      expect((result as Success<List<Course>, Failure>).data, hasLength(1));
      expect(result.data.first.title, 'CrossFit Beginners');
    });

    test('returns Failure(AuthFailure) on 401', () async {
      when(
        () => apiClient.get('/courses'),
      ).thenThrow(const AuthException('API Error: 401 unauthorized'));

      final result = await repository.getCourses();

      expect(result, isA<FailureResult<List<Course>, Failure>>());
      expect(
        (result as FailureResult<List<Course>, Failure>).failure,
        isA<AuthFailure>(),
      );
    });

    test('returns Failure(NetworkFailure) on network error', () async {
      when(
        () => apiClient.get('/courses'),
      ).thenThrow(const NetworkException('offline'));

      final result = await repository.getCourses();

      expect(result, isA<FailureResult<List<Course>, Failure>>());
      expect(
        (result as FailureResult<List<Course>, Failure>).failure,
        isA<NetworkFailure>(),
      );
    });

    test('returns Failure(ServerFailure) on 500 error', () async {
      when(
        () => apiClient.get('/courses'),
      ).thenThrow(const ServerException('API Error: 500 server error'));

      final result = await repository.getCourses();

      expect(result, isA<FailureResult<List<Course>, Failure>>());
      expect(
        (result as FailureResult<List<Course>, Failure>).failure,
        isA<ServerFailure>(),
      );
    });
    test('getCourseDetails returns course details on 200', () async {
      when(
        () => apiClient.get('/courses/c1'),
      ).thenAnswer((_) async => {'data': testCourseJson()});

      final result = await repository.getCourseDetails('c1');

      expect((result as Success<Course, Failure>).data.id, 'course-1');
    });

    test('getCourseSessions returns sessions list on 200', () async {
      final tSessions = [{'id': 's1', 'date': '2026-06-04'}];
      when(
        () => apiClient.get('/courses/c1/sessions'),
      ).thenAnswer((_) async => tSessions);

      final result = await repository.getCourseSessions('c1');

      expect(result, isA<Success<List<dynamic>, Failure>>());
      expect((result as Success<List<dynamic>, Failure>).data.length, 1);
    });
  });
}
