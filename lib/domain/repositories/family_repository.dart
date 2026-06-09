import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member_profile.dart';

/// Interface for family-related data operations.
abstract interface class FamilyRepository {
  /// Retrieves all children linked to the current parent account.
  Future<Result<List<ChildProfile>, Failure>> getChildren();

  /// Adds a new child profile to the family.
  Future<Result<ChildProfile, Failure>> addChild({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
  });

  /// Updates an existing child profile.
  Future<Result<ChildProfile, Failure>> updateChild({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
  });

  /// Removes a child profile by its [id].
  Future<Result<void, Failure>> removeChild(String id);

  /// Retrieves all adult family members linked to the current member.
  Future<Result<List<FamilyMemberProfile>, Failure>> getFamilyMembers();

  /// Adds a new adult family member.
  Future<Result<FamilyMemberProfile, Failure>> addFamilyMember({
    required String name,
    required String relation,
    required DateTime birthDate,
  });

  /// Updates an existing adult family member.
  Future<Result<FamilyMemberProfile, Failure>> updateFamilyMember({
    required String id,
    required String name,
    required String relation,
    required DateTime birthDate,
  });

  /// Removes an adult family member by its [id].
  Future<Result<void, Failure>> removeFamilyMember(String id);

  /// Disables the family account feature for the current user.
  Future<Result<void, Failure>> disableFamilyFeature();

  /// Enables the family account feature for the current user.
  Future<Result<void, Failure>> enableFamilyFeature();
}
