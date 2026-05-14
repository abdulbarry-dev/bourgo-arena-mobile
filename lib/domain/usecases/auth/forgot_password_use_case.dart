import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for requesting a password reset OTP.
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  /// Executes the forgot password operation.
  Future<Result<void, Failure>> call(String identifier) async {
    return _repository.forgotPassword(identifier);
  }
}
