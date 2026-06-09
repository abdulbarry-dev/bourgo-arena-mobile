import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/mark_notifications_read_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_view_model.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:go_router/go_router.dart';

const Map<String, List<String>> _filterCategories = {
  'TOUT': [],
  'NON LUS': [],
  'RÉSERVATIONS': [
    'reservation_reminder',
    'booking',
    'reservation',
    'payment_success',
  ],
  'ABONNEMENTS': ['subscription_reminder'],
  'LOYALITÉ': ['loyalty_points'],
  'OFFRES': ['promotion', 'announcement'],
  'FAMILLE': ['family_activity'],
};

String _filterLabel(String key) => key;

IconData _getIcon(String type) {
  switch (type) {
    case 'reservation_reminder':
    case 'booking':
    case 'reservation':
      return Symbols.event_available;
    case 'loyalty_points':
      return Symbols.stars;
    case 'family_activity':
      return Symbols.family_restroom;
    case 'subscription_reminder':
      return Symbols.card_membership;
    case 'payment_success':
      return Symbols.payments;
    case 'member_update':
      return Symbols.manage_accounts;
    case 'promotion':
      return Symbols.local_offer;
    case 'announcement':
      return Symbols.campaign;
    case 'support':
      return Symbols.support_agent;
    case 'welcome':
      return Symbols.celebration;
    default:
      return Symbols.notifications;
  }
}

class NotificationsScreen extends StatefulWidget {
  final NotificationsViewModel? viewModel;
  const NotificationsScreen({super.key, this.viewModel});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  String _selectedFilter = 'TOUT';

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
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0 || position.pixels <= 0) return;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _viewModel.loadMore();
    }
  }

  List<entity.Notification> _getFilteredNotifications() {
    final all = _viewModel.notifications;
    if (_selectedFilter == 'TOUT') return all;
    if (_selectedFilter == 'NON LUS') {
      return all.where((n) => !n.isRead).toList();
    }
    final types = _filterCategories[_selectedFilter] ?? [];
    return all.where((n) => types.contains(n.type)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final filteredList = _getFilteredNotifications();
        final isLoading = _viewModel.isLoading;
        final errorMessage = _viewModel.errorMessage;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text(
              'NOTIFICATIONS',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
              color: theme.colorScheme.onSurface,
            ),
            actions: [
              if (_viewModel.notifications.isNotEmpty)
                IconButton(
                  icon: const Icon(Symbols.done_all, size: 22),
                  tooltip: 'Tout marquer comme lu',
                  onPressed: _viewModel.markAllAsRead,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: appColors.bgBorder, width: 1),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm,
                  ),
                  child: Row(
                    children: _filterCategories.keys.map((key) {
                      final isSelected = _selectedFilter == key;
                      return Padding(
                        padding: EdgeInsets.only(right: spacing.xs),
                        child: _FilterChip(
                          label: _filterLabel(key),
                          isSelected: isSelected,
                          onTap: () => setState(() {
                            _selectedFilter = key;
                            _scrollController.jumpTo(0);
                          }),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _viewModel.loadNotifications,
                  color: theme.colorScheme.primary,
                  child: _buildBody(
                    theme: theme,
                    spacing: spacing,
                    appColors: appColors,
                    filteredList: filteredList,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    onRetry: _viewModel.loadNotifications,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required ThemeData theme,
    required AppSpacing spacing,
    required AppColors appColors,
    required List<entity.Notification> filteredList,
    required bool isLoading,
    required String? errorMessage,
    required VoidCallback onRetry,
  }) {
    if (isLoading && _viewModel.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && _viewModel.notifications.isEmpty) {
      return _buildErrorState(
        theme: theme,
        spacing: spacing,
        message: errorMessage,
        onRetry: onRetry,
      );
    }

    if (_viewModel.notifications.isEmpty) {
      return _buildEmptyState(theme: theme, spacing: spacing);
    }

    if (filteredList.isEmpty) {
      return _buildEmptyFilterState(
        theme: theme,
        spacing: spacing,
        appColors: appColors,
      );
    }

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.lg,
      ),
      itemCount: filteredList.length + 1,
      separatorBuilder: (context, index) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        if (index < filteredList.length) {
          return _NotificationItem(notification: filteredList[index]);
        }
        if (_viewModel.isLoadingMore) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildCaughtUp(
          theme: theme,
          spacing: spacing,
          appColors: appColors,
        );
      },
    );
  }

  Widget _buildErrorState({
    required ThemeData theme,
    required AppSpacing spacing,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.wifi_off,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Chargement échoué',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xl),
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing.xl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh, size: 20),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required ThemeData theme,
    required AppSpacing spacing,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.notifications_off,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Aucune notification',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xl),
              child: Text(
                'Vous n\'avez aucune notification pour le moment.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState({
    required ThemeData theme,
    required AppSpacing spacing,
    required AppColors appColors,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: appColors.bgElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.filter_alt_off,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Aucun résultat',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'Aucune notification ne correspond à ce filtre.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaughtUp({
    required ThemeData theme,
    required AppSpacing spacing,
    required AppColors appColors,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xl),
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
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            'VOUS ÊTES À JOUR',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
            ),
          ),
        ],
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;
    final iconData = _getIcon(notification.type);

    return Opacity(
      opacity: notification.isRead ? 0.75 : 1.0,
      child: InkWell(
        onTap: () {
          if (notification.type == 'loyalty_points') {
            context.push('/loyalty');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: appColors.bgSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? appColors.bgBorder
                  : theme.colorScheme.primary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (!notification.isRead)
                Positioned(
                  left: -spacing.md,
                  top: -spacing.md,
                  bottom: -spacing.md,
                  width: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            SizedBox(width: spacing.xs),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: spacing.xxs),
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
                        SizedBox(height: spacing.xs),
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
}
