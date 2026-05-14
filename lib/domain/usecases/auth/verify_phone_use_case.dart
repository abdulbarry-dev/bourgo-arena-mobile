import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for verifying a user's phone number via OTP.
class VerifyPhoneUseCase {
  final AuthRepository _repository;

  const VerifyPhoneUseCase(this._repository);

  /// Executes the verify phone operation.
  Future<Result<bool, Failure>> call(String phone, String otp) async {
    return _repository.verifyPhone(phone, otp);
  }
}
