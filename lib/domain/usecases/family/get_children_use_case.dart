import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Use case to retrieve all children linked to the parent account.
class GetChildrenUseCase {
  final FamilyRepository _repository;

  GetChildrenUseCase(this._repository);

  Future<Result<List<ChildProfile>, Failure>> execute() {
    return _repository.getChildren();
  }
}
