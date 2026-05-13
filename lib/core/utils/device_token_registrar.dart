import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/device/register_device_token_use_case.dart';

/// Coordinates device token registration when prerequisites are met.
class DeviceTokenRegistrar {
  final SessionRepository _sessionRepository;
  final RegisterDeviceTokenUseCase _registerDeviceTokenUseCase;

  DeviceTokenRegistrar(
    this._sessionRepository,
    this._registerDeviceTokenUseCase,
  );

  /// Attempts to register the stored device token if available.
  Future<void> registerIfPossible({
    bool requireNotificationsEnabled = true,
  }) async {
    if (requireNotificationsEnabled) {
      final notificationResult = await _sessionRepository
          .areNotificationsEnabled();
      final enabled = notificationResult.isSuccess
          ? (notificationResult as Success<bool, dynamic>).data
          : false;
      if (!enabled) {
        return;
      }
    }

    final tokenResult = await _sessionRepository.getDeviceToken();
    final token = tokenResult.isSuccess
        ? (tokenResult as Success<String?, dynamic>).data
        : null;
    if (token == null || token.isEmpty) {
      return;
    }

    final platformResult = await _sessionRepository.getDevicePlatform();
    final platform = platformResult.isSuccess
        ? (platformResult as Success<String?, dynamic>).data
        : null;

    await _registerDeviceTokenUseCase.execute(token, platform);
  }
}
