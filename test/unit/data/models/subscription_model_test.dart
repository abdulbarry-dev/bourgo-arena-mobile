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
        benefits: ['Feature A', 'Feature B'],
        durationMonths: 12,
      );

      final json = model.toJson();
      final fromJson = SubscriptionModel.fromJson(json);

      check(fromJson.id).equals(model.id);
      check(fromJson.name).equals(model.name);
      check(fromJson.price).equals(model.price);
      check(fromJson.benefits).deepEquals(model.benefits);
      check(fromJson.durationMonths).equals(model.durationMonths);
    });
  });
}
