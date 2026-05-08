import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// Use case for logging out the current user.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  /// Executes the logout operation.
  Future<Result<void, Failure>> call() async {
    return _repository.logout();
  }
}
