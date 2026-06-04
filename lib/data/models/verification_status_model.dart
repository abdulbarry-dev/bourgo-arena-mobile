import 'package:json_annotation/json_annotation.dart';

part 'verification_status_model.g.dart';

/// DTO for the verification status data.
@JsonSerializable(fieldRename: FieldRename.snake)
class VerificationStatusModel {
  final bool emailVerified;
  final bool phoneVerified;
  final bool onboardingCompleted;
  final bool? isFullyVerified;
  final String? email;
  final String? phone;
  final String? unverifiedMethod;

  const VerificationStatusModel({
    required this.emailVerified,
    required this.phoneVerified,
    required this.onboardingCompleted,
    this.isFullyVerified,
    this.email,
    this.phone,
    this.unverifiedMethod,
  });

  factory VerificationStatusModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationStatusModelToJson(this);
}
