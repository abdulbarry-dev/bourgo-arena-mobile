import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class BookChildSessionUseCase {
  final FamilyRepository _repository;

  BookChildSessionUseCase(this._repository);

  Future<Result<ChildBooking, Failure>> call({
    required String childId,
    required String sessionId,
    required String date,
  }) {
    return _repository.bookChildSession(
      childId: childId,
      sessionId: sessionId,
      date: date,
    );
  }
}
