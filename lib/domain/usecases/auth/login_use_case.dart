import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// Use case for authenticating a user with email and password.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  /// Executes the login operation.
  Future<Result<User, Failure>> call(String email, String password) async {
    return _repository.login(email, password);
  }
}
