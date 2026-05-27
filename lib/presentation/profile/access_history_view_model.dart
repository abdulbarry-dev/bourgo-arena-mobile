import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
// NFC-related use cases and entities removed.
import 'package:bourgo_arena_mobile/domain/usecases/user/get_access_history_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the access/check-in history tab.
class AccessHistoryViewModel extends ChangeNotifier {
  final GetAccessHistoryUseCase _getAccessHistoryUseCase;
  final SessionRepository _sessionRepository;

  bool _isLoading = true;
  String? _error;
  List<AccessHistoryEntry> _history = [];
  // NFC status removed — only track onboarding completion (PIN) now.
  bool _isOnboardingCompleted = false;

  AccessHistoryViewModel({
    required GetAccessHistoryUseCase getAccessHistoryUseCase,
    required SessionRepository sessionRepository,
  }) : _getAccessHistoryUseCase = getAccessHistoryUseCase,
       _sessionRepository = sessionRepository;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AccessHistoryEntry> get history => _history;

  bool get isPinConfigured => _isOnboardingCompleted;

  // NFC getters removed. Only keep onboarding PIN status.

  Future<void> loadHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([_loadAccessHistory(), _loadAccessMethodStatus()]);
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

  Future<void> _loadAccessHistory() async {
    final result = await _getAccessHistoryUseCase();
    result.when(
      success: (entries) => _history = entries,
      failure: (failure) {
        _error = failure.message;
        developer.log('Error loading access history: ${failure.message}');
      },
    );
  }

  Future<void> _loadAccessMethodStatus() async {
    final onboardingResult = await _sessionRepository.isOnboardingCompleted();
    onboardingResult.when(
      success: (completed) => _isOnboardingCompleted = completed,
      failure: (failure) {
        developer.log(
          'Error loading onboarding completion status: ${failure.message}',
        );
      },
    );

    // Only check onboarding completion via session repository.
    // PIN onboarding status is already captured by `_isOnboardingCompleted`.
  }
}
