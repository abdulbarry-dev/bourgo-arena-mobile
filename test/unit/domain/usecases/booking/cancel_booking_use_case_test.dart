import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late CancelBookingUseCase useCase;

  setUp(() {
    repository = MockReservationRepository();
    useCase = CancelBookingUseCase(repository);
  });

  group('CancelBookingUseCase', () {
    test('returns success when cancellation succeeds', () async {
      when(
        () => repository.cancelReservation('reservation-1'),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase('reservation-1');

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.cancelReservation('reservation-1')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure(
        AppErrorCode.serverError,
        'cancel rejected',
      );

      when(
        () => repository.cancelReservation('reservation-1'),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase('reservation-1');

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.cancelReservation('reservation-1')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards empty reservation ids unchanged', () async {
      when(
        () => repository.cancelReservation(''),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase('');

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.cancelReservation('')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
