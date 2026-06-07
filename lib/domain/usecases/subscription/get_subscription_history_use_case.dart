import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';

class GetSubscriptionHistoryUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionHistoryUseCase(this._repository);

  Future<Result<List<Subscription>, Failure>> execute() {
    return _repository.getSubscriptionHistory();
  }
}
