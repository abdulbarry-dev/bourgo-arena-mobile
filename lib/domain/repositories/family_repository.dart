import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

abstract interface class FamilyRepository {
  Future<Result<List<ChildProfile>, Failure>> getChildren();

  Future<Result<ChildProfile, Failure>> addChild({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
    String? avatarFilePath,
  });

  Future<Result<ChildProfile, Failure>> updateChild({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
    String? avatarFilePath,
  });

  Future<Result<void, Failure>> removeChild(String id);

  Future<Result<List<FamilyMemberProfile>, Failure>> getFamilyMembers();

  Future<Result<void, Failure>> disableFamilyFeature();

  Future<Result<bool, Failure>> enableFamilyFeature();

  // --- Child Family Management Endpoints ---

  /// GET /family/children/{member}/profile
  Future<Result<ChildProfile, Failure>> getChildProfile(String childId);

  /// POST /family/children/{member}/subscriptions
  Future<Result<Subscription, Failure>> buyChildSubscription({
    required String childId,
    required String planId,
    String? startsAt,
  });

  /// GET /family/children/{member}/subscriptions
  Future<Result<PaginatedResult<Subscription>, Failure>> getChildSubscriptions({
    required String childId,
    int page = 1,
    int perPage = 15,
  });

  /// GET /family/children/{member}/bookings
  Future<Result<PaginatedResult<ChildBooking>, Failure>> getChildBookings({
    required String childId,
    String filter = 'all',
    int page = 1,
    int perPage = 15,
  });

  /// GET /family/children/{member}/sessions
  Future<Result<PaginatedResult<CourseSession>, Failure>> getChildAvailableSessions({
    required String childId,
    int page = 1,
    int perPage = 15,
  });

  /// POST /family/children/{member}/sessions/{session}/book
  Future<Result<ChildBooking, Failure>> bookChildSession({
    required String childId,
    required String sessionId,
    required String date,
  });

  /// GET /family/children/{member}/reservations
  Future<Result<PaginatedResult<Reservation>, Failure>> getChildReservations({
    required String childId,
    String filter = 'all',
    int page = 1,
    int perPage = 10,
  });

  /// GET /family/children/{member}/schedule
  Future<Result<List<ScheduleItem>, Failure>> getChildSchedule({
    required String childId,
    String? from,
    String? to,
  });

  /// POST /family/children/{member}/bookings/{booking}/complete
  Future<Result<ChildBooking, Failure>> completeChildBooking({
    required String childId,
    required String bookingId,
  });

  /// GET /family/children/{member}/completed
  Future<Result<PaginatedResult<CompletedItem>, Failure>> getChildCompletedItems({
    required String childId,
    int page = 1,
    int perPage = 15,
  });
}
