import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildReservationsUseCase {
  final FamilyRepository _repository;

  GetChildReservationsUseCase(this._repository);

  Future<Result<PaginatedResult<Reservation>, Failure>> call({
    required String childId,
    String filter = 'all',
    int perPage = 10,
  }) {
    return _repository.getChildReservations(
      childId: childId,
      filter: filter,
      perPage: perPage,
    );
  }
}
