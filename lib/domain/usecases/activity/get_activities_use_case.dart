import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

/// Use case for retrieving the list of available activities.
class GetActivitiesUseCase {
  final ActivityRepository _repository;

  const GetActivitiesUseCase(this._repository);

  /// Executes the operation to fetch activities.
  Future<Result<List<Activity>>> call() async {
    try {
      final activities = await _repository.getActivities();
      return Success(activities);
    } catch (e) {
      return Failure('Failed to fetch activities', e);
    }
  }
}
