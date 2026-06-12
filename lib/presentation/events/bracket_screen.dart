import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/bracket.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class BracketScreen extends StatefulWidget {
  final String eventId;
  final Event? event;

  const BracketScreen({super.key, required this.eventId, this.event});

  @override
  State<BracketScreen> createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  List<BracketRound> _rounds = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final result = await locator<GetEventBracketUseCase>()(widget.eventId);
    if (!mounted) return;
    result.when(
      success: (rounds) => setState(() {
        _rounds = rounds;
        _isLoading = false;
      }),
      failure: (f) => setState(() {
        _error = f.message;
        _isLoading = false;
      }),
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
          'BRACKET',
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: List.generate(3, (_) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.block(width: 120, height: 16),
                    const SizedBox(height: 12),
                    AppShimmer.block(width: double.infinity, height: 72),
                    const SizedBox(height: 8),
                    AppShimmer.block(width: double.infinity, height: 72),
                  ],
                ),
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

    if (_rounds.isEmpty) {
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
              'Bracket not yet available',
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
        itemCount: _rounds.length,
        itemBuilder: (context, index) {
          final round = _rounds[index];
          return _BracketRoundCard(
            round: round,
            isLast: index == _rounds.length - 1,
          );
        },
      ),
    );
  }
}

class _BracketRoundCard extends StatelessWidget {
  final BracketRound round;
  final bool isLast;

  const _BracketRoundCard({required this.round, required this.isLast});

  String _roundLabel(int roundNumber, int totalRounds) {
    if (totalRounds == 1) return 'FINAL';
    if (roundNumber == totalRounds) return 'FINAL';
    if (roundNumber == totalRounds - 1) return 'SEMI-FINALS';
    if (roundNumber == totalRounds - 2) return 'QUARTER-FINALS';
    return 'ROUND $roundNumber';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = context.typography;
    final totalRounds = round.round;
    final label = _roundLabel(round.round, totalRounds);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              style: typography.sectionTitle?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ...round.matches.map(
            (match) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _MatchCard(match: match),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final p1 = match.participant1;
    final p2 = match.participant2;
    final isCompleted = match.status == 'completed';
    final isWalkover = match.status == 'walkover';

    return Container(
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.bgBorder.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _ParticipantRow(
              name: p1?.name ?? 'TBD',
              initials: p1?.initials,
              isWinner: match.winnerId != null && p1?.id == match.winnerId,
              score: isCompleted ? _participantScore(match.score, 0) : null,
              theme: theme,
              appColors: appColors,
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: appColors.bgBorder.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            _ParticipantRow(
              name: p2?.name ?? 'TBD',
              initials: p2?.initials,
              isWinner: match.winnerId != null && p2?.id == match.winnerId,
              score: isCompleted ? _participantScore(match.score, 1) : null,
              theme: theme,
              appColors: appColors,
            ),
            if (isCompleted || isWalkover) ...[
              const SizedBox(height: 10),
              _MatchStatusChip(
                label: isWalkover ? 'WALKOVER' : 'COMPLETED',
                color: isWalkover
                    ? theme.colorScheme.error
                    : appColors.statusSuccess,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _participantScore(String? score, int index) {
    if (score == null) return null;
    final parts = score.split(', ');
    if (index < parts.length) return parts[index];
    return null;
  }
}

class _ParticipantRow extends StatelessWidget {
  final String name;
  final String? initials;
  final bool isWinner;
  final String? score;
  final ThemeData theme;
  final AppColors appColors;

  const _ParticipantRow({
    required this.name,
    this.initials,
    required this.isWinner,
    this.score,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isWinner
                ? appColors.statusSuccess.withValues(alpha: 0.15)
                : appColors.bgBorder.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              initials ?? (name.isNotEmpty ? name[0].toUpperCase() : '?'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isWinner
                    ? appColors.statusSuccess
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isWinner ? FontWeight.w700 : FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (score != null)
          Text(
            score!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}

class _MatchStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MatchStatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: typography.overline?.copyWith(color: color)),
    );
  }
}
