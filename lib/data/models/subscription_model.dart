import 'package:json_annotation/json_annotation.dart';
import 'package:bourgo_arena_mobile/data/models/plan_model.dart';

part 'subscription_model.g.dart';

/// DTO for an active subscription matching SubscriptionResource.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SubscriptionModel {
  @JsonKey(fromJson: _idToString)
  final String id;

  final PlanModel? plan;
  final PlanServiceModel? service;

  final String? status;
  final String? startsAt;
  final String? endsAt;
  final int? daysRemaining;
  final String? paymentMethod;
  final double? amountPaid;
  final bool? isActive;
  final String? receiptUrl;

  const SubscriptionModel({
    required this.id,
    this.plan,
    this.service,
    this.status,
    this.startsAt,
    this.endsAt,
    this.daysRemaining,
    this.paymentMethod,
    this.amountPaid,
    this.isActive,
    this.receiptUrl,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  static String _idToString(dynamic id) => id.toString();
}
