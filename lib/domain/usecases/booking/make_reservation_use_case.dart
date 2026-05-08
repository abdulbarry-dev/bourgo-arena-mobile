import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Use case for creating a new activity reservation.
class MakeReservationUseCase {
  final ReservationRepository _repository;

  const MakeReservationUseCase(this._repository);

  /// Executes the operation to create a reservation.
  Future<Result<Reservation, Failure>> call(Reservation reservation) async {
    return _repository.makeReservation(reservation);
  }
}
