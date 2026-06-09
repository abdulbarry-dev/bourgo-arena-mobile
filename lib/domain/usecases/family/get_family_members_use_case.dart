import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Loads selectable family members for planning/booking.
class GetFamilyMembersUseCase {
  final FamilyRepository _familyRepository;

  const GetFamilyMembersUseCase(this._familyRepository);

  Future<Result<List<FamilyMember>, Failure>> call() async {
    final result = await _familyRepository.getFamilyMembers();
    return result.when(
      success: (profiles) {
        final members = profiles
            .map(
              (p) => FamilyMember(
                id: p.id,
                name: p.name,
                avatarUrl: p.avatarUrl,
                isPrimary: p.relation == 'self',
              ),
            )
            .toList();
        return Result.success(members);
      },
      failure: (failure) => Result.failure(failure),
    );
  }
}
