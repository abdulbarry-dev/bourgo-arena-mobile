import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class GetChildScheduleUseCase {
  final FamilyRepository _repository;

  GetChildScheduleUseCase(this._repository);

  Future<Result<List<ScheduleItem>, Failure>> call({
    required String childId,
    String? from,
    String? to,
  }) {
    return _repository.getChildSchedule(childId: childId, from: from, to: to);
  }
}
