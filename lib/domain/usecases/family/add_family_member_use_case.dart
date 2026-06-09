import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class AddFamilyMemberUseCase {
  final FamilyRepository _repository;

  const AddFamilyMemberUseCase(this._repository);

  Future<Result<FamilyMemberProfile, Failure>> call({
    required String name,
    required String relation,
    required DateTime birthDate,
  }) {
    return _repository.addFamilyMember(
      name: name,
      relation: relation,
      birthDate: birthDate,
    );
  }
}
