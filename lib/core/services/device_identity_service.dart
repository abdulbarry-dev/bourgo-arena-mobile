import 'package:bourgo_arena_mobile/core/utils/device_identity_provider.dart';
import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';

class DeviceIdentityService {
  final DeviceIdentityProvider _provider;
  final DeviceIdentityStorage _storage;
  final DeviceRegistrationRepository _registrationRepo;
  final ApiClient _apiClient;

  DeviceIdentityService(
    this._provider,
    this._storage,
    this._registrationRepo,
    this._apiClient,
  );

  Future<void> initialize() async {
    var deviceId = _storage.getDeviceId();
    if (deviceId == null) {
      deviceId = _provider.generateDeviceId();
      await _storage.saveDeviceId(deviceId);
    }

    final existingToken = _storage.getRegistrationToken();
    if (existingToken == null) {
      await _registerDevice(deviceId);
    } else if (_storage.needsTokenRefresh()) {
      await _refreshDeviceToken();
    }

    final token = _storage.getRegistrationToken();
    if (token != null) {
      _apiClient.setDeviceToken(token);
    }
  }

  Future<void> _registerDevice(String deviceId) async {
    try {
      final appVersion = await _provider.getAppVersion();
      final platform = _provider.getPlatform();
      final fingerprint = await _provider.getDeviceFingerprint();

      final result = await _registrationRepo.register(
        deviceId: deviceId,
        platform: platform,
        appVersion: appVersion,
        fingerprint: fingerprint,
      );

      result.when(
        success: (data) {
          _storage.saveRegistrationToken(data.token);
          _storage.saveTokenExpiresAt(data.expiresAt);
        },
        failure: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _refreshDeviceToken() async {
    try {
      final result = await _registrationRepo.refresh();

      result.when(
        success: (data) {
          _storage.saveRegistrationToken(data.token);
          _storage.saveTokenExpiresAt(data.expiresAt);
        },
        failure: (_) {
          _storage.clearRegistrationData();
        },
      );
    } catch (_) {
      _storage.clearRegistrationData();
    }
  }
}
