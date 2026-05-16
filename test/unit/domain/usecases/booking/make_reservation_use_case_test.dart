import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late MakeReservationUseCase useCase;

  setUp(() {
    registerFallbackValue(testReservation());
    repository = MockReservationRepository();
    useCase = MakeReservationUseCase(repository);
  });

  group('MakeReservationUseCase', () {
    test('returns the created reservation on success', () async {
      final reservation = testReservation();
      when(
        () => repository.makeReservation(reservation),
      ).thenAnswer((_) async => Success<Reservation, Failure>(reservation));

      final result = await useCase(reservation);

      expect(result, isA<Success<Reservation, Failure>>());
      expect((result as Success<Reservation, Failure>).data, same(reservation));
      verify(() => repository.makeReservation(reservation)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      final reservation = testReservation();
      const failure = ValidationFailure(
        AppErrorCode.validationFailed,
        'reservation invalid',
      );

      when(() => repository.makeReservation(reservation)).thenAnswer(
        (_) async => const FailureResult<Reservation, Failure>(failure),
      );

      final result = await useCase(reservation);

      expect(result, isA<FailureResult<Reservation, Failure>>());
      expect(
        (result as FailureResult<Reservation, Failure>).failure,
        same(failure),
      );
      verify(() => repository.makeReservation(reservation)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards zero-price reservations unchanged', () async {
      final reservation = testReservation(price: 0.0, qrCode: '');
      when(
        () => repository.makeReservation(reservation),
      ).thenAnswer((_) async => Success<Reservation, Failure>(reservation));

      final result = await useCase(reservation);

      expect(result, isA<Success<Reservation, Failure>>());
      expect((result as Success<Reservation, Failure>).data.price, 0.0);
      verify(() => repository.makeReservation(reservation)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
