import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/service_repository.dart';

class ApiServiceRepository implements ServiceRepository {
  final ApiClient _apiClient;

  ApiServiceRepository(this._apiClient);

  @override
  Future<Result<List<Service>, Failure>> getServices({
    int page = 1,
    int limit = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/services',
                fullResponse: true,
                queryParameters: {
                  'page': page.toString(),
                  'per_page': limit.toString(),
                },
              )
              as Map<String, dynamic>;

      final data = response['data'] as List<dynamic>? ?? [];

      final services = data
          .map((json) => _parseService(json as Map<String, dynamic>))
          .toList();

      return Success(services);
    });
  }

  @override
  Future<Result<Service, Failure>> getServiceDetails(int serviceId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/services/$serviceId', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;

      return Success(_parseService(data));
    });
  }

  Service _parseService(Map<String, dynamic> map) {
    return Service(
      id: map['id'] is int ? map['id'] as int : int.parse(map['id'].toString()),
      name: map['name'] as String,
      imageUrl: map['image_url'] as String?,
      description: map['description'] as String?,
      plansCount: map['plans_count'] as int? ?? 0,
      coursesCount: map['courses_count'] as int? ?? 0,
      eventsCount: map['events_count'] as int? ?? 0,
      activitiesCount: map['activities_count'] as int? ?? 0,
      plans: _parsePlans(map['plans'] as List<dynamic>?),
      courses: _parseCourses(map['courses'] as List<dynamic>?),
      events: _parseEvents(map['events'] as List<dynamic>?),
      activities: _parseActivities(map['activities'] as List<dynamic>?),
    );
  }

  List<Plan> _parsePlans(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return Plan(
        id: m['id'].toString(),
        name: m['name'] as String? ?? '',
        price: (m['price'] as num?)?.toDouble() ?? 0,
        durationDays: m['duration_days'] as int?,
        hasAllCourses: m['has_all_courses'] as bool? ?? false,
      );
    }).toList();
  }

  List<Course> _parseCourses(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return Course(
        id: m['id'].toString(),
        name: m['name'] as String? ?? '',
        description: m['description'] as String?,
        images:
            (m['images'] as List<dynamic>?)
                ?.map((s) => s.toString())
                .toList() ??
            [],
        imageUrl: m['image_url'] as String?,
        status: m['status'] as String?,
      );
    }).toList();
  }

  List<Event> _parseEvents(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return Event(
        id: m['id'].toString(),
        name: m['name'] as String?,
        description: m['description'] as String?,
        format: m['format'] as String?,
        maxParticipants: m['max_participants'] as int?,
        registrationDeadline: m['registration_deadline'] as String?,
        startDate: m['start_date'] as String?,
        endDate: m['end_date'] as String?,
        images:
            (m['images'] as List<dynamic>?)
                ?.map((s) => s.toString())
                .toList() ??
            [],
        imageUrl: m['image_url'] as String?,
        status: m['status'] as String?,
        requiresCheckIn: m['requires_check_in'] as bool? ?? false,
        createdAt: m['created_at'] as String?,
      );
    }).toList();
  }

  List<Activity> _parseActivities(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return Activity(
        id: m['id'].toString(),
        title: m['title'] as String? ?? m['name'] as String? ?? '',
        name: m['name'] as String? ?? '',
        category: m['category'] as String? ?? '',
        basePrice: (m['base_price'] as num?)?.toDouble() ?? 0,
        currency: m['currency'] as String? ?? 'TND',
        imageUrl: m['image_url'] as String? ?? '',
        images:
            (m['images'] as List<dynamic>?)
                ?.map((s) => s.toString())
                .toList() ??
            [],
        icon: m['icon'] as String? ?? '',
        description: m['description'] as String? ?? '',
        features:
            (m['features'] as List<dynamic>?)
                ?.map((s) => s.toString())
                .toList() ??
            [],
        capacity: m['capacity'] as int?,
        rating: (m['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: m['review_count'] as int? ?? 0,
      );
    }).toList();
  }
}
