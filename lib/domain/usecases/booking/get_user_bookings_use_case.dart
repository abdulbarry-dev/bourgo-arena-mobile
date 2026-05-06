import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Use case for retrieving all bookings for the current user.
class GetUserBookingsUseCase {
  final ReservationRepository _repository;

  const GetUserBookingsUseCase(this._repository);

  /// Executes the operation to fetch user bookings.
  Future<Result<List<Reservation>>> call() async {
    try {
      final reservations = await _repository.getReservations();
      return Success(reservations);
    } catch (e) {
      return Failure('Failed to fetch user bookings', e);
    }
  }
}
