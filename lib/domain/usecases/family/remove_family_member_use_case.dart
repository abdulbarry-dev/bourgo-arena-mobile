import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class RemoveFamilyMemberUseCase {
  final FamilyRepository _repository;

  const RemoveFamilyMemberUseCase(this._repository);

  Future<Result<void, Failure>> call(String id) {
    return _repository.removeFamilyMember(id);
  }
}
