import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';

class CancelSubscriptionUseCase {
  final SubscriptionRepository repository;

  CancelSubscriptionUseCase(this.repository);

  Future<Result<void, Failure>> execute(String subscriptionId) {
    return repository.cancelSubscription(subscriptionId);
  }
}
