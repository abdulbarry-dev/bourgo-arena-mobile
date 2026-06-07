import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';

class GetOngoingReservationsUseCase {
  final ReservationRepository _repository;

  const GetOngoingReservationsUseCase(this._repository);

  Future<Result<List<Reservation>, Failure>> call() async {
    return _repository.getOngoingReservations();
  }
}
