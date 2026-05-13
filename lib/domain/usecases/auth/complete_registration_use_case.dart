import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for completing registration and signing in the user.
class CompleteRegistrationUseCase {
  final AuthRepository _repository;

  const CompleteRegistrationUseCase(this._repository);

  /// Executes the complete registration operation.
  Future<Result<void, Failure>> call(User user, String pin) async {
    return _repository.completeRegistration(user, pin);
  }
}
