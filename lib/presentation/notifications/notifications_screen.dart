import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
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
import 'package:go_router/go_router.dart';

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

  String _selectedFilter = 'ALL';

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

  List<entity.Notification> _getFilteredNotifications() {
    final all = _viewModel.notifications;
    switch (_selectedFilter) {
      case 'UNREAD':
        return all.where((n) => !n.isRead).toList();
      case 'BOOKINGS':
        return all
            .where((n) => n.type == 'booking' || n.type == 'reservation')
            .toList();
      case 'ALERTS':
        return all.where((n) => n.type == 'alert').toList();
      case 'ALL':
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final filteredList = _getFilteredNotifications();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Symbols.notifications,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  l10n.notificationsTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
            actions: [
              IconButton(
                icon: const Icon(Symbols.done_all),
                tooltip: l10n.notificationsMarkAllRead,
                onPressed: _viewModel.markAllAsRead,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter Chips
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: appColors.bgBorder, width: 1),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'ALL',
                        isSelected: _selectedFilter == 'ALL',
                        onTap: () => setState(() => _selectedFilter = 'ALL'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'UNREAD',
                        isSelected: _selectedFilter == 'UNREAD',
                        onTap: () => setState(() => _selectedFilter = 'UNREAD'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'BOOKINGS',
                        isSelected: _selectedFilter == 'BOOKINGS',
                        onTap: () =>
                            setState(() => _selectedFilter = 'BOOKINGS'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'ALERTS',
                        isSelected: _selectedFilter == 'ALERTS',
                        onTap: () => setState(() => _selectedFilter = 'ALERTS'),
                      ),
                    ],
                  ),
                ),
              ),

              // Notifications List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _viewModel.loadNotifications,
                  child: _viewModel.isLoading && filteredList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : filteredList.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          itemCount:
                              filteredList.length +
                              (_viewModel.hasMore
                                  ? 1
                                  : 1), // +1 for empty state at end
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index < filteredList.length) {
                              final notification = filteredList[index];
                              return _NotificationItem(
                                notification: notification,
                              );
                            } else if (index == filteredList.length &&
                                _viewModel.hasMore) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              // "You're all caught up" end of list
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: appColors.bgElevated,
                                      ),
                                      child: Icon(
                                        Symbols.done_all,
                                        size: 32,
                                        color: theme
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.35),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "YOU'RE ALL CAUGHT UP",
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.65),
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        alignment: Alignment.center,
        child: EmptyState(
          title: l10n.notificationsEmpty,
          message: l10n.notificationsEmptySubtitle,
          icon: Symbols.notifications_off,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : appColors.bgElevated,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : appColors.bgBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final entity.Notification notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final iconData = _getIcon(notification.type);

    return Opacity(
      opacity: notification.isRead ? 0.75 : 1.0,
      child: InkWell(
        onTap: () {
          if (notification.type == 'loyalty_update') {
            context.push('/loyalty');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? appColors.bgBorder
                  : theme.colorScheme.primary.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: notification.isRead
                ? null
                : [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          // We use a Stack to implement the left border overlay seamlessly
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (!notification.isRead)
                Positioned(
                  left: -16,
                  top: -16,
                  bottom: -16,
                  width: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notification.isRead
                          ? appColors.bgElevated
                          : appColors.brandPrimaryGhost,
                      border: notification.isRead
                          ? null
                          : Border.all(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                    ),
                    child: Center(
                      child: Icon(
                        iconData,
                        size: 22,
                        color: notification.isRead
                            ? theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              )
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.8),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat(
                            'MMM dd, HH:mm',
                            Localizations.localeOf(context).toString(),
                          ).format(notification.timestamp).toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'welcome':
        return Symbols.celebration;
      case 'reservation':
      case 'booking':
        return Symbols.event_available;
      case 'alert':
        return Symbols.warning_amber;
      case 'system':
        return Symbols.autorenew;
      case 'loyalty_update':
        return Symbols.stars;
      case 'success':
        return Symbols.check_circle_outline;
      case 'cancel':
        return Symbols.block;
      default:
        return Symbols.notifications;
    }
  }
}
