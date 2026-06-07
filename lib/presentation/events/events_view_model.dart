import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:flutter/material.dart';

/// State for the events list.
enum EventsLoadState { idle, loading, loaded, error }

/// ViewModel for the Events / Tournaments screen.
class EventsViewModel extends ChangeNotifier {
  final GetEventsUseCase _getEventsUseCase;
  final RegisterForEventUseCase _registerForEventUseCase;

  List<Event> _events = [];
  EventsLoadState _state = EventsLoadState.idle;
  String? _errorMessage;
  String? _registeringEventId;

  /// Creates a new [EventsViewModel].
  EventsViewModel({
    required GetEventsUseCase getEventsUseCase,
    required RegisterForEventUseCase registerForEventUseCase,
  }) : _getEventsUseCase = getEventsUseCase,
       _registerForEventUseCase = registerForEventUseCase {
    loadEvents();
  }

  /// Current list of events.
  List<Event> get events => _events;

  /// True while the list is being fetched.
  bool get isLoading => _state == EventsLoadState.loading;

  /// Error message if fetch failed.
  String? get errorMessage => _errorMessage;

  /// ID of the event currently being registered for.
  String? get registeringEventId => _registeringEventId;

  /// Fetches events from the API.
  Future<void> loadEvents() async {
    _state = EventsLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getEventsUseCase();
    result.when(
      success: (events) {
        _events = events;
        _state = EventsLoadState.loaded;
      },
      failure: (failure) {
        developer.log('EventsViewModel: ${failure.message}');
        _errorMessage = failure.message;
        _state = EventsLoadState.error;
      },
    );
    notifyListeners();
  }

  /// Registers the current user for [eventId].
  Future<bool> registerForEvent(String eventId) async {
    _registeringEventId = eventId;
    notifyListeners();

    final result = await _registerForEventUseCase(eventId);
    _registeringEventId = null;
    notifyListeners();

    return result.when(
      success: (_) => true,
      failure: (failure) {
        developer.log('EventsViewModel register: ${failure.message}');
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
    );
  }
}
