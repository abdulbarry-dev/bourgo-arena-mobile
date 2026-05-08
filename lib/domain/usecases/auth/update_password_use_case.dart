import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for updating the user's password.
class UpdatePasswordUseCase {
  final AuthRepository _repository;

  const UpdatePasswordUseCase(this._repository);

  /// Executes the operation to update the user's password.
  Future<Result<void, Failure>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
