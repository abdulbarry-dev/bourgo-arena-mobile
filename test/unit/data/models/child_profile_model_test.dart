import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:test/test.dart';

void main() {
  group('ChildProfileModel', () {
    test('computed name returns first and last name combined', () {
      final model = ChildProfileModel(
        id: 'child-1',
        firstName: 'John',
        lastName: 'Doe',
        birthDate: DateTime.utc(2020, 1, 1),
      );

      expect(model.name, 'John Doe');
    });

    test('toJson and fromJson should be consistent', () {
      final model = ChildProfileModel(
        id: 'child-1',
        firstName: 'John',
        lastName: 'Doe',
        birthDate: DateTime.utc(2020, 1, 1),
        gender: 'male',
        avatarUrl: 'https://example.com/avatar.png',
      );

      final json = model.toJson();
      final fromJson = ChildProfileModel.fromJson(json);

      expect(fromJson.id, model.id);
      expect(fromJson.firstName, model.firstName);
      expect(fromJson.lastName, model.lastName);
      expect(fromJson.birthDate, model.birthDate);
      expect(fromJson.gender, model.gender);
      expect(fromJson.avatarUrl, model.avatarUrl);
    });
  });
}
