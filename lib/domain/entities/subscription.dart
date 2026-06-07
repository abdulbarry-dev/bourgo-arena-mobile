/// Entity representing an active member subscription matching SubscriptionResource.
class Subscription {
  /// Unique identifier.
  final String id;

  /// Plan name (e.g. "Premium", "Basic").
  final String planName;

  /// Plan description.
  final String? planDescription;

  /// Status (active, expired, cancelled).
  final String status;

  /// ISO datetime when the subscription started.
  final String? startsAt;

  /// ISO datetime when the subscription ends.
  final String? endsAt;

  /// Remaining days until expiry.
  final int? daysRemaining;

  /// Payment method used.
  final String? paymentMethod;

  /// Total amount paid.
  final double? amountPaid;

  /// Creates a new [Subscription] instance.
  const Subscription({
    required this.id,
    required this.planName,
    this.planDescription,
    required this.status,
    this.startsAt,
    this.endsAt,
    this.daysRemaining,
    this.paymentMethod,
    this.amountPaid,
  });

  /// Returns true when the subscription is currently active.
  bool get isActive => status == 'active';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          planName == other.planName &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ planName.hashCode ^ status.hashCode;
}
