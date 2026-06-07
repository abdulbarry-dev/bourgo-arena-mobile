import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/core/constants/loyalty_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_loyalty_balance_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';

enum LoyaltyLoadState { idle, loading, loaded, error }

/// ViewModel for the Loyalty Dashboard.
class LoyaltyDashboardViewModel extends ChangeNotifier {
  final AuthStateNotifier _authStateNotifier;
  final GetLoyaltyBalanceUseCase _getLoyaltyBalanceUseCase;

  LoyaltyLoadState _state = LoyaltyLoadState.idle;
  LoyaltyBalance? _balance;
  String? _errorMessage;
  bool _hasEverLoaded = false;
  bool _isRefreshing = false;
  String? _refreshError;

  void clearRefreshError() {
    _refreshError = null;
  }

  String? get refreshError => _refreshError;

  /// Creates a new [LoyaltyDashboardViewModel] instance.
  LoyaltyDashboardViewModel({
    required AuthStateNotifier authStateNotifier,
    required GetLoyaltyBalanceUseCase getLoyaltyBalanceUseCase,
  }) : _authStateNotifier = authStateNotifier,
       _getLoyaltyBalanceUseCase = getLoyaltyBalanceUseCase {
    _authStateNotifier.addListener(_onAuthChanged);
    loadBalance();
  }

  @override
  void dispose() {
    _authStateNotifier.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (!_isRefreshing && _state != LoyaltyLoadState.loading) {
      loadBalance();
    }
  }

  bool get isLoading => _state == LoyaltyLoadState.loading && !_hasEverLoaded;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;

  /// The currently authenticated user.
  User? get user => _authStateNotifier.currentUser;

  /// The user's current loyalty points.
  int get currentPoints => _balance?.totalPoints ?? user?.loyaltyPoints ?? 0;

  /// The user's current loyalty tier.
  MemberTier get currentTier {
    final name = _balance?.tierName?.toLowerCase();
    if (name != null) {
      if (name.contains('ultra')) return MemberTier.ultra;
      if (name.contains('family')) return MemberTier.familyMax;
      return MemberTier.standard;
    }

    if (currentPoints >= LoyaltyConstants.platinumThreshold) {
      return MemberTier.ultra;
    }
    if (currentPoints >= LoyaltyConstants.goldThreshold) {
      return MemberTier.standard;
    }
    return MemberTier.public;
  }

  /// The points required for the next tier.
  int get pointsToNextTier {
    if (currentPoints >= LoyaltyConstants.platinumThreshold) return 0;
    if (currentPoints >= LoyaltyConstants.goldThreshold) {
      return LoyaltyConstants.platinumThreshold - currentPoints;
    }
    return LoyaltyConstants.goldThreshold - currentPoints;
  }

  /// The next tier.
  MemberTier? get nextTier {
    if (currentPoints >= LoyaltyConstants.platinumThreshold) return null;
    if (currentPoints >= LoyaltyConstants.goldThreshold) {
      return MemberTier.ultra;
    }
    return MemberTier.standard;
  }

  /// Progress percentage towards the next tier (0.0 to 1.0).
  double get progressToNextTier {
    int start = 0;
    int end = LoyaltyConstants.goldThreshold;

    if (currentPoints >= LoyaltyConstants.platinumThreshold) {
      return 1.0;
    } else if (currentPoints >= LoyaltyConstants.goldThreshold) {
      start = LoyaltyConstants.goldThreshold;
      end = LoyaltyConstants.platinumThreshold;
    } else {
      start = 0;
      end = LoyaltyConstants.goldThreshold;
    }

    final range = end - start;
    if (range <= 0) return 1.0;

    final progress = (currentPoints - start) / range;
    return progress.clamp(0.0, 1.0);
  }

  /// Points earned this month
  int get earnedThisMonth => _balance?.earnedThisMonth ?? 0;

  /// Points redeemed this month
  int get redeemedThisMonth => _balance?.redeemedThisMonth ?? 0;

  /// Recent transactions
  List<LoyaltyTransaction> get recentTransactions =>
      _balance?.transactions ?? [];

  /// Fetches the real loyalty balance from API.
  Future<void> loadBalance() async {
    _isRefreshing = _hasEverLoaded;
    _state = LoyaltyLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getLoyaltyBalanceUseCase();
    result.when(
      success: (balance) {
        _balance = balance;
        _state = LoyaltyLoadState.loaded;
        _hasEverLoaded = true;
      },
      failure: (failure) {
        developer.log('LoyaltyDashboardViewModel error: ${failure.message}');
        _errorMessage = failure.message;
        _state = LoyaltyLoadState.error;
        if (_hasEverLoaded) {
          _refreshError = failure.message;
        }
      },
    );
    _isRefreshing = false;
    notifyListeners();
  }
}
