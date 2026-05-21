import 'package:json_annotation/json_annotation.dart';

part 'physical_nfc_status_model.g.dart';

/// Data transfer object for the physical NFC card status.
@JsonSerializable(fieldRename: FieldRename.snake)
class PhysicalNfcStatusModel {
  final bool hasCard;
  final String? cardUid;
  final String? cardStatus;
  final bool isReady;
  final List<String> fallbackMethods;

  const PhysicalNfcStatusModel({
    required this.hasCard,
    this.cardUid,
    this.cardStatus,
    required this.isReady,
    this.fallbackMethods = const [],
  });

  factory PhysicalNfcStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PhysicalNfcStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalNfcStatusModelToJson(this);
}
