import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for verifying an OTP for a given identifier.
class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  /// Executes the verify OTP operation.
  Future<Result<bool, Failure>> call(String identifier, String otp) async {
    return _repository.verifyOtp(identifier, otp);
  }
}
