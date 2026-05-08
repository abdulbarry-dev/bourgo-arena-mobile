import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Interface for user-related data operations.
abstract interface class UserRepository {
  /// Retrieves the current user profile.
  Future<Result<User, Failure>> getUserProfile();

  /// Updates the user profile with the given [user] data.
  Future<Result<User, Failure>> updateUserProfile(User user);
}
