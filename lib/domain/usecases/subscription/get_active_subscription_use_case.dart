import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';

/// Use case to retrieve the authenticated member's active subscription.
class GetActiveSubscriptionUseCase {
  final SubscriptionRepository _repository;

  GetActiveSubscriptionUseCase(this._repository);

  Future<Result<Subscription?, Failure>> execute() {
    return _repository.getActiveSubscription();
  }
}
