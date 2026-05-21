import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/entities/digital_nfc_status.dart';
import 'package:bourgo_arena_mobile/domain/entities/physical_nfc_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/nfc/get_digital_nfc_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/nfc/get_physical_nfc_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_access_history_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the access/check-in history tab.
class AccessHistoryViewModel extends ChangeNotifier {
  final GetAccessHistoryUseCase _getAccessHistoryUseCase;
  final GetPhysicalNfcStatusUseCase _getPhysicalNfcStatusUseCase;
  final GetDigitalNfcStatusUseCase _getDigitalNfcStatusUseCase;
  final SessionRepository _sessionRepository;

  bool _isLoading = true;
  String? _error;
  List<AccessHistoryEntry> _history = [];
  PhysicalNfcStatus? _physicalNfcStatus;
  DigitalNfcStatus? _digitalNfcStatus;
  bool _isOnboardingCompleted = false;

  AccessHistoryViewModel({
    required GetAccessHistoryUseCase getAccessHistoryUseCase,
    required GetPhysicalNfcStatusUseCase getPhysicalNfcStatusUseCase,
    required GetDigitalNfcStatusUseCase getDigitalNfcStatusUseCase,
    required SessionRepository sessionRepository,
  }) : _getAccessHistoryUseCase = getAccessHistoryUseCase,
       _getPhysicalNfcStatusUseCase = getPhysicalNfcStatusUseCase,
       _getDigitalNfcStatusUseCase = getDigitalNfcStatusUseCase,
       _sessionRepository = sessionRepository;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AccessHistoryEntry> get history => _history;

  bool get isPinConfigured => _isOnboardingCompleted;

  bool get isPhysicalNfcConfigured => _physicalNfcStatus?.isReady ?? false;

  bool get isDigitalNfcConfigured {
    final digitalStatus = _digitalNfcStatus;
    if (digitalStatus == null) return false;
    return digitalStatus.isReady || digitalStatus.setupStatus == 'completed';
  }

  bool get isDigitalNfcUnsupported {
    final digitalStatus = _digitalNfcStatus;
    if (digitalStatus == null) return false;
    return !digitalStatus.supported ||
        digitalStatus.setupStatus == 'unsupported';
  }

  bool get canSetupDigitalNfc {
    // Always provide an entry point to the Digital NFC setup screen so users
    // can inspect current device support and setup requirements.
    return !isDigitalNfcConfigured;
  }

  String get digitalNfcStatusLabel {
    final digitalStatus = _digitalNfcStatus;
    if (digitalStatus == null) return 'Not set';
    if (isDigitalNfcConfigured) return 'Configured';
    if (!digitalStatus.supported) return 'Not supported';
    if (digitalStatus.setupStatus == 'revoked') return 'Revoked';
    return 'Not set';
  }

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

    try {
      final statuses = await Future.wait([
        _getPhysicalNfcStatusUseCase(),
        _getDigitalNfcStatusUseCase(),
      ]);
      _physicalNfcStatus = statuses[0] as PhysicalNfcStatus;
      _digitalNfcStatus = statuses[1] as DigitalNfcStatus;
    } catch (e, stackTrace) {
      developer.log(
        'Error loading NFC status in access history',
        error: e,
        stackTrace: stackTrace,
      );
    }

    if (_physicalNfcStatus != null) {
      final hasPinFallback = _physicalNfcStatus!.fallbackMethods.contains(
        'pin',
      );
      _isOnboardingCompleted = _isOnboardingCompleted || hasPinFallback;
    }
  }
}
