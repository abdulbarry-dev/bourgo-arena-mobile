import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

/// Interface for booking reservation operations.
abstract interface class ReservationRepository {
  /// Retrieves a list of all reservations for the current user.
  Future<Result<List<Reservation>, Failure>> getReservations();

  /// Creates a new reservation via POST /reservations.
  /// [activityId], [activitySlotId], and [date] are required by the API.
  Future<Result<Reservation, Failure>> makeReservation(Reservation reservation);

  /// Cancels an existing reservation by its [id].
  Future<Result<void, Failure>> cancelReservation(String id);

  /// Initiates a payment for an existing reservation.
  /// [gateway] must be 'konnect'.
  /// Returns a payment URL and reference to redirect the user.
  Future<Result<Map<String, dynamic>, Failure>> initiatePayment(
    String reservationId,
    String gateway,
  );

  /// Verifies the payment status for a reservation.
  /// [paymentId] is required as a query parameter.
  Future<Result<String, Failure>> verifyPayment(
    String reservationId,
    String paymentId,
  );
}
