import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

class GetReservationSlotsUseCase {
  final ReservationRepository _repository;

  const GetReservationSlotsUseCase(this._repository);

  Future<Result<List<TimeSlot>, Failure>> call(String date) {
    return _repository.getReservationSlots(date);
  }
}
