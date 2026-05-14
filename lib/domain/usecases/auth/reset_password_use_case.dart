import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for resetting a user's password using an OTP.
class ResetPasswordUseCase {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  /// Executes the password reset operation.
  Future<Result<void, Failure>> call({
    required String identifier,
    required String otp,
    required String newPassword,
  }) async {
    return _repository.resetPassword(
      identifier: identifier,
      otp: otp,
      newPassword: newPassword,
    );
  }
}
