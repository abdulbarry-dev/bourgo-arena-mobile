import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

/// DTO for an active subscription matching SubscriptionResource.
@JsonSerializable(fieldRename: FieldRename.snake)
class SubscriptionModel {
  @JsonKey(fromJson: _idToString)
  final String id;
  final String? planName;
  final String? planDescription;
  final String? status;
  final String? startsAt;
  final String? endsAt;
  final int? daysRemaining;
  final String? paymentMethod;
  final double? amountPaid;

  /// Legacy fields retained for backward compatibility.
  final String? name;
  final double? price;
  final int? durationMonths;

  const SubscriptionModel({
    required this.id,
    this.planName,
    this.planDescription,
    this.status,
    this.startsAt,
    this.endsAt,
    this.daysRemaining,
    this.paymentMethod,
    this.amountPaid,
    this.name,
    this.price,
    this.durationMonths,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  static String _idToString(dynamic id) => id.toString();
}
