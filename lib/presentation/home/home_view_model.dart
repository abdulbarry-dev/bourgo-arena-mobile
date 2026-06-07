import "package:flutter/material.dart";
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/home/models/unified_offering.dart';
import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'dart:developer' as developer;

/// ViewModel for the Home screen.
class HomeViewModel extends BaseViewModel {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetCoursesUseCase _getCoursesUseCase;
  final GetServicesUseCase _getServicesUseCase;
  final GetEventsUseCase _getEventsUseCase;

  bool _isDisposed = false;

  HomeViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetCoursesUseCase getCoursesUseCase,
    required GetServicesUseCase getServicesUseCase,
    required GetEventsUseCase getEventsUseCase,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getCoursesUseCase = getCoursesUseCase,
       _getServicesUseCase = getServicesUseCase,
       _getEventsUseCase = getEventsUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UnifiedOffering> _allOfferings = [];

  OfferingType? _selectedFilterType;
  OfferingType? get selectedFilterType => _selectedFilterType;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<UnifiedOffering> get filteredOfferings {
    var list = _allOfferings;
    if (_selectedFilterType != null) {
      list = list.where((o) => o.type == _selectedFilterType).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((o) => o.title.toLowerCase().contains(query)).toList();
    }
    return list;
  }

  void setFilterType(OfferingType? type) {
    _selectedFilterType = type;
    if (!_isDisposed) notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (!_isDisposed) notifyListeners();
  }

  /// Loads all data required for the home screen concurrently.
  Future<void> loadHomeData() async {
    if (_isDisposed) return;
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _getActivitiesUseCase(),
        _getCoursesUseCase(),
        _getServicesUseCase(),
        _getEventsUseCase(),
      ]);

      final List<UnifiedOffering> newOfferings = [];

      // Activities
      results[0].when(
        success: (data) {
          for (var activity in data as List<Activity>) {
            newOfferings.add(
              UnifiedOffering(
                id: activity.id,
                title: activity.title,
                description: activity.description,
                imageUrl: activity.imageUrl,
                type: OfferingType.activity,
                sourceEntity: activity,
                tags: [activity.category],
              ),
            );
          }
        },
        failure: (_) {},
      );

      // Courses
      results[1].when(
        success: (data) {
          for (var course in data as List<entity.Course>) {
            newOfferings.add(
              UnifiedOffering(
                id: course.id,
                title: course.title,
                description: course.description,
                imageUrl: course.imageUrl,
                type: OfferingType.course,
                sourceEntity: course,
                tags: [course.category],
                timeInfo: course.dayOfWeek != null
                    ? 'Day ${course.dayOfWeek}'
                    : null,
                statusBadge: course.isFull
                    ? 'FULL'
                    : (course.enrolled != null ? 'FILLING FAST' : null),
                statusColor: course.isFull
                    ? Colors.redAccent
                    : Colors.orangeAccent,
              ),
            );
          }
        },
        failure: (_) {},
      );

      // Services
      results[2].when(
        success: (data) {
          for (var service in data as List<Service>) {
            newOfferings.add(
              UnifiedOffering(
                id: service.id.toString(),
                title: service.name,
                description: service.description,
                imageUrl: service.imageUrl,
                type: OfferingType.service,
                sourceEntity: service,
                tags: [],
              ),
            );
          }
        },
        failure: (_) {},
      );

      // Events
      results[3].when(
        success: (data) {
          for (var event in data as List<Event>) {
            newOfferings.add(
              UnifiedOffering(
                id: event.id,
                title: event.name ?? 'Event',
                description: event.description,
                imageUrl: null, // Events don't have images currently
                type: OfferingType.event,
                sourceEntity: event,
                tags: event.format != null ? [event.format!] : [],
                statusBadge: event.status?.toUpperCase(),
                statusColor: Colors.purpleAccent,
              ),
            );
          }
        },
        failure: (_) {},
      );

      _allOfferings = newOfferings;
      // Shuffle to make it look like a unified feed
      _allOfferings.shuffle();
    } catch (e, stack) {
      developer.log('Error loading home data: $e', error: e, stackTrace: stack);
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
