import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Mapper to convert [UserProfileModel] to [User] and vice-versa.
class UserMapper {
  /// Converts [UserProfileModel] to [User].
  static User toEntity(UserProfileModel model) {
    return User(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      avatarUrl: model.avatarUrl,
      loyaltyPoints: model.loyaltyPoints,
      subscriptionLevel: model.subscriptionLevel,
      subscriptionExpiry: model.subscriptionExpiry,
      totalCheckIns: model.totalCheckIns,
    );
  }

  /// Converts [User] to [UserProfileModel].
  static UserProfileModel fromEntity(User entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      loyaltyPoints: entity.loyaltyPoints,
      subscriptionLevel: entity.subscriptionLevel,
      subscriptionExpiry: entity.subscriptionExpiry,
      totalCheckIns: entity.totalCheckIns,
    );
  }
}
