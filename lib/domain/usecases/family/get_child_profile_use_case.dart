import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildProfileUseCase {
  final FamilyRepository _repository;

  GetChildProfileUseCase(this._repository);

  Future<Result<ChildProfile, Failure>> call(String childId) {
    return _repository.getChildProfile(childId);
  }
}
