import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation_with_payment.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';

/// Interface for booking reservation operations.
abstract interface class ReservationRepository {
  /// Retrieves a list of all reservations for the current user.
  Future<Result<List<Reservation>, Failure>> getReservations();

  /// Retrieves ongoing/future confirmed reservations.
  Future<Result<List<Reservation>, Failure>> getOngoingReservations({
    int page = 1,
    int perPage = 20,
  });

  /// Retrieves past/completed/cancelled reservation history.
  Future<Result<List<Reservation>, Failure>> getReservationHistory({
    int page = 1,
    int perPage = 20,
  });

  /// Creates a new reservation via POST /reservations.
  /// Returns the created reservation along with optional deposit payment info.
  Future<Result<ReservationWithPayment, Failure>> makeReservation(
    Reservation reservation,
  );

  /// Cancels an existing reservation by its [id].
  Future<Result<void, Failure>> cancelReservation(String id);

  /// Initiates a payment for an existing reservation.
  /// [reservationId] the reservation to pay for.
  /// [amount] optional amount in TND (defaults to full reservation price).
  Future<Result<Map<String, dynamic>, Failure>> initiatePayment(
    String reservationId, {
    double? amount,
  });

  /// Verifies the payment status for a reservation.
  /// [paymentId] is required as a query parameter.
  Future<Result<String, Failure>> verifyPayment(
    String reservationId,
    String paymentId,
  );

  /// Retrieves available time slots across activities for a given [date].
  Future<Result<List<TimeSlot>, Failure>> getReservationSlots(String date);
}
