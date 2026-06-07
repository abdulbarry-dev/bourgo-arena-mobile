import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

/// Repository interface for managing member subscriptions.
abstract class SubscriptionRepository {
  /// Retrieves all active subscriptions for the member.
  Future<Result<List<Subscription>, Failure>> getActiveSubscriptions();

  /// Retrieves the history of all subscriptions for the member.
  Future<Result<List<Subscription>, Failure>> getSubscriptionHistory();

  Future<Result<void, Failure>> subscribeToPlan(String planId);
  Future<Result<void, Failure>> cancelSubscription(String subscriptionId);
}
