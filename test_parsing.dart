import 'dart:convert';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:bourgo_arena_mobile/data/mappers/subscription_mapper.dart';

void main() {
  final Map<String, dynamic> responseMap = {
    "success": true,
    "message": "No active subscription",
    "data": null,
  };

  final dataToParse =
      responseMap.containsKey('data') && responseMap['data'] != null
      ? responseMap['data'] as Map<String, dynamic>
      : responseMap;

  if (dataToParse['id'] == null) {
    print('id is null, returning null');
  } else {
    print('id is not null');
    final model = SubscriptionModel.fromJson(dataToParse);
    final entity = SubscriptionMapper.toEntity(model);
    print(entity.planName);
  }
}
