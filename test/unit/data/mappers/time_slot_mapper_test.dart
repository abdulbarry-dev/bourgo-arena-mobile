import 'package:bourgo_arena_mobile/data/mappers/time_slot_mapper.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart' as entity;
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('TimeSlotMapper', () {
    test('maps a fully populated DTO to an entity', () {
      final dto = testTimeSlotModel();

      final mapped = TimeSlotMapper.toEntity(dto);

      expect(mapped.time, dto.time);
      expect(mapped.available, dto.available);
    });

    test('handles boundary values such as unavailable slots', () {
      final dto = testTimeSlotModel(time: '23:59', available: false);

      final mapped = TimeSlotMapper.toEntity(dto);

      expect(mapped.time, '23:59');
      expect(mapped.available, isFalse);
    });

    test('preserves the time value exactly', () {
      final dto = testTimeSlotModel(time: '06:00');

      final mapped = TimeSlotMapper.toEntity(dto);

      expect(mapped.time, '06:00');
    });

    test('maps an entity back to the DTO', () {
      final slot = entity.TimeSlot(time: '17:30', available: true);

      final dto = TimeSlotMapper.fromEntity(slot);

      expect(dto.time, slot.time);
      expect(dto.available, slot.available);
    });

    test('toEntityList converts a list of DTOs', () {
      final dtos = [
        testTimeSlotModel(time: '08:00'),
        testTimeSlotModel(time: '09:00'),
      ];

      final entities = dtos.toEntityList();

      expect(entities.length, 2);
      expect(entities[0].time, '08:00');
      expect(entities[1].time, '09:00');
    });
  });
}
