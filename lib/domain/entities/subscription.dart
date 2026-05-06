/// Pure domain entity representing a membership subscription plan.
class Subscription {
  /// Unique identifier.
  final String id;

  /// Name of the plan (e.g. Premium, Basic).
  final String name;

  /// Monthly price.
  final double price;

  /// List of benefits included in this plan.
  final List<String> benefits;

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
}
