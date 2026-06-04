import 'package:collection/collection.dart';

/// Represents a single benefit associated with a subscription.
class Benefit {
  /// The display text or key for the benefit.
  final String label;

  /// Optional icon identifier or category for the benefit.
  final String? icon;

  const Benefit({required this.label, this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Benefit &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          icon == other.icon;

  @override
  int get hashCode => label.hashCode ^ icon.hashCode;
}

/// Pure domain entity representing a membership subscription plan.
class Subscription {
  /// Unique identifier.
  final String id;

  /// Name of the plan (e.g. Premium, Basic).
  final String name;

  /// Monthly price.
  final double price;

  /// List of benefits included in this plan.
  final List<Benefit> benefits;

  /// Duration of the plan in months.
  final int durationMonths;

  /// Creates a new [Subscription] instance.
  const Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.benefits,
    required this.durationMonths,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          _listEquality.equals(benefits, other.benefits) &&
          durationMonths == other.durationMonths;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      _listEquality.hash(benefits) ^
      durationMonths.hashCode;

  static const _listEquality = ListEquality<Benefit>();
}
