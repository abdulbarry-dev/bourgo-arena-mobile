import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Interface for user-related data operations.
abstract interface class UserRepository {
  /// Retrieves the current user profile.
  Future<Result<User, Failure>> getUserProfile();

  /// Retrieves the authenticated user's access history.
  Future<Result<List<AccessHistoryEntry>, Failure>> getAccessHistory();

  /// Updates the user profile with the given [user] data.
  Future<Result<User, Failure>> updateUserProfile(User user);
}
