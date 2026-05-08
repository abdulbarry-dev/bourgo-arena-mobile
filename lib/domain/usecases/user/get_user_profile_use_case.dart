import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';

/// Use case for retrieving the current user's profile.
class GetUserProfileUseCase {
  final UserRepository _repository;

  const GetUserProfileUseCase(this._repository);

  /// Executes the operation to fetch the user profile.
  Future<Result<User, Failure>> call() async {
    return _repository.getUserProfile();
  }
}
