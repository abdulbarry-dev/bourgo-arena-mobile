import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:test/test.dart';

void main() {
  group('ActivityModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = ActivityModel(
        id: 'activity-1',
        title: 'Football',
        category: 'Sports',
        basePrice: 50.0,
        currency: 'EUR',
        imageUrl: 'https://example.com/football.png',
        icon: 'sports_soccer',
        description: 'Football session',
        features: ['Pitch', 'Balls'],
        rating: 4.5,
        reviewCount: 10,
      );

      final json = model.toJson();
      final fromJson = ActivityModel.fromJson(json);

      expect(fromJson.id, model.id);
      expect(fromJson.title, model.title);
      expect(fromJson.category, model.category);
      expect(fromJson.basePrice, model.basePrice);
      expect(fromJson.currency, model.currency);
      expect(fromJson.imageUrl, model.imageUrl);
      expect(fromJson.icon, model.icon);
      expect(fromJson.description, model.description);
      expect(fromJson.features, model.features);
      expect(fromJson.rating, model.rating);
      expect(fromJson.reviewCount, model.reviewCount);
    });

    test(
      'should use default values when rating and reviewCount are missing',
      () {
        final json = {
          'id': 'activity-1',
          'title': 'Football',
          'category': 'Sports',
          'base_price': 50.0,
          'currency': 'EUR',
          'image_url': 'https://example.com/football.png',
          'icon': 'sports_soccer',
          'description': 'Football session',
          'features': ['Pitch', 'Balls'],
        };

        final fromJson = ActivityModel.fromJson(json);

        expect(fromJson.rating, 0.0);
        expect(fromJson.reviewCount, 0);
      },
    );
  });
}
