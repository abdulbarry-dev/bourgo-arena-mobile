import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';

/// Loads selectable family members for planning/booking.
class GetFamilyMembersUseCase {
  final UserRepository _userRepository;
  final FamilyRepository _familyRepository;

  const GetFamilyMembersUseCase(this._userRepository, this._familyRepository);

  Future<Result<List<FamilyMember>, Failure>> call() async {
    final userResult = await _userRepository.getUserProfile();
    return userResult.when(
      success: (user) async {
        final members = <FamilyMember>[
          FamilyMember(
            id: user.id,
            name: user.name,
            avatarUrl: user.avatarUrl,
            isPrimary: true,
          ),
        ];

        if (!user.isParentAccount) {
          return Result.success(members);
        }

        final childrenResult = await _familyRepository.getChildren();
        return childrenResult.when(
          success: (children) {
            members.addAll(
              children.map(
                (c) => FamilyMember(
                  id: c.id,
                  name: c.name,
                  avatarUrl: c.avatarUrl,
                  isPrimary: false,
                ),
              ),
            );
            return Result.success(members);
          },
          failure: (failure) => Result.failure(failure),
        );
      },
      failure: (failure) async => Result.failure(failure),
    );
  }
}
