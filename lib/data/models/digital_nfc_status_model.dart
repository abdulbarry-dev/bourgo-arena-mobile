import 'package:json_annotation/json_annotation.dart';

part 'digital_nfc_status_model.g.dart';

/// Data transfer object for the digital NFC status.
@JsonSerializable(fieldRename: FieldRename.snake)
class DigitalNfcStatusModel {
  final bool supported;
  final bool configured;
  final bool eligible;
  final bool isReady;
  final String setupStatus;
  final List<String> reasons;
  final List<String> fallbackMethods;

  const DigitalNfcStatusModel({
    required this.supported,
    required this.configured,
    required this.eligible,
    required this.isReady,
    required this.setupStatus,
    this.reasons = const [],
    this.fallbackMethods = const [],
  });

  factory DigitalNfcStatusModel.fromJson(Map<String, dynamic> json) =>
      _$DigitalNfcStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$DigitalNfcStatusModelToJson(this);
}
