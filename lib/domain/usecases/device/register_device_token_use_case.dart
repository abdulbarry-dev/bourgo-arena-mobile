import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_repository.dart';

/// Use case to register the device push notification token with the backend.
class RegisterDeviceTokenUseCase {
  final DeviceRepository _repository;

  RegisterDeviceTokenUseCase(this._repository);

  Future<Result<void, Failure>> execute(String token, String? platform) {
    return _repository.registerDeviceToken(token, platform);
  }
}
