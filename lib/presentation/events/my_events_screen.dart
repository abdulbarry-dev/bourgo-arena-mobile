import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/get_my_events_use_case.dart';
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
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.error, size: 48,
                color: theme.colorScheme.error.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(_error!, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_participants.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.emoji_events, size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No event participations yet',
                style: theme.textTheme.titleMedium),
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
          final event = p.event;
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
    final event = participant.event;
    if (event == null) return const SizedBox.shrink();

    final name = event.name ?? '';
    final status = event.status ?? '';
    final imageUrl = event.imageUrl;

    return GestureDetector(
      onTap: () => context.push('/events/${event.id}', extra: event),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.bgBorder),
        ),
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: status == 'open'
                          ? Colors.green
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
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: participant.status == 'withdrawn'
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
