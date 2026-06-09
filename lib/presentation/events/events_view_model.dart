import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:flutter/material.dart';

enum EventsLoadState { idle, loading, loaded, error }

class EventsViewModel extends ChangeNotifier {
  final GetEventsUseCase _getEventsUseCase;
  final RegisterForEventUseCase _registerForEventUseCase;

  List<Event> _events = [];
  EventsLoadState _state = EventsLoadState.idle;
  String? _errorMessage;
  String? _registeringEventId;
  String? _lastRegistrationStatus;

  EventsViewModel({
    required GetEventsUseCase getEventsUseCase,
    required RegisterForEventUseCase registerForEventUseCase,
  }) : _getEventsUseCase = getEventsUseCase,
       _registerForEventUseCase = registerForEventUseCase {
    loadEvents();
  }

  List<Event> get events => _events;
  bool get isLoading => _state == EventsLoadState.loading;
  String? get errorMessage => _errorMessage;
  String? get registeringEventId => _registeringEventId;

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

  Future<bool> registerForEvent(String eventId) async {
    _registeringEventId = eventId;
    _lastRegistrationStatus = null;
    notifyListeners();

    final result = await _registerForEventUseCase(eventId);
    _registeringEventId = null;

    return result.when(
      success: (reg) {
        _lastRegistrationStatus = reg.status;
        notifyListeners();
        return true;
      },
      failure: (failure) {
        developer.log('EventsViewModel register: ${failure.message}');
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
    );
  }

  String? get lastRegistrationStatus => _lastRegistrationStatus;
}
