import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildCompletedItemsUseCase {
  final FamilyRepository _repository;

  GetChildCompletedItemsUseCase(this._repository);

  Future<Result<PaginatedResult<CompletedItem>, Failure>> call({
    required String childId,
    int page = 1,
    int perPage = 15,
  }) {
    return _repository.getChildCompletedItems(
      childId: childId,
      page: page,
      perPage: perPage,
    );
  }
}
