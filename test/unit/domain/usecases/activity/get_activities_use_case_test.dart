import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late MockActivityRepository repository;
  late GetActivitiesUseCase useCase;

  setUp(() {
    registerFallbackValue(testActivity());
    registerFallbackValue(testTimeSlot());
    repository = MockActivityRepository();
    useCase = GetActivitiesUseCase(repository);
  });

  group('GetActivitiesUseCase', () {
    test('returns the activity list on success', () async {
      final activities = <Activity>[testActivity()];
      when(
        () => repository.getActivities(),
      ).thenAnswer((_) async => Success<List<Activity>, Failure>(activities));

      final result = await useCase();

      expect(result, isA<Success<List<Activity>, Failure>>());
      expect(
        (result as Success<List<Activity>, Failure>).data,
        same(activities),
      );
      verify(() => repository.getActivities()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure(
        AppErrorCode.serverError,
        'activities unavailable',
      );

      when(() => repository.getActivities()).thenAnswer(
        (_) async => const FailureResult<List<Activity>, Failure>(failure),
      );

      final result = await useCase();

      expect(result, isA<FailureResult<List<Activity>, Failure>>());
      expect(
        (result as FailureResult<List<Activity>, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getActivities()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns empty lists unchanged', () async {
      when(
        () => repository.getActivities(),
      ).thenAnswer((_) async => const Success<List<Activity>, Failure>([]));

      final result = await useCase();

      expect(result, isA<Success<List<Activity>, Failure>>());
      expect((result as Success<List<Activity>, Failure>).data, isEmpty);
      verify(() => repository.getActivities()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
