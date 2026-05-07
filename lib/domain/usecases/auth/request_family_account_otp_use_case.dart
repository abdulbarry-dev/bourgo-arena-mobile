import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for requesting an OTP to enable family account mode.
class RequestFamilyAccountOtpUseCase {
  final AuthRepository _repository;

  const RequestFamilyAccountOtpUseCase(this._repository);

  /// Executes the request family account OTP operation.
  Future<Result<void, Failure>> call() async {
    return _repository.requestFamilyAccountOtp();
  }
}
