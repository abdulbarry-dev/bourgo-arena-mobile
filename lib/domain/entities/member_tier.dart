/// Loyalty tier for a member. Values are derived from API-read data.
enum MemberTier {
  /// No recognized tier / public pricing.
  public,

  /// Standard membership.
  standard,

  /// Ultra tier.
  ultra,

  /// Family Max tier.
  familyMax,
}

extension MemberTierX on MemberTier {
  String get label => switch (this) {
    MemberTier.public => 'Public',
    MemberTier.standard => 'Standard',
    MemberTier.ultra => 'Ultra',
    MemberTier.familyMax => 'Family Max',
  };

  /// Higher number means "better" tier.
  int get rank => switch (this) {
    MemberTier.public => 0,
    MemberTier.standard => 1,
    MemberTier.ultra => 2,
    MemberTier.familyMax => 3,
  };
}
