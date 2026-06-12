import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/child_booking_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/completed_item_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/course_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/reservation_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/schedule_item_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/subscription_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/child_booking_model.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/completed_item_model.dart';
import 'package:bourgo_arena_mobile/data/models/course_session_model.dart';
import 'package:bourgo_arena_mobile/data/models/family_member_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/reservation_model.dart';
import 'package:bourgo_arena_mobile/data/models/schedule_item_model.dart';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
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
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

class ApiFamilyRepository implements FamilyRepository {
  final ApiClient _apiClient;

  ApiFamilyRepository(this._apiClient);

  @override
  Future<Result<List<ChildProfile>, Failure>> getChildren() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/family/children', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final entities = data
          .map(
            (json) => ChildMapper.toEntity(
              ChildProfileModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<ChildProfile, Failure>> addChild({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
    String? avatarFilePath,
  }) {
    return executeApiCall(() async {
      final birthDateStr = birthDate.toIso8601String().split('T').first;
      final Map<String, dynamic> response;
      if (avatarFilePath != null) {
        response = await _apiClient.uploadMultipart(
              '/family/children',
              fileFieldName: 'avatar',
              filePath: avatarFilePath,
              extraFields: {
                'first_name': firstName,
                'last_name': lastName,
                'birth_date': birthDateStr,
                'gender': gender,
              },
            )
            as Map<String, dynamic>;
      } else {
        response = await _apiClient.post('/family/children', {
              'first_name': firstName,
              'last_name': lastName,
              'birth_date': birthDateStr,
              'gender': gender,
              'avatar_url': avatarUrl,
            })
            as Map<String, dynamic>;
      }

      return Result.success(
        ChildMapper.toEntity(ChildProfileModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<ChildProfile, Failure>> updateChild({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
    String? avatarFilePath,
  }) {
    return executeApiCall(() async {
      final birthDateStr = birthDate.toIso8601String().split('T').first;
      final Map<String, dynamic> response;
      if (avatarFilePath != null) {
        response = await _apiClient.uploadMultipart(
              '/family/children/$id',
              fileFieldName: 'avatar',
              filePath: avatarFilePath,
              extraFields: {
                'first_name': firstName,
                'last_name': lastName,
                'birth_date': birthDateStr,
                'gender': gender,
                '_method': 'PUT',
              },
            )
            as Map<String, dynamic>;
      } else {
        response = await _apiClient.put('/family/children/$id', {
              'first_name': firstName,
              'last_name': lastName,
              'birth_date': birthDateStr,
              'gender': gender,
              'avatar_url': avatarUrl,
            })
            as Map<String, dynamic>;
      }

      return Result.success(
        ChildMapper.toEntity(ChildProfileModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<void, Failure>> removeChild(String id) {
    return executeApiCall(() async {
      await _apiClient.delete('/family/children/$id');
      return Result.success(null);
    });
  }

  @override
  Future<Result<List<FamilyMemberProfile>, Failure>> getFamilyMembers() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/family/members', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final entities = data
          .map(
            (json) => FamilyMemberProfileModel.fromJson(
              json as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<void, Failure>> disableFamilyFeature() {
    return executeApiCall(() async {
      await _apiClient.post('/family/disable-feature', {});
      return Result.success(null);
    });
  }

  @override
  Future<Result<bool, Failure>> enableFamilyFeature() {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/family/enable-feature', {})
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>?;
      return Result.success(data?['is_parent_account'] == true);
    });
  }

  @override
  Future<Result<ChildProfile, Failure>> getChildProfile(String childId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/family/children/$childId/profile')
              as Map<String, dynamic>;
      return Result.success(
        ChildMapper.toEntity(ChildProfileModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<Subscription, Failure>> buyChildSubscription({
    required String childId,
    required String planId,
    String? startsAt,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{'plan_id': planId};
      if (startsAt != null) body['starts_at'] = startsAt;
      final response =
          await _apiClient.post(
                '/family/children/$childId/subscriptions',
                body,
              )
              as Map<String, dynamic>;
      return Result.success(
        SubscriptionMapper.toEntity(SubscriptionModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<PaginatedResult<Subscription>, Failure>> getChildSubscriptions({
    required String childId,
    int page = 1,
    int perPage = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/family/children/$childId/subscriptions',
                fullResponse: true,
                queryParameters: {
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final entities = data
          .map(
            (json) => SubscriptionMapper.toEntity(
              SubscriptionModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(_toPaginated(entities, meta));
    });
  }

  @override
  Future<Result<PaginatedResult<ChildBooking>, Failure>> getChildBookings({
    required String childId,
    String filter = 'all',
    int page = 1,
    int perPage = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/family/children/$childId/bookings',
                fullResponse: true,
                queryParameters: {
                  'filter': filter,
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final entities = data
          .map(
            (json) => ChildBookingMapper.toEntity(
              ChildBookingModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(_toPaginated(entities, meta));
    });
  }

  @override
  Future<Result<PaginatedResult<CourseSession>, Failure>>
      getChildAvailableSessions({
    required String childId,
    int page = 1,
    int perPage = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/family/children/$childId/sessions',
                fullResponse: true,
                queryParameters: {
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final entities = data
          .map(
            (json) => CourseMapper.toSessionEntity(
              CourseSessionModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(_toPaginated(entities, meta));
    });
  }

  @override
  Future<Result<ChildBooking, Failure>> bookChildSession({
    required String childId,
    required String sessionId,
    required String date,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post(
                '/family/children/$childId/sessions/$sessionId/book',
                {'date': date},
              )
              as Map<String, dynamic>;
      return Result.success(
        ChildBookingMapper.toEntity(ChildBookingModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<PaginatedResult<Reservation>, Failure>> getChildReservations({
    required String childId,
    String filter = 'all',
    int page = 1,
    int perPage = 10,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/family/children/$childId/reservations',
                fullResponse: true,
                queryParameters: {
                  'filter': filter,
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final entities = data
          .map(
            (json) => ReservationMapper.toEntity(
              ReservationModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(_toPaginated(entities, meta));
    });
  }

  @override
  Future<Result<List<ScheduleItem>, Failure>> getChildSchedule({
    required String childId,
    String? from,
    String? to,
  }) {
    return executeApiCall(() async {
      final queryParams = <String, dynamic>{};
      if (from != null) queryParams['from'] = from;
      if (to != null) queryParams['to'] = to;
      final response =
          await _apiClient.get(
                '/family/children/$childId/schedule',
                fullResponse: true,
                queryParameters: queryParams.isEmpty ? null : queryParams,
              )
              as Map<String, dynamic>;
      final responseData = response['data'] as Map<String, dynamic>? ?? {};
      final scheduleData = responseData['schedule'] as List<dynamic>? ?? [];
      final entities = scheduleData
          .map(
            (json) => ScheduleItemMapper.toEntity(
              ScheduleItemModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<ChildBooking, Failure>> completeChildBooking({
    required String childId,
    required String bookingId,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post(
                '/family/children/$childId/bookings/$bookingId/complete',
                {},
              )
              as Map<String, dynamic>;
      return Result.success(
        ChildBookingMapper.toEntity(ChildBookingModel.fromJson(response)),
      );
    });
  }

  @override
  Future<Result<PaginatedResult<CompletedItem>, Failure>> getChildCompletedItems({
    required String childId,
    int page = 1,
    int perPage = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/family/children/$childId/completed',
                fullResponse: true,
                queryParameters: {
                  'page': page.toString(),
                  'per_page': perPage.toString(),
                },
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final entities = data
          .map(
            (json) => CompletedItemMapper.toEntity(
              CompletedItemModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(_toPaginated(entities, meta));
    });
  }

  PaginatedResult<T> _toPaginated<T>(
    List<T> items,
    Map<String, dynamic> meta,
  ) {
    return PaginatedResult(
      data: items,
      currentPage: meta['current_page'] as int? ?? 1,
      lastPage: meta['last_page'] as int? ?? 1,
      total: meta['total'] as int? ?? items.length,
      hasMore: (meta['current_page'] as int? ?? 1) <
          (meta['last_page'] as int? ?? 1),
    );
  }
}
