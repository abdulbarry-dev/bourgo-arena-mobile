import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

/// Interface for booking reservation operations.
abstract interface class ReservationRepository {
  /// Retrieves a list of all reservations for the current user.
  Future<List<Reservation>> getReservations();

  /// Creates a new [reservation].
  Future<Reservation> makeReservation(Reservation reservation);

  /// Cancels an existing reservation by its [id].
  Future<void> cancelReservation(String id);
}
