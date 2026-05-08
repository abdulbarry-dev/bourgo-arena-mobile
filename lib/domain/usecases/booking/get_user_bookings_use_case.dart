import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Use case for retrieving all bookings for the current user.
class GetUserBookingsUseCase {
  final ReservationRepository _repository;

  const GetUserBookingsUseCase(this._repository);

  /// Executes the operation to fetch user bookings.
  Future<Result<List<Reservation>, Failure>> call() async {
    return _repository.getReservations();
  }
}
