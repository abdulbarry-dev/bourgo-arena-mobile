import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildBookingsUseCase {
  final FamilyRepository _repository;

  GetChildBookingsUseCase(this._repository);

  Future<Result<PaginatedResult<ChildBooking>, Failure>> call({
    required String childId,
    String filter = 'all',
    int perPage = 15,
  }) {
    return _repository.getChildBookings(
      childId: childId,
      filter: filter,
      perPage: perPage,
    );
  }
}
