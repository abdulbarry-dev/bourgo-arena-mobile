import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:test/test.dart';

void main() {
  group('UserProfileModel', () {
    final birthDate = DateTime(1990, 1, 1);
    final children = [
      ChildProfileModel(
        id: 'c1',
        firstName: 'John',
        lastName: 'Doe',
        birthDate: DateTime.utc(2015, 5, 5),
      ),
    ];

    final model = UserProfileModel(
      id: 'u1',
      name: 'Jane Doe',
      email: 'jane@example.com',
      phone: '123456789',
      avatarUrl: 'https://example.com/avatar.png',
      loyaltyPoints: 100,
      subscriptionLevel: 'Premium',
      subscriptionExpiry: '2024-12-31',
      totalCheckIns: 50,
      birthDate: birthDate,
      isParentAccount: true,
      children: children,
    );

    final json = {
      'id': 'u1',
      'name': 'Jane Doe',
      'email': 'jane@example.com',
      'phone': '123456789',
      'avatar_url': 'https://example.com/avatar.png',
      'loyalty_points': 100,
      'subscription_level': 'Premium',
      'subscription_expiry': '2024-12-31',
      'total_check_ins': 50,
      'birth_date': birthDate.toIso8601String(),
      'is_parent_account': true,
      'children': [
        {
          'id': 'c1',
          'first_name': 'John',
          'last_name': 'Doe',
          'birth_date': '2015-05-05',
        },
      ],
    };

    test('should correctly deserialize from JSON', () {
      final result = UserProfileModel.fromJson(json);

      expect(result.id, model.id);
      expect(result.name, model.name);
      expect(result.email, model.email);
      expect(result.phone, model.phone);
      expect(result.avatarUrl, model.avatarUrl);
      expect(result.loyaltyPoints, model.loyaltyPoints);
      expect(result.subscriptionLevel, model.subscriptionLevel);
      expect(result.subscriptionExpiry, model.subscriptionExpiry);
      expect(result.totalCheckIns, model.totalCheckIns);
      expect(result.birthDate, model.birthDate);
      expect(result.isParentAccount, model.isParentAccount);
      expect(result.children.length, 1);
      expect(result.children.first.id, 'c1');
    });

    test('should correctly serialize to JSON', () {
      final result = model.toJson();

      expect(result['id'], json['id']);
      expect(result['name'], json['name']);
      expect(result['email'], json['email']);
      expect(result['phone'], json['phone']);
      expect(result['avatar_url'], json['avatar_url']);
      expect(result['loyalty_points'], json['loyalty_points']);
      expect(result['subscription_level'], json['subscription_level']);
      expect(result['subscription_expiry'], json['subscription_expiry']);
      expect(result['total_check_ins'], json['total_check_ins']);
      expect(result['birth_date'], json['birth_date']);
      expect(result['is_parent_account'], json['is_parent_account']);
      expect(result['children'], isA<List>());
    });

    test('should handle nullable fields correctly', () {
      const minimalJson = {
        'id': 'u1',
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'phone': '123456789',
        'loyalty_points': 0,
        'subscription_level': 'Basic',
        'total_check_ins': 0,
      };

      final result = UserProfileModel.fromJson(minimalJson);

      expect(result.avatarUrl, isNull);
      expect(result.subscriptionExpiry, isNull);
      expect(result.birthDate, isNull);
      expect(result.isParentAccount, isFalse);
      expect(result.children, isEmpty);
    });
  });
}
