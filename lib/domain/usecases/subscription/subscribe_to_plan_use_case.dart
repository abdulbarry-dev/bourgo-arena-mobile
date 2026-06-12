import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';

class SubscribeToPlanUseCase {
  final SubscriptionRepository _repository;

  SubscribeToPlanUseCase(this._repository);

  Future<Result<Subscription, Failure>> call(
    String planId, {
    String? childId,
  }) async {
    return _repository.subscribeToPlan(planId, childId: childId);
  }
}
