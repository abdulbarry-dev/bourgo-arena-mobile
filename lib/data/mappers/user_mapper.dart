import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Mapper to convert [UserProfileModel] to [User] and vice-versa.
class UserMapper {
  /// Converts [UserProfileModel] to [User].
  static User toEntity(UserProfileModel model) {
    final nameParts = model.name.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return User(
      id: model.id,
      firstName: firstName,
      lastName: lastName,
      email: model.email,
      phone: model.phone,
      avatarUrl: model.avatarUrl ?? '',
      loyaltyPoints: model.loyaltyPoints,
      subscriptionLevel: model.subscriptionLevel,
      subscriptionExpiry: model.subscriptionExpiry ?? '',
      totalCheckIns: model.totalCheckIns,
      birthDate: model.birthDate,
      isParentAccount: model.isParentAccount,
      children: model.children.map((m) => ChildMapper.toEntity(m)).toList(),
    );
  }

  /// Converts [User] to [UserProfileModel].
  static UserProfileModel fromEntity(User entity) {
    return UserProfileModel(
      id: entity.id,
      name: '${entity.firstName} ${entity.lastName}'.trim(),
      email: entity.email,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      loyaltyPoints: entity.loyaltyPoints,
      subscriptionLevel: entity.subscriptionLevel,
      subscriptionExpiry: entity.subscriptionExpiry,
      totalCheckIns: entity.totalCheckIns,
      birthDate: entity.birthDate,
      isParentAccount: entity.isParentAccount,
      children: entity.children.map((e) => ChildMapper.fromEntity(e)).toList(),
    );
  }
}

/// Mapper to convert [ChildProfileModel] to [ChildProfile] and vice-versa.
class ChildMapper {
  /// Converts [ChildProfileModel] to [ChildProfile].
  static ChildProfile toEntity(ChildProfileModel model) {
    return ChildProfile(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      birthDate: model.birthDate,
      gender: model.gender,
      avatarUrl: model.avatarUrl,
    );
  }

  /// Converts [ChildProfile] to [ChildProfileModel].
  static ChildProfileModel fromEntity(ChildProfile entity) {
    return ChildProfileModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      birthDate: entity.birthDate,
      gender: entity.gender,
      avatarUrl: entity.avatarUrl,
    );
  }
}
