import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:test/test.dart';

import 'mapper_test_fixtures.dart';

void main() {
  group('UserMapper', () {
    test('maps a fully populated DTO to an entity', () {
      final dto = testUserProfileModel(
        birthDate: DateTime.utc(1990, 1, 15),
        children: [
          testChildProfileModel(
            id: 'child-2',
            firstName: 'Noah',
            lastName: 'Morgan',
            birthDate: DateTime.utc(2018, 3, 2),
          ),
        ],
      );

      final entity = UserMapper.toEntity(dto);

      expect(entity.id, dto.id);
      expect(entity.firstName, 'Alex');
      expect(entity.lastName, 'Morgan');
      expect(entity.email, dto.email);
      expect(entity.phone, dto.phone);
      expect(entity.avatarUrl, dto.avatarUrl);
      expect(entity.loyaltyPoints, dto.loyaltyPoints);
      expect(entity.subscriptionLevel, dto.subscriptionLevel);
      expect(entity.subscriptionExpiry, dto.subscriptionExpiry);
      expect(entity.totalCheckIns, dto.totalCheckIns);
      expect(entity.birthDate, dto.birthDate);
      expect(entity.isParentAccount, dto.isParentAccount);
      expect(entity.children, hasLength(1));
      expect(entity.children.first, isA<ChildProfile>());
      expect(entity.children.first.firstName, 'Noah');
      expect(entity.children.first.lastName, 'Morgan');
    });

    test('handles nullable fields and empty collections', () {
      final dto = testUserProfileModel(
        name: 'SingleName',
        avatarUrl: null,
        subscriptionExpiry: null,
        children: const [],
      );

      final entity = UserMapper.toEntity(dto);

      expect(entity.firstName, 'SingleName');
      expect(entity.lastName, '');
      expect(entity.avatarUrl, '');
      expect(entity.subscriptionExpiry, '');
      expect(entity.children, isEmpty);
    });

    test('maps backend name field into first and last name', () {
      final dto = testUserProfileModel(name: 'Mary Jane Watson');

      final entity = UserMapper.toEntity(dto);

      expect(entity.firstName, 'Mary');
      expect(entity.lastName, 'Jane Watson');
    });

    test('maps an entity back to the DTO with the renamed name field', () {
      final entity = User(
        id: 'user-42',
        firstName: 'Jamie',
        lastName: 'Rivera',
        email: 'jamie@example.com',
        phone: '+15550000042',
        avatarUrl: 'https://example.com/jamie.png',
        loyaltyPoints: 321,
        subscriptionLevel: 'gold',
        subscriptionExpiry: '2027-02-01',
        totalCheckIns: 18,
        birthDate: DateTime.utc(1992, 7, 8),
        isParentAccount: true,
        children: [
          ChildProfile(
            id: 'child-1',
            firstName: 'Mia',
            lastName: 'Rivera',
            birthDate: DateTime.utc(2016, 5, 8),
            gender: 'female',
            avatarUrl: 'https://example.com/mia.png',
          ),
        ],
      );

      final dto = UserMapper.fromEntity(entity);

      expect(dto.name, 'Jamie Rivera');
      expect(dto.id, entity.id);
      expect(dto.email, entity.email);
      expect(dto.children, hasLength(1));
      expect(dto.children.first.name, 'Mia Rivera');
    });

    test('maps child profile DTOs with nullable optional fields', () {
      final dto = testChildProfileModel(gender: null, avatarUrl: null);

      final entity = ChildMapper.toEntity(dto);

      expect(entity.id, dto.id);
      expect(entity.firstName, dto.firstName);
      expect(entity.lastName, dto.lastName);
      expect(entity.gender, isNull);
      expect(entity.avatarUrl, isNull);
    });

    test('maps child profiles back to DTOs unchanged', () {
      final entity = ChildProfile(
        id: 'child-99',
        firstName: 'Leo',
        lastName: 'Stone',
        birthDate: DateTime.utc(2017, 6, 1),
        gender: null,
        avatarUrl: null,
      );

      final dto = ChildMapper.fromEntity(entity);

      expect(dto.id, entity.id);
      expect(dto.firstName, entity.firstName);
      expect(dto.lastName, entity.lastName);
      expect(dto.gender, isNull);
      expect(dto.avatarUrl, isNull);
    });
  });
}
