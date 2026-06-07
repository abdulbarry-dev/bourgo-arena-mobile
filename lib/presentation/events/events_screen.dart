import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/events/events_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen listing all published tournament events.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final EventsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventsViewModel(
      getEventsUseCase: locator<GetEventsUseCase>(),
      registerForEventUseCase: locator<RegisterForEventUseCase>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final theme = Theme.of(context);
        return Scaffold(
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
                    Symbols.emoji_events,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Tournaments & Events',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            backgroundColor: theme.colorScheme.surface,
          ),
          body: _EventsBody(viewModel: _viewModel),
        );
      },
    );
  }
}

class _EventsBody extends StatelessWidget {
  final EventsViewModel viewModel;

  const _EventsBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return _ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.loadEvents,
      );
    }

    if (viewModel.events.isEmpty) {
      return const _EmptyState();
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.events.length,
        itemBuilder: (context, index) {
          final event = viewModel.events[index];
          return _EventCard(
            event: event,
            isRegistering: viewModel.registeringEventId == event.id,
            onTap: () => context.push('/events/${event.id}', extra: event),
            onRegister: () async {
              final success = await viewModel.registerForEvent(event.id);
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully registered!')),
                );
              } else if (context.mounted && viewModel.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage!),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final bool isRegistering;
  final VoidCallback onTap;
  final VoidCallback onRegister;

  const _EventCard({
    required this.event,
    required this.isRegistering,
    required this.onTap,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = event.isRegistrationOpen;

    String? formattedDate;
    if (event.startDate != null) {
      try {
        final date = DateTime.parse(event.startDate!);
        formattedDate = DateFormat('dd MMM yyyy').format(date);
      } catch (_) {
        formattedDate = event.startDate;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.name ?? 'Event',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatusChip(status: event.status ?? 'unknown'),
                ],
              ),
              if (event.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (formattedDate != null) ...[
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(formattedDate, style: theme.textTheme.labelMedium),
                    const SizedBox(width: 16),
                  ],
                  if (event.format != null) ...[
                    Icon(
                      Icons.emoji_events,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.format!.replaceAll('_', ' ').toUpperCase(),
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                  const Spacer(),
                  if (event.participantsCount != null &&
                      event.maxParticipants != null)
                    Text(
                      '${event.participantsCount}/'
                      '${event.maxParticipants}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              if (isOpen) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isRegistering ? null : onRegister,
                    child: isRegistering
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Register'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    switch (status) {
      case 'published':
        color = theme.colorScheme.primary;
      case 'ongoing':
        color = Colors.orange;
      case 'completed':
        color = theme.colorScheme.outline;
      default:
        color = theme.colorScheme.outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No tournaments available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back soon for upcoming events.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
