import 'package:bourgo_arena_mobile/domain/entities/plan.dart';

/// Entity representing an active member subscription matching SubscriptionResource.
class Subscription {
  /// Unique identifier.
  final String id;

  /// The subscribed plan details.
  final Plan? plan;

  /// The service details for the subscription.
  final PlanService? service;

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

  /// URL to the receipt/invoice PDF.
  final String? receiptUrl;

  /// Creates a new [Subscription] instance.
  const Subscription({
    required this.id,
    this.plan,
    this.service,
    required this.status,
    this.startsAt,
    this.endsAt,
    this.daysRemaining,
    this.paymentMethod,
    this.amountPaid,
    this.receiptUrl,
  });

  /// Returns true when the subscription is currently active.
  bool get isActive => status == 'active';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          plan?.id == other.plan?.id &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ (plan?.id.hashCode ?? 0) ^ status.hashCode;
}
