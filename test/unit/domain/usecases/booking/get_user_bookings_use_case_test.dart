import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late GetUserBookingsUseCase useCase;

  setUp(() {
    registerFallbackValue(testReservation());
    repository = MockReservationRepository();
    useCase = GetUserBookingsUseCase(repository);
  });

  group('GetUserBookingsUseCase', () {
    test('returns reservations on success', () async {
      final reservations = <Reservation>[testReservation()];
      when(() => repository.getReservations()).thenAnswer(
        (_) async => Success<List<Reservation>, Failure>(reservations),
      );

      final result = await useCase();

      expect(result, isA<Success<List<Reservation>, Failure>>());
      expect(
        (result as Success<List<Reservation>, Failure>).data,
        same(reservations),
      );
      verify(() => repository.getReservations()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure(
        AppErrorCode.serverError,
        'bookings unavailable',
      );

      when(() => repository.getReservations()).thenAnswer(
        (_) async => const FailureResult<List<Reservation>, Failure>(failure),
      );

      final result = await useCase();

      expect(result, isA<FailureResult<List<Reservation>, Failure>>());
      expect(
        (result as FailureResult<List<Reservation>, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getReservations()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns empty reservation lists unchanged', () async {
      when(
        () => repository.getReservations(),
      ).thenAnswer((_) async => const Success<List<Reservation>, Failure>([]));

      final result = await useCase();

      expect(result, isA<Success<List<Reservation>, Failure>>());
      expect((result as Success<List<Reservation>, Failure>).data, isEmpty);
      verify(() => repository.getReservations()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
