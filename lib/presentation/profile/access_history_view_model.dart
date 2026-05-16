import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_access_history_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the access/check-in history tab.
class AccessHistoryViewModel extends ChangeNotifier {
  final GetAccessHistoryUseCase _getAccessHistoryUseCase;

  bool _isLoading = true;
  String? _error;
  List<AccessHistoryEntry> _history = [];

  AccessHistoryViewModel({
    required GetAccessHistoryUseCase getAccessHistoryUseCase,
  }) : _getAccessHistoryUseCase = getAccessHistoryUseCase;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AccessHistoryEntry> get history => _history;

  Future<void> loadHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _getAccessHistoryUseCase();
      result.when(
        success: (entries) => _history = entries,
        failure: (failure) {
          _error = failure.message;
          developer.log('Error loading access history: ${failure.message}');
        },
      );
    } catch (e, stackTrace) {
      _error = null;
      developer.log(
        'Unexpected error loading access history',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
