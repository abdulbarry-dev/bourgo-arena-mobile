import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/mark_notifications_read_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_view_model.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen displaying a list of user notifications.
class NotificationsScreen extends StatefulWidget {
  final NotificationsViewModel? viewModel;
  const NotificationsScreen({super.key, this.viewModel});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel =
        widget.viewModel ??
        NotificationsViewModel(
          getNotificationsUseCase: locator<GetNotificationsUseCase>(),
          markNotificationsReadUseCase: locator<MarkNotificationsReadUseCase>(),
        );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (widget.viewModel == null) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.notificationsTitle),
            backgroundColor: theme.colorScheme.surface,
            actions: [
              TextButton(
                onPressed: _viewModel.markAllAsRead,
                child: Text(
                  AppLocalizations.of(context)!.notificationsMarkAllRead,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _viewModel.loadNotifications,
            child: _viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _viewModel.notifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    itemCount:
                        _viewModel.notifications.length +
                        (_viewModel.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index < _viewModel.notifications.length) {
                        final notification = _viewModel.notifications[index];
                        return _NotificationItem(notification: notification);
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      title: AppLocalizations.of(context)!.notificationsEmpty,
      message: AppLocalizations.of(context)!.notificationsEmptySubtitle,
      icon: Symbols.notifications_off,
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final entity.Notification notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = _getIcon(notification.type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.transparent
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? theme.colorScheme.outline
              : theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: notification.isRead
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                  : theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
            child: Icon(
              iconData,
              size: 20,
              color: notification.isRead
                  ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                  : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat(
                    'dd MMM, HH:mm',
                    Localizations.localeOf(context).toString(),
                  ).format(notification.timestamp),
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.6,
                    ),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'welcome':
        return Symbols.celebration;
      case 'reservation':
      case 'booking':
        return Symbols.calendar_month;
      case 'alert':
        return Symbols.warning;
      case 'system':
        return Symbols.settings;
      default:
        return Symbols.notifications;
    }
  }
}
