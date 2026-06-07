import 'dart:convert';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('SubscriptionModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = SubscriptionModel(
        id: 'sub-1',
        planName: 'Premium',
        status: 'active',
        daysRemaining: 30,
        amountPaid: 99.99,
      );

      final json = model.toJson();
      final encoded = jsonEncode(json);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;

      final fromJson = SubscriptionModel.fromJson(decoded);

      check(fromJson.id).equals(model.id);
      check(fromJson.planName).equals(model.planName);
      check(fromJson.status).equals(model.status);
      check(fromJson.daysRemaining).equals(model.daysRemaining);
      check(fromJson.amountPaid).equals(model.amountPaid);
    });
  });
}
