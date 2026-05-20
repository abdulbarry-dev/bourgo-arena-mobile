import 'dart:developer' as developer;
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/mark_notifications_read_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Notifications screen.

class NotificationsViewModel extends ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationsReadUseCase _markNotificationsReadUseCase;
  bool _isDisposed = false;

  List<entity.Notification> _notifications = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  /// List of user notifications.
  List<entity.Notification> get notifications => _notifications;

  /// Whether notifications are currently being loaded for the first time.
  bool get isLoading => _isLoading;

  /// Whether more notifications are currently being loaded.
  bool get isLoadingMore => _isLoadingMore;

  /// Whether there are more notifications to load.
  bool get hasMore => _hasMore;

  /// Creates a new [NotificationsViewModel] instance.
  NotificationsViewModel({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationsReadUseCase markNotificationsReadUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _markNotificationsReadUseCase = markNotificationsReadUseCase {
    loadNotifications();
  }

  /// Loads notifications (first page).
  Future<void> loadNotifications() async {
    if (_isDisposed) return;

    _isLoading = true;
    _currentPage = 1;
    _notifications = [];
    if (!_isDisposed) notifyListeners();

    final result = await _getNotificationsUseCase(page: _currentPage);
    if (!_isDisposed) {
      result.when(
        success: (paginated) {
          _notifications = paginated.data;
          _hasMore = paginated.hasMore;
          _isLoading = false;
        },
        failure: (failure) {
          _isLoading = false;
          developer.log('Error loading notifications: ${failure.message}');
        },
      );
      notifyListeners();
    }
  }

  /// Loads more notifications (pagination).
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isDisposed) return;

    _isLoadingMore = true;
    if (!_isDisposed) notifyListeners();

    final result = await _getNotificationsUseCase(page: _currentPage + 1);
    if (!_isDisposed) {
      result.when(
        success: (paginated) {
          _notifications.addAll(paginated.data);
          _currentPage = paginated.currentPage;
          _hasMore = paginated.hasMore;
          _isLoadingMore = false;
        },
        failure: (failure) {
          _isLoadingMore = false;
          developer.log('Error loading more notifications: ${failure.message}');
        },
      );
      notifyListeners();
    }
  }

  /// Marks all notifications as read.
  Future<void> markAllAsRead() async {
    if (_notifications.isEmpty || _isDisposed) return;

    @override
    void dispose() {
      _isDisposed = true;
      super.dispose();
    }

    // Optimistic UI update
    final previousNotifications = List<entity.Notification>.from(
      _notifications,
    );
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();

    final result = await _markNotificationsReadUseCase();
    result.when(
      success: (_) {
        developer.log('All notifications marked as read.');
      },
      failure: (failure) {
        // Rollback on failure
        _notifications = previousNotifications;
        notifyListeners();
        developer.log(
          'Failed to mark notifications as read: ${failure.message}',
        );
      },
    );
  }
}
