import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/get_my_events_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
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
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          'MY EVENTS',
          style: theme.textTheme.titleSmall?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return AppShimmer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: List.generate(5, (_) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppShimmer.block(width: double.infinity, height: 88),
              );
            }),
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_participants.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.emoji_events,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No event participations yet',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
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

class _EventParticipantCard extends StatelessWidget {
  final EventParticipant participant;

  const _EventParticipantCard({required this.participant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final typography = context.typography;
    final event = participant.event;
    if (event == null) return const SizedBox.shrink();

    final name = event.name ?? '';
    final status = event.status ?? '';
    final imageUrl = event.imageUrl;

    return AppCard.compact(
      onTap: () => context.push('/events/${event.id}', extra: event),
      child: Row(
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PremiumNetworkImage(
                imageUrl: imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          if (imageUrl != null) const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  status.toUpperCase(),
                  style: typography.overline?.copyWith(
                    color: status == 'open'
                        ? appColors.statusSuccess
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: participant.status == 'withdrawn'
                  ? theme.colorScheme.error.withValues(alpha: 0.1)
                  : theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (participant.status ?? '').toUpperCase(),
              style: typography.overline?.copyWith(
                color: participant.status == 'withdrawn'
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
