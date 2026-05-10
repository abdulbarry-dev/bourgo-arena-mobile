import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:test/test.dart';

void main() {
  group('TimeSlotModel', () {
    const model = TimeSlotModel(time: '18:00', available: true);

    const json = {'time': '18:00', 'available': true};

    test('should correctly deserialize from JSON', () {
      final result = TimeSlotModel.fromJson(json);

      expect(result.time, model.time);
      expect(result.available, model.available);
    });

    test('should correctly serialize to JSON', () {
      final result = model.toJson();

      expect(result['time'], json['time']);
      expect(result['available'], json['available']);
    });
  });
}
