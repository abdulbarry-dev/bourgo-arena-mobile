import 'package:bourgo_arena_mobile/core/constants/loyalty_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Loyalty Dashboard.
class LoyaltyDashboardViewModel extends ChangeNotifier {
  final AuthStateNotifier _authStateNotifier;

  /// Creates a new [LoyaltyDashboardViewModel] instance.
  LoyaltyDashboardViewModel({required AuthStateNotifier authStateNotifier})
    : _authStateNotifier = authStateNotifier {
    _authStateNotifier.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _authStateNotifier.removeListener(notifyListeners);
    super.dispose();
  }

  /// The currently authenticated user.
  User? get user => _authStateNotifier.currentUser;

  /// The user's current loyalty points.
  int get currentPoints => user?.loyaltyPoints ?? 0;

  /// The user's current loyalty tier.
  MemberTier get currentTier {
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
    if (currentPoints >= LoyaltyConstants.platinumThreshold) {
      return null;
    }
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
}
