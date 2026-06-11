import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class BuyChildSubscriptionUseCase {
  final FamilyRepository _repository;

  BuyChildSubscriptionUseCase(this._repository);

  Future<Result<Subscription, Failure>> call({
    required String childId,
    required String planId,
    String? startsAt,
  }) {
    return _repository.buyChildSubscription(
      childId: childId,
      planId: planId,
      startsAt: startsAt,
    );
  }
}
