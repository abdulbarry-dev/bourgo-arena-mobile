import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Use case to remove a child profile from the family.
class RemoveChildUseCase {
  final FamilyRepository _repository;

  RemoveChildUseCase(this._repository);

  Future<Result<void, Failure>> execute(String id) {
    return _repository.removeChild(id);
  }
}
