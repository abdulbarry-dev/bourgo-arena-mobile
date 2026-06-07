import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/subscription_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';

/// Laravel API implementation of [SubscriptionRepository].
class ApiSubscriptionRepository implements SubscriptionRepository {
  final ApiClient _apiClient;

  ApiSubscriptionRepository(this._apiClient);

  @override
  Future<Result<Subscription?, Failure>> getActiveSubscription() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success(null));
    }
    return executeApiCall(() async {
      final response = await _apiClient.get('/member/subscription');
      if (response == null) {
        return const Success(null);
      }

      final responseMap = response as Map<String, dynamic>;

      // Handle the case where the API returns { "success": true, "message": "...", "data": null }
      // ApiClient returns the raw body when data is null.
      if (responseMap.containsKey('data') && responseMap['data'] == null) {
        return const Success(null);
      }

      // If we got the whole body but there is a data object, extract it
      // (This is a safeguard in case ApiClient didn't extract it for some reason)
      var dataToParse = responseMap;
      if (responseMap.containsKey('data')) {
        final dataField = responseMap['data'];
        if (dataField == null ||
            (dataField is List && dataField.isEmpty) ||
            (dataField is Map && dataField.isEmpty)) {
          return const Success(null);
        }
        if (dataField is Map<String, dynamic>) {
          dataToParse = dataField;
        }
      }

      // Handle edge case where id is null, empty string, or zero (also indicates no subscription)
      final id = dataToParse['id'];
      if (id == null || id.toString().trim().isEmpty || id.toString() == '0') {
        return const Success(null);
      }

      final model = SubscriptionModel.fromJson(dataToParse);
      return Success(SubscriptionMapper.toEntity(model));
    });
  }

  @override
  Future<Result<void, Failure>> subscribeToPlan(String planId) {
    return executeApiCall(() async {
      await _apiClient.post('/subscriptions', {'plan_id': planId});
      return Result.success(null);
    });
  }
}
