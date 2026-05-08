import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';

/// Interface for booking reservation operations.
abstract interface class ReservationRepository {
  /// Retrieves a list of all reservations for the current user.
  Future<Result<List<Reservation>, Failure>> getReservations();

  /// Creates a new [reservation].
  Future<Result<Reservation, Failure>> makeReservation(Reservation reservation);

  /// Cancels an existing reservation by its [id].
  Future<Result<void, Failure>> cancelReservation(String id);
}
