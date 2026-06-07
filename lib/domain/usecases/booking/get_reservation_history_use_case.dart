import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

class GetReservationHistoryUseCase {
  final ReservationRepository _repository;

  const GetReservationHistoryUseCase(this._repository);

  Future<Result<List<Reservation>, Failure>> call() async {
    return _repository.getReservationHistory();
  }
}
