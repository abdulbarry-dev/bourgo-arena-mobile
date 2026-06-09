import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_reservation_slots_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late GetReservationSlotsUseCase useCase;

  setUp(() {
    repository = MockReservationRepository();
    useCase = GetReservationSlotsUseCase(repository);
  });

  test('returns slots for a given date on success', () async {
    final tSlots = [const TimeSlot(id: '1001', time: '09:00', available: true)];
    when(
      () => repository.getReservationSlots(any()),
    ).thenAnswer((_) async => Success(tSlots));

    final result = await useCase('2026-06-15');

    expect(result, isA<Success<List<TimeSlot>, Failure>>());
    expect((result as Success).data, hasLength(1));
    verify(() => repository.getReservationSlots('2026-06-15')).called(1);
  });

  test('propagates repository failures', () async {
    when(() => repository.getReservationSlots(any())).thenAnswer(
      (_) async => FailureResult(
        const ServerFailure(AppErrorCode.serverError, 'Server error'),
      ),
    );

    final result = await useCase('2026-06-15');

    expect(result, isA<FailureResult<List<TimeSlot>, Failure>>());
  });
}
