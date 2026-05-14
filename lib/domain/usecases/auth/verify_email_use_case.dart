import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for verifying a user's email address via OTP.
class VerifyEmailUseCase {
  final AuthRepository _repository;

  const VerifyEmailUseCase(this._repository);

  /// Executes the verify email operation.
  Future<Result<bool, Failure>> call(String email, String otp) async {
    return _repository.verifyEmail(email, otp);
  }
}
