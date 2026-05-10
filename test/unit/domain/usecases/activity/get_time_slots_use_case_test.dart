import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late MockActivityRepository repository;
  late GetTimeSlotsUseCase useCase;

  setUp(() {
    registerFallbackValue(testTimeSlot());
    repository = MockActivityRepository();
    useCase = GetTimeSlotsUseCase(repository);
  });

  group('GetTimeSlotsUseCase', () {
    test('returns the time slot list on success', () async {
      final slots = <TimeSlot>[testTimeSlot()];
      when(
        () => repository.getTimeSlots('activity-1'),
      ).thenAnswer((_) async => Success<List<TimeSlot>, Failure>(slots));

      final result = await useCase('activity-1');

      expect(result, isA<Success<List<TimeSlot>, Failure>>());
      expect((result as Success<List<TimeSlot>, Failure>).data, same(slots));
      verify(() => repository.getTimeSlots('activity-1')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = NotFoundFailure('activity not found');

      when(() => repository.getTimeSlots('activity-1')).thenAnswer(
        (_) async => const FailureResult<List<TimeSlot>, Failure>(failure),
      );

      final result = await useCase('activity-1');

      expect(result, isA<FailureResult<List<TimeSlot>, Failure>>());
      expect(
        (result as FailureResult<List<TimeSlot>, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getTimeSlots('activity-1')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns empty slot lists unchanged', () async {
      when(
        () => repository.getTimeSlots('activity-1'),
      ).thenAnswer((_) async => const Success<List<TimeSlot>, Failure>([]));

      final result = await useCase('activity-1');

      expect(result, isA<Success<List<TimeSlot>, Failure>>());
      expect((result as Success<List<TimeSlot>, Failure>).data, isEmpty);
      verify(() => repository.getTimeSlots('activity-1')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
