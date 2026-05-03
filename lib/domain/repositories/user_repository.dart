import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Interface for user-related data operations.
abstract interface class UserRepository {
  /// Retrieves the current user profile.
  Future<User> getUserProfile();

  /// Updates the user profile with the given [user] data.
  Future<User> updateUserProfile(User user);
}
