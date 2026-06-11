import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_reservation_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation_with_payment.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiReservationRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    when(() => apiClient.hasToken).thenReturn(true);
    repository = ApiReservationRepository(apiClient);
  });

  group('ApiReservationRepository', () {
    group('getReservations', () {
      final responseEnvelope = {
        'data': [testReservationJson()],
      };

      void setUpSuccessStubs() {
        when(
          () => apiClient.get(
            '/reservations/ongoing',
            fullResponse: true,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => responseEnvelope);
        when(
          () => apiClient.get(
            '/reservations/history',
            fullResponse: true,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => {'data': []});
      }

      test('returns Success on 200 with mapped reservations', () async {
        setUpSuccessStubs();

        final result = await repository.getReservations();

        expect(result, isA<Success<List<Reservation>, Failure>>());
        expect(
          (result as Success<List<Reservation>, Failure>).data,
          hasLength(1),
        );
        expect(result.data.first.activityTitle, 'Football');
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.get(
            '/reservations/ongoing',
            fullResponse: true,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.getReservations();

        expect(result, isA<FailureResult<List<Reservation>, Failure>>());
        expect(
          (result as FailureResult<List<Reservation>, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.get(
            '/reservations/ongoing',
            fullResponse: true,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.getReservations();

        expect(result, isA<FailureResult<List<Reservation>, Failure>>());
        expect(
          (result as FailureResult<List<Reservation>, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.get(
            '/reservations/ongoing',
            fullResponse: true,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.getReservations();

        expect(result, isA<FailureResult<List<Reservation>, Failure>>());
        expect(
          (result as FailureResult<List<Reservation>, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('makeReservation', () {
      test('returns Success on 200 with mapped reservation', () async {
        final reservation = testReservationEntity();
        when(
          () => apiClient.post('/reservations', any()),
        ).thenAnswer((_) async => testReservationJson());

        final result = await repository.makeReservation(reservation);

        expect(result, isA<Success<ReservationWithPayment, Failure>>());
        final data = (result as Success<ReservationWithPayment, Failure>).data;
        expect(data.reservation.id, reservation.id);
        verify(
          () => apiClient.post('/reservations', {
            'activity_id': reservation.activityId,
            'activity_slot_id': reservation.activitySlotId,
            'date': reservation.date,
          }),
        ).called(1);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/reservations', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.makeReservation(
          testReservationEntity(),
        );

        expect(result, isA<FailureResult<ReservationWithPayment, Failure>>());
        expect(
          (result as FailureResult<ReservationWithPayment, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/reservations', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.makeReservation(
          testReservationEntity(),
        );

        expect(result, isA<FailureResult<ReservationWithPayment, Failure>>());
        expect(
          (result as FailureResult<ReservationWithPayment, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/reservations', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.makeReservation(
          testReservationEntity(),
        );

        expect(result, isA<FailureResult<ReservationWithPayment, Failure>>());
        expect(
          (result as FailureResult<ReservationWithPayment, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('cancelReservation', () {
      test('returns Success on 200', () async {
        when(
          () => apiClient.delete('/reservations/reservation-1'),
        ).thenAnswer((_) async {});

        final result = await repository.cancelReservation('reservation-1');

        expect(result, isA<Success<void, Failure>>());
        verify(() => apiClient.delete('/reservations/reservation-1')).called(1);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.delete('/reservations/reservation-1'),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.cancelReservation('reservation-1');

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.delete('/reservations/reservation-1'),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.cancelReservation('reservation-1');

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.delete('/reservations/reservation-1'),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.cancelReservation('reservation-1');

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('getReservationSlots', () {
      test('returns list of TimeSlot on 200', () async {
        final tSlots = [
          {
            'id': 1001,
            'start_time': '09:00',
            'end_time': '10:00',
            'is_available': true,
            'price': 35000,
          },
        ];
        when(
          () => apiClient.get(
            '/reservations/slots',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tSlots);

        final result = await repository.getReservationSlots('2026-06-15');

        expect(result, isA<Success<List<TimeSlot>, Failure>>());
        final data = (result as Success<List<TimeSlot>, Failure>).data;
        expect(data, hasLength(1));
        expect(data.first.startTime, '09:00');
      });

      test('returns Failure on error', () async {
        when(
          () => apiClient.get(
            '/reservations/slots',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.getReservationSlots('2026-06-15');

        expect(result, isA<FailureResult<List<TimeSlot>, Failure>>());
        expect(
          (result as FailureResult<List<TimeSlot>, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });
    });
  });
}
