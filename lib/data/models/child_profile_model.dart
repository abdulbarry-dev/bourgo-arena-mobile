import 'package:json_annotation/json_annotation.dart';

part 'child_profile_model.g.dart';

/// DTO for a child's profile data.
@JsonSerializable(fieldRename: FieldRename.snake)
class ChildProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String? gender;
  final String? avatarUrl;

  const ChildProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.gender,
    this.avatarUrl,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildProfileModelToJson(this);
}
