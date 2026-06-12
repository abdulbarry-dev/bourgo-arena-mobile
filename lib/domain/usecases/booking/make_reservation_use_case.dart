import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation_with_payment.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Use case for creating a new activity reservation.
class MakeReservationUseCase {
  final ReservationRepository _repository;

  const MakeReservationUseCase(this._repository);

  /// Executes the operation to create a reservation.
  /// Returns the reservation along with optional deposit payment info.
  /// [paymentMethod] can be 'konnect' or 'loyalty'.
  Future<Result<ReservationWithPayment, Failure>> call(
    Reservation reservation, {
    String? paymentMethod,
  }) async {
    return _repository.makeReservation(
      reservation,
      paymentMethod: paymentMethod,
    );
  }
}
