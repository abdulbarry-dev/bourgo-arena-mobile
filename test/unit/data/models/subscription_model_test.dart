import 'dart:convert';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('SubscriptionModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = SubscriptionModel(
        id: 'sub-1',
        name: 'Premium',
        price: 99.99,
        benefits: [
          BenefitModel(label: 'Feature A'),
          BenefitModel(label: 'Feature B'),
        ],
        durationMonths: 12,
      );

      final json = model.toJson();
      // Ensure nested objects are actually maps, not instances, as fromJson expects Map<String, dynamic>
      // json_serializable's toJson returns a map where nested lists might still contain objects
      // depending on configuration. We force a re-encoding/decoding to simulate real JSON boundary.
      final encoded = jsonEncode(json);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;

      final fromJson = SubscriptionModel.fromJson(decoded);

      check(fromJson.id).equals(model.id);
      check(fromJson.name).equals(model.name);
      check(fromJson.price).equals(model.price);
      check(fromJson.benefits).length.equals(2);
      check(fromJson.benefits.first.label).equals('Feature A');
      check(fromJson.durationMonths).equals(model.durationMonths);
    });
  });
}
