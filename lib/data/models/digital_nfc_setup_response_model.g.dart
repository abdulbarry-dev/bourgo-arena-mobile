// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_nfc_setup_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalNfcSetupResponseModel _$DigitalNfcSetupResponseModelFromJson(
  Map<String, dynamic> json,
) => DigitalNfcSetupResponseModel(
  setupStatus: json['setup_status'] as String,
  supported: json['supported'] as bool,
  eligible: json['eligible'] as bool,
);

Map<String, dynamic> _$DigitalNfcSetupResponseModelToJson(
  DigitalNfcSetupResponseModel instance,
) => <String, dynamic>{
  'setup_status': instance.setupStatus,
  'supported': instance.supported,
  'eligible': instance.eligible,
};
