import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// Use case for authenticating a user with email and password.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  /// Executes the login operation.
  Future<Result<AuthSession, Failure>> call(
    String identifier,
    String password,
  ) async {
    return _repository.login(identifier, password);
  }
}
