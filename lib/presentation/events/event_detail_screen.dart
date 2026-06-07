import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  final Event? event;

  const EventDetailScreen({super.key, required this.eventId, this.event});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would fetch details via GetEventByIdUseCase
    // and GetEventBracketUseCase. For now, this is a placeholder.
    return Scaffold(
      appBar: AppBar(title: Text(event?.name ?? 'Event Details')),
      body: Center(child: Text('Details for Event: ${event?.name ?? eventId}')),
    );
  }
}
