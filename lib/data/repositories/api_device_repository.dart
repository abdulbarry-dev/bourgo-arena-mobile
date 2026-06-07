import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_repository.dart';

/// Laravel API implementation of [DeviceRepository].
class ApiDeviceRepository implements DeviceRepository {
  final ApiClient _apiClient;

  ApiDeviceRepository(this._apiClient);

  @override
  Future<Result<void, Failure>> registerDeviceToken(
    String token,
    String? platform,
  ) {
    return executeApiCall(() async {
      final payload = {'token': token};
      if (platform != null && platform.isNotEmpty) {
        payload['device_type'] = platform;
      }
      await _apiClient.post('/device-token', payload);
      return const Success(null);
    });
  }
}
