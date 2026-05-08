import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

/// Use case for cancelling an existing booking.
class CancelBookingUseCase {
  final ReservationRepository _repository;

  const CancelBookingUseCase(this._repository);

  /// Executes the cancellation operation.
  Future<Result<void, Failure>> call(String id) async {
    return _repository.cancelReservation(id);
  }
}
