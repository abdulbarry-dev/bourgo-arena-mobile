import 'package:bourgo_arena_mobile/data/mappers/activity_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('ActivityMapper', () {
    test('maps a fully populated DTO to an entity', () {
      final dto = testActivityModel();

      final entity = ActivityMapper.toEntity(dto);

      expect(entity.id, dto.id);
      expect(entity.title, dto.title);
      expect(entity.category, dto.category);
      expect(entity.basePrice, dto.basePrice);
      expect(entity.currency, dto.currency);
      expect(entity.imageUrl, dto.imageUrl);
      expect(entity.icon, dto.icon);
      expect(entity.description, dto.description);
      expect(entity.features, dto.features);
      expect(entity.rating, dto.rating);
      expect(entity.reviewCount, dto.reviewCount);
    });

    test('handles nullable and optional-equivalent values via defaults', () {
      final dto = testActivityModel(
        rating: 0.0,
        reviewCount: 0,
        features: const [],
      );

      final entity = ActivityMapper.toEntity(dto);

      expect(entity.features, isEmpty);
      expect(entity.rating, 0.0);
      expect(entity.reviewCount, 0);
    });

    test('uses model defaults when values are not explicitly provided', () {
      const dto = ActivityModel(
        id: 'default-1',
        title: 'Default Activity',
        category: 'Test',
        basePrice: 10.0,
        currency: 'USD',
        imageUrl: '',
        icon: '',
        description: '',
        features: [],
      );

      final entity = ActivityMapper.toEntity(dto);

      expect(entity.rating, 0.0);
      expect(entity.reviewCount, 0);
    });

    test('preserves renamed backend fields unchanged', () {
      final dto = testActivityModel(icon: 'sports_tennis');

      final entity = ActivityMapper.toEntity(dto);

      expect(entity.icon, 'sports_tennis');
    });

    test('maps an entity back to the DTO', () {
      final entity = Activity(
        id: 'activity-9',
        title: 'Tennis',
        name: 'Tennis',
        category: 'Outdoor',
        basePrice: 45.5,
        currency: 'EUR',
        imageUrl: 'https://example.com/tennis.png',
        images: ['https://example.com/tennis.png'],
        icon: 'sports_tennis',
        description: 'Court booking',
        features: const ['Rackets included'],
        rating: 4.2,
        reviewCount: 7,
      );

      final dto = ActivityMapper.fromEntity(entity);

      expect(dto.id, entity.id);
      expect(dto.icon, entity.icon);
      expect(dto.features, entity.features);
    });

    test('toEntityList converts a list of DTOs', () {
      final dtos = [testActivityModel(id: 'a1'), testActivityModel(id: 'a2')];

      final entities = dtos.toEntityList();

      expect(entities.length, 2);
      expect(entities[0].id, 'a1');
      expect(entities[1].id, 'a2');
    });
  });
}
