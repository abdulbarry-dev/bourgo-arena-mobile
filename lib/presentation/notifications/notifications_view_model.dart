import 'dart:developer' as developer;
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Notifications screen.
class NotificationsViewModel extends ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;

  List<entity.Notification>? _notifications;
  bool _isLoading = true;

  /// List of user notifications.
  List<entity.Notification>? get notifications => _notifications;

  /// Whether notifications are currently being loaded.
  bool get isLoading => _isLoading;

  /// Creates a new [NotificationsViewModel] instance.
  NotificationsViewModel({
    required GetNotificationsUseCase getNotificationsUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase {
    loadNotifications();
  }

  /// Loads notifications from the use case.
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final result = await _getNotificationsUseCase();
    result.when(
      success: (data) {
        _notifications = data;
        _isLoading = false;
      },
      failure: (failure) {
        _isLoading = false;
        developer.log('Error loading notifications: ${failure.message}');
      },
    );

    notifyListeners();
  }

  /// Marks all notifications as read.
  Future<void> markAllAsRead() async {
    if (_notifications == null) return;

    // This would typically call a use case to update the backend
    // For now, we just update the local state for demonstration
    final updatedNotifications = _notifications!.map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    _notifications = updatedNotifications;
    notifyListeners();
  }
}
