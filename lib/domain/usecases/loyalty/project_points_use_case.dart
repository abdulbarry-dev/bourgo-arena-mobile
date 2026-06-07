import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';

/// Projects loyalty points for a checkout summary (display only).
///
/// This does not mutate any points locally; awarding must happen on the API.
class ProjectPointsUseCase {
  const ProjectPointsUseCase();

  int call({required double amount, required MemberTier tier}) {
    // Display-only projection rules. Backend remains source of truth.
    final multiplier = switch (tier) {
      MemberTier.public => 1.0,
      MemberTier.standard => 1.0,
      MemberTier.ultra => 1.25,
      MemberTier.familyMax => 1.5,
    };
    final projected = (amount * multiplier).round();
    return projected < 0 ? 0 : projected;
  }
}
