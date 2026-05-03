import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for logging out the current user.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  /// Executes the logout operation.
  Future<Result<void>> call() async {
    try {
      await _repository.logout();
      return const Success(null);
    } catch (e) {
      return Failure('Logout failed', e);
    }
  }
}
