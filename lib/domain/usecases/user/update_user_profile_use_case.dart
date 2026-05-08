import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';

/// Use case for updating the current user's profile.
class UpdateUserProfileUseCase {
  final UserRepository _repository;

  const UpdateUserProfileUseCase(this._repository);

  /// Executes the operation to update the user profile.
  Future<Result<User, Failure>> call(User user) async {
    return _repository.updateUserProfile(user);
  }
}
