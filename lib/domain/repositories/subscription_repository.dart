import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

/// Repository interface for managing member subscriptions.
abstract class SubscriptionRepository {
  /// Retrieves the current active subscription for the member.
  /// Returns null if no active subscription exists.
  Future<Result<Subscription?, Failure>> getActiveSubscription();
  Future<Result<void, Failure>> subscribeToPlan(String planId);
  Future<Result<void, Failure>> cancelSubscription(String subscriptionId);
}
