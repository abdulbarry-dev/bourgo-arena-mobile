class NextTierModel {
  final String label;
  final double multiplier;
  final int required;

  const NextTierModel({
    required this.label,
    required this.multiplier,
    required this.required,
  });

  factory NextTierModel.fromJson(Map<String, dynamic> json) {
    final mult = json['multiplier'];
    return NextTierModel(
      label: json['label'] as String? ?? '',
      multiplier: mult is double ? mult : (mult as num).toDouble(),
      required: json['required'] is int
          ? json['required'] as int
          : (json['required'] as num).toInt(),
    );
  }
}

class MemberTierModel {
  final String label;
  final double multiplier;
  final int count;
  final NextTierModel? nextTier;
  final int progressPercentage;

  const MemberTierModel({
    required this.label,
    required this.multiplier,
    required this.count,
    this.nextTier,
    required this.progressPercentage,
  });

  factory MemberTierModel.fromJson(Map<String, dynamic> json) {
    final mult = json['multiplier'];
    return MemberTierModel(
      label: json['label'] as String? ?? '',
      multiplier: mult is double ? mult : (mult as num).toDouble(),
      count: json['count'] is int
          ? json['count'] as int
          : (json['count'] as num).toInt(),
      nextTier: json['next_tier'] != null
          ? NextTierModel.fromJson(json['next_tier'] as Map<String, dynamic>)
          : null,
      progressPercentage: json['progress_percentage'] is int
          ? json['progress_percentage'] as int
          : (json['progress_percentage'] as num).toInt(),
    );
  }
}
