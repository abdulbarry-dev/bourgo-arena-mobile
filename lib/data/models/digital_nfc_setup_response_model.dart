import 'package:json_annotation/json_annotation.dart';

part 'digital_nfc_setup_response_model.g.dart';

/// Data transfer object for the digital NFC setup response.
@JsonSerializable(fieldRename: FieldRename.snake)
class DigitalNfcSetupResponseModel {
  final String setupStatus;
  final bool supported;
  final bool eligible;

  const DigitalNfcSetupResponseModel({
    required this.setupStatus,
    required this.supported,
    required this.eligible,
  });

  factory DigitalNfcSetupResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DigitalNfcSetupResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DigitalNfcSetupResponseModelToJson(this);
}
