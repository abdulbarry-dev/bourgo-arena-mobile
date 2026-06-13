import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_completed_items_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_schedule_use_case.dart';
import 'dart:developer' as developer;

enum ChildActivityStatus { upcoming, completed }

class ChildActivityItem {
  final String id;
  final String name;
  final String date;
  final String typeLabel;
  final ChildActivityStatus status;
  final String? timeDisplay;
  final String? completedAt;

  const ChildActivityItem({
    required this.id,
    required this.name,
    required this.date,
    required this.typeLabel,
    required this.status,
    this.timeDisplay,
    this.completedAt,
  });
}

class ChildCompletedViewModel extends BaseViewModel {
  final GetChildCompletedItemsUseCase _getChildCompletedItemsUseCase;
  final GetChildScheduleUseCase _getChildScheduleUseCase;

  List<ChildActivityItem> _items = [];
  bool _isLoading = false;

  ChildCompletedViewModel({
    required GetChildCompletedItemsUseCase getChildCompletedItemsUseCase,
    required GetChildScheduleUseCase getChildScheduleUseCase,
  }) : _getChildCompletedItemsUseCase = getChildCompletedItemsUseCase,
       _getChildScheduleUseCase = getChildScheduleUseCase;

  List<ChildActivityItem> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> load(String childId) async {
    _isLoading = true;
    _items = [];
    notifyListeners();

    try {
      final results = await Future.wait([
        _getChildCompletedItemsUseCase(childId: childId),
        _getChildScheduleUseCase(childId: childId),
      ]);

      final completedResult =
          results[0] as Result<PaginatedResult<CompletedItem>, Failure>;
      final scheduleResult = results[1] as Result<List<ScheduleItem>, Failure>;

      final List<ChildActivityItem> merged = [];

      completedResult.when(
        success: (paginated) {
          for (final item in paginated.data) {
            merged.add(
              ChildActivityItem(
                id: 'completed_${item.id}',
                name: item.name,
                date: item.date,
                typeLabel: item.typeLabel,
                status: ChildActivityStatus.completed,
                completedAt: item.completedAt,
              ),
            );
          }
        },
        failure: (failure) {
          developer.log('Failed to load completed items: ${failure.message}');
        },
      );

      scheduleResult.when(
        success: (scheduleItems) {
          for (final item in scheduleItems) {
            if (!item.isCompleted) {
              merged.add(
                ChildActivityItem(
                  id: 'schedule_${item.id}',
                  name: item.name,
                  date: item.date,
                  typeLabel: item.typeLabel,
                  status: ChildActivityStatus.upcoming,
                  timeDisplay: item.startTime.isNotEmpty
                      ? '${item.startTime}${item.endTime != null ? ' - ${item.endTime}' : ''}'
                      : null,
                ),
              );
            }
          }
        },
        failure: (failure) {
          developer.log('Failed to load schedule: ${failure.message}');
        },
      );

      merged.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.status == ChildActivityStatus.upcoming ? -1 : 1;
      });

      _items = merged;
      clearError();
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child activities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
