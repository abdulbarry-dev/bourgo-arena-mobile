import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/device_registration_data.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';

class ApiDeviceRegistrationRepository implements DeviceRegistrationRepository {
  final ApiClient _apiClient;

  ApiDeviceRegistrationRepository(this._apiClient);

  @override
  Future<Result<DeviceRegistrationData, Failure>> register({
    required String deviceId,
    required String platform,
    required String appVersion,
    Map<String, dynamic>? fingerprint,
    String? integrityToken,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post(
                '/device/register',
                {
                  'device_id': deviceId,
                  'platform': platform,
                  'app_version': appVersion,
                  if (fingerprint != null) 'device_fingerprint': fingerprint,
                  'integrity_token': integrityToken ?? '',
                },
                includeAuth: false,
                fullResponse: true,
              )
              as Map<String, dynamic>;

      final data = response['data'] as Map<String, dynamic>;
      return Success(
        DeviceRegistrationData(
          token: data['token'] as String,
          expiresAt: DateTime.parse(data['expires_at'] as String),
        ),
      );
    });
  }

  @override
  Future<Result<DeviceRefreshData, Failure>> refresh() {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/device/refresh', {}, fullResponse: true)
              as Map<String, dynamic>;

      final data = response['data'] as Map<String, dynamic>;
      return Success(
        DeviceRefreshData(
          token: data['token'] as String,
          expiresAt: DateTime.parse(data['expires_at'] as String),
        ),
      );
    });
  }

  @override
  Future<Result<void, Failure>> link(String deviceId) {
    return executeApiCall(() async {
      await _apiClient.post('/device/link', {'device_id': deviceId});
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> logout(String deviceId) {
    return executeApiCall(() async {
      await _apiClient.post('/device/logout', {'device_id': deviceId});
      return const Success(null);
    });
  }
}
