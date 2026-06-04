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
      final model = SubscriptionModel.fromJson(
        response as Map<String, dynamic>,
      );
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

  @override
  Future<Result<void, Failure>> cancelSubscription(String subscriptionId) {
    return executeApiCall(() async {
      await _apiClient.post('/subscriptions/$subscriptionId/cancel', {});
      return Result.success(null);
    });
  }
}
