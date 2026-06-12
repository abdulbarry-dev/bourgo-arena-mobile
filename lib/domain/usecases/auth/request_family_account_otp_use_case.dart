import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/otp_delivery_method.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for requesting an OTP to enable family account mode.
class RequestFamilyAccountOtpUseCase {
  final AuthRepository _repository;

  const RequestFamilyAccountOtpUseCase(this._repository);

  /// Executes the request family account OTP operation.
  Future<Result<String, Failure>> call({
    OtpDeliveryMethod? method,
    String? identifier,
  }) async {
    return _repository.requestFamilyAccountOtp(
      method: method,
      identifier: identifier,
    );
  }
}
