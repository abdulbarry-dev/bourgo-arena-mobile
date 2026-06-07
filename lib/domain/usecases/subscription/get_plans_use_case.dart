import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/subscription_repository.dart';

class GetPlansUseCase {
  final SubscriptionRepository repository;

  GetPlansUseCase(this.repository);

  Future<Result<void, Failure>> call() async {
    return const Success(null);
  }
}
