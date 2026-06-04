import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';

/// Pure tier mapping derived from API-read subscription level.
class GetMemberTierUseCase {
  const GetMemberTierUseCase();

  MemberTier call({required String? subscriptionLevel}) {
    final normalized = (subscriptionLevel ?? '').trim().toLowerCase();
    if (normalized.isEmpty) return MemberTier.public;

    if (normalized.contains('family') && normalized.contains('max')) {
      return MemberTier.familyMax;
    }
    if (normalized.contains('ultra')) return MemberTier.ultra;
    if (normalized.contains('standard')) return MemberTier.standard;

    // Back-compat / unknown tiers are treated as Standard.
    return MemberTier.standard;
  }
}
