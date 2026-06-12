import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildAvailableSessionsUseCase {
  final FamilyRepository _repository;

  GetChildAvailableSessionsUseCase(this._repository);

  Future<Result<PaginatedResult<CourseSession>, Failure>> call({
    required String childId,
    int page = 1,
    int perPage = 15,
  }) {
    return _repository.getChildAvailableSessions(
      childId: childId,
      page: page,
      perPage: perPage,
    );
  }
}
