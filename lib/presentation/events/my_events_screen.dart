import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/get_my_events_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/guest_auth_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late final GetMyEventsUseCase _getMyEventsUseCase;

  List<EventParticipant> _participants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getMyEventsUseCase = locator<GetMyEventsUseCase>();
    _load();
  }

  Future<void> _load() async {
    if (!locator<AuthStateNotifier>().isAuthenticated) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _getMyEventsUseCase();
    if (!mounted) return;

    result.when(
      success: (participants) {
        setState(() {
          _participants = participants;
          _isLoading = false;
        });
      },
      failure: (f) {
        setState(() {
          _error = f.message;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SubScreenAppBar(
        title: AppLocalizations.of(context)!.myEventsScreenTitle,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (!locator<AuthStateNotifier>().isAuthenticated) {
      return const GuestAuthState(icon: Symbols.emoji_events);
    }

    if (_isLoading) {
      return RefreshIndicator(
        onRefresh: _load,
        child: AppShimmer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(5, (_) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppShimmer.block(width: double.infinity, height: 88),
                );
              }),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _load,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(32),
              children: [
                SizedBox(
                  height: constraints.maxHeight - 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.error,
                        size: 48,
                        color: theme.colorScheme.error.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(_error!, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _load,
                        icon: const Icon(Symbols.refresh, size: 18),
                        label: Text(
                          AppLocalizations.of(
                            context,
                          )!.myEventsScreenRetryButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    if (_participants.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: EmptyState(
          title: AppLocalizations.of(context)!.myEventsScreenNoEvents,
          message: '',
          icon: Symbols.emoji_events,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: _participants.length,
        itemBuilder: (context, index) {
          final p = _participants[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _EventParticipantCard(participant: p),
          );
        },
      ),
    );
  }
}

enum _EventTimeStatus { upcoming, inProgress, completed }

_EventTimeStatus _resolveEventTimeStatus(Event event) {
  try {
    final now = DateTime.now();
    if (event.startDate != null) {
      final start = DateTime.parse(event.startDate!);
      if (now.isBefore(start)) return _EventTimeStatus.upcoming;
    }
    if (event.endDate != null) {
      final end = DateTime.parse(event.endDate!);
      if (now.isAfter(end)) return _EventTimeStatus.completed;
    }
    if (event.startDate != null && event.endDate != null) {
      final start = DateTime.parse(event.startDate!);
      final end = DateTime.parse(event.endDate!);
      if (!now.isBefore(start) && !now.isAfter(end)) {
        return _EventTimeStatus.inProgress;
      }
    }
    if (event.startDate != null) return _EventTimeStatus.inProgress;
    return _EventTimeStatus.upcoming;
  } catch (_) {
    return _EventTimeStatus.upcoming;
  }
}

(Color, String) _participantStatusStyle(String? status, ThemeData theme) {
  final appColors = theme.extension<AppColors>()!;
  switch ((status ?? '').toLowerCase()) {
    case 'approved':
      return (appColors.statusSuccess, 'APPROVED');
    case 'registered':
      return (appColors.statusSuccess, 'REGISTERED');
    case 'pending':
      return (appColors.statusWarning, 'PENDING');
    case 'waitlisted':
      return (appColors.statusWarning, 'WAITLISTED');
    case 'withdrawn':
      return (theme.colorScheme.error, 'WITHDRAWN');
    default:
      return (theme.colorScheme.onSurfaceVariant, (status ?? '').toUpperCase());
  }
}

(Color, String) _eventStatusStyle(_EventTimeStatus status, ThemeData theme) {
  final appColors = theme.extension<AppColors>()!;
  switch (status) {
    case _EventTimeStatus.upcoming:
      return (theme.colorScheme.primary, 'UPCOMING');
    case _EventTimeStatus.inProgress:
      return (const Color(0xFFF59E0B), 'IN PROGRESS');
    case _EventTimeStatus.completed:
      return (appColors.statusSuccess, 'COMPLETED');
  }
}

class _EventParticipantCard extends StatelessWidget {
  final EventParticipant participant;

  const _EventParticipantCard({required this.participant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = participant.event;
    if (event == null) return const SizedBox.shrink();

    final name = event.name ?? '';
    final imageUrl = event.imageUrl;
    final eventTimeStatus = _resolveEventTimeStatus(event);
    final (eventColor, eventLabel) = _eventStatusStyle(eventTimeStatus, theme);
    final (pColor, pLabel) = _participantStatusStyle(participant.status, theme);
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return _AppCardCompact(
      onTap: () => context.push('/events/${event.id}', extra: event),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: PremiumNetworkImage(
                      imageUrl: imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Symbols.emoji_events,
                    size: 24,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (participant.user?.name != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'For: ${participant.user!.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: eventColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        eventLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: eventColor,
                          fontSize: 9,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: pColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: pColor,
                          fontSize: 9,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Symbols.chevron_right,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

class _AppCardCompact extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _AppCardCompact({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: appColors.bgElevated,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appColors.bgBorder),
          ),
          child: child,
        ),
      ),
    );
  }
}
