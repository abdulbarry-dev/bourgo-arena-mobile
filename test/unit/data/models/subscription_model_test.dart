import 'dart:convert';
import 'package:bourgo_arena_mobile/data/models/plan_model.dart';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('SubscriptionModel', () {
    test('toJson and fromJson should be consistent', () {
      const plan = PlanModel(id: 'plan-1', name: 'Premium', price: 99.99);
      const model = SubscriptionModel(
        id: 'sub-1',
        plan: plan,
        status: 'active',
        daysRemaining: 30,
        amountPaid: 99.99,
      );

      final json = model.toJson();
      final encoded = jsonEncode(json);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;

      final fromJson = SubscriptionModel.fromJson(decoded);

      check(fromJson.id).equals(model.id);
      check(fromJson.plan?.name).equals(model.plan?.name);
      check(fromJson.status).equals(model.status);
      check(fromJson.daysRemaining).equals(model.daysRemaining);
      check(fromJson.amountPaid).equals(model.amountPaid);
    });
  });
}
