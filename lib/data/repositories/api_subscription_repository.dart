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
  Future<Result<List<Subscription>, Failure>> getActiveSubscriptions() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response = await _apiClient.get('/member/subscription', fullResponse: true);

      final data =
          (response as Map<String, dynamic>)['data'] as List<dynamic>? ?? [];
      final subscriptions = data.map((json) {
        return SubscriptionMapper.toEntity(
          SubscriptionModel.fromJson(json as Map<String, dynamic>),
        );
      }).toList();

      return Result.success(subscriptions);
    });
  }

  @override
  Future<Result<List<Subscription>, Failure>> getSubscriptionHistory() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response = await _apiClient.get('/member/subscriptions/history', fullResponse: true);

      final data =
          (response as Map<String, dynamic>)['data'] as List<dynamic>? ?? [];
      final subscriptions = data.map((json) {
        return SubscriptionMapper.toEntity(
          SubscriptionModel.fromJson(json as Map<String, dynamic>),
        );
      }).toList();

      return Result.success(subscriptions);
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
      await _apiClient.delete('/subscriptions/$subscriptionId');
      return Result.success(null);
    });
  }
}
