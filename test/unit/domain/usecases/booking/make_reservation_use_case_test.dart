import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation_with_payment.dart';
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
    test('returns ReservationWithPayment on success', () async {
      final reservation = testReservation();
      final rwp = ReservationWithPayment(reservation: reservation);
      when(
        () => repository.makeReservation(reservation),
      ).thenAnswer((_) async => Success<ReservationWithPayment, Failure>(rwp));

      final result = await useCase(reservation);

      expect(result, isA<Success<ReservationWithPayment, Failure>>());
      final data = (result as Success<ReservationWithPayment, Failure>).data;
      expect(data.reservation, same(reservation));
      verify(() => repository.makeReservation(reservation)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns ReservationWithPayment with payment on success', () async {
      final reservation = testReservation();
      final rwp = ReservationWithPayment(
        reservation: reservation,
        payment: {
          'payment_url': 'https://gateway.com/pay',
          'id': 256,
          'payment_reference': 'ref_abc',
        },
      );
      when(
        () => repository.makeReservation(reservation),
      ).thenAnswer((_) async => Success<ReservationWithPayment, Failure>(rwp));

      final result = await useCase(reservation);

      expect(result, isA<Success<ReservationWithPayment, Failure>>());
      final data = (result as Success<ReservationWithPayment, Failure>).data;
      expect(data.requiresDeposit, isTrue);
      expect(data.paymentUrl, 'https://gateway.com/pay');
      verify(() => repository.makeReservation(reservation)).called(1);
    });

    test('propagates repository failures unchanged', () async {
      final reservation = testReservation();
      const failure = ValidationFailure(
        AppErrorCode.validationFailed,
        'reservation invalid',
      );

      when(() => repository.makeReservation(reservation)).thenAnswer(
        (_) async =>
            const FailureResult<ReservationWithPayment, Failure>(failure),
      );

      final result = await useCase(reservation);

      expect(result, isA<FailureResult<ReservationWithPayment, Failure>>());
      expect(
        (result as FailureResult<ReservationWithPayment, Failure>).failure,
        same(failure),
      );
      verify(() => repository.makeReservation(reservation)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
