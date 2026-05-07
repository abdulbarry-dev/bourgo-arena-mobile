import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for sending an OTP to the given identifier.
class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  /// Executes the send OTP operation.
  Future<Result<void, Failure>> call(String identifier) async {
    return _repository.sendOtp(identifier);
  }
}
