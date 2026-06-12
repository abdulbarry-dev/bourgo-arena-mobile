import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildSubscriptionsUseCase {
  final FamilyRepository _repository;

  GetChildSubscriptionsUseCase(this._repository);

  Future<Result<PaginatedResult<Subscription>, Failure>> call({
    required String childId,
    int page = 1,
    int perPage = 15,
  }) {
    return _repository.getChildSubscriptions(
      childId: childId,
      page: page,
      perPage: perPage,
    );
  }
}
