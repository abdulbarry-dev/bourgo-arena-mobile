import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';

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

  /// Removes a child profile by its [id].
  Future<Result<void, Failure>> removeChild(String id);
}
