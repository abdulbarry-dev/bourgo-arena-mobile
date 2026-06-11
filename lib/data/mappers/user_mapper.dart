import 'package:bourgo_arena_mobile/data/mappers/subscription_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Mapper to convert [UserProfileModel] to [User] and vice-versa.
class UserMapper {
  /// Converts [UserProfileModel] to [User].
  static User toEntity(UserProfileModel model) {
    return User(
      id: model.id,
      firstName: model.firstName ?? model.name?.split(' ').first ?? '',
      lastName:
          model.lastName ??
          (model.name != null && model.name!.split(' ').length > 1
              ? model.name!.split(' ').sublist(1).join(' ')
              : ''),
      email: model.email,
      phone: model.phone,
      avatarUrl: model.avatarUrl,
      loyaltyPoints: model.loyaltyPoints,
      subscriptionLevel: model.subscriptionLevel,
      subscriptionExpiry: model.subscriptionExpiry,
      birthDate: model.birthDate,
      gender: model.gender,
      status: model.status ?? 'active',
      state: model.state ?? 'active',
      isParentAccount: model.isParentAccount,
      children: model.children.map((m) => ChildMapper.toEntity(m)).toList(),
      preferences: model.preferences,
    );
  }

  /// Converts [User] to [UserProfileModel].
  static UserProfileModel fromEntity(User entity) {
    return UserProfileModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      name: '${entity.firstName} ${entity.lastName}'.trim(),
      email: entity.email,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      loyaltyPoints: entity.loyaltyPoints,
      subscriptionLevel: entity.subscriptionLevel,
      subscriptionExpiry: entity.subscriptionExpiry,
      birthDate: entity.birthDate,
      gender: entity.gender,
      status: entity.status,
      state: entity.state,
      isParentAccount: entity.isParentAccount,
      children: entity.children.map((e) => ChildMapper.fromEntity(e)).toList(),
      preferences: entity.preferences,
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
      status: model.status ?? 'active',
      isArchived: model.isArchived ?? false,
      hasActiveSubscription: model.hasActiveSubscription ?? false,
      activeSubscription: model.activeSubscription != null
          ? SubscriptionMapper.toEntity(model.activeSubscription!)
          : null,
      createdAt: model.createdAt != null
          ? DateTime.tryParse(model.createdAt!)
          : null,
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
      status: entity.status,
      isArchived: entity.isArchived,
      hasActiveSubscription: entity.hasActiveSubscription,
      activeSubscription: entity.activeSubscription != null
          ? SubscriptionMapper.fromEntity(entity.activeSubscription!)
          : null,
      createdAt: entity.createdAt?.toIso8601String(),
    );
  }
}
