import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:flutter/material.dart';

enum EventsLoadState { idle, loading, loaded, error, loadingMore }

class EventsViewModel extends ChangeNotifier {
  final GetEventsUseCase _getEventsUseCase;
  final RegisterForEventUseCase _registerForEventUseCase;

  List<Event> _events = [];
  EventsLoadState _state = EventsLoadState.idle;
  String? _errorMessage;
  String? _registeringEventId;
  String? _lastRegistrationStatus;
  int _currentPage = 1;
  bool _hasMore = true;

  EventsViewModel({
    required GetEventsUseCase getEventsUseCase,
    required RegisterForEventUseCase registerForEventUseCase,
  }) : _getEventsUseCase = getEventsUseCase,
       _registerForEventUseCase = registerForEventUseCase {
    loadEvents();
  }

  List<Event> get events => _events;
  EventsLoadState get state => _state;
  bool get isLoading => _state == EventsLoadState.loading;
  bool get isLoadingMore => _state == EventsLoadState.loadingMore;
  String? get errorMessage => _errorMessage;
  String? get registeringEventId => _registeringEventId;
  bool get hasMore => _hasMore;

  Future<void> loadEvents() async {
    _state = EventsLoadState.loading;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    final result = await _getEventsUseCase(page: _currentPage);
    result.when(
      success: (events) {
        _events = events;
        _hasMore = events.length >= 15;
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

  Future<void> loadMore() async {
    if (isLoadingMore || !_hasMore) return;
    _state = EventsLoadState.loadingMore;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final result = await _getEventsUseCase(page: nextPage);
    result.when(
      success: (events) {
        _events.addAll(events);
        _currentPage = nextPage;
        _hasMore = events.length >= 15;
        _state = EventsLoadState.loaded;
      },
      failure: (failure) {
        developer.log('EventsViewModel loadMore: ${failure.message}');
        _state = EventsLoadState.loaded;
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
