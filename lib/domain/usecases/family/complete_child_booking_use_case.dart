import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class CompleteChildBookingUseCase {
  final FamilyRepository _repository;

  CompleteChildBookingUseCase(this._repository);

  Future<Result<ChildBooking, Failure>> call({
    required String childId,
    required String bookingId,
  }) {
    return _repository.completeChildBooking(
      childId: childId,
      bookingId: bookingId,
    );
  }
}
