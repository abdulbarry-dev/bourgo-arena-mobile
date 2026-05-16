import 'package:bourgo_arena_mobile/data/models/verification_status_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';

/// Mapper to convert [VerificationStatusModel] to [VerificationStatus] and vice-versa.
class VerificationMapper {
  /// Converts [VerificationStatusModel] to [VerificationStatus].
  static VerificationStatus toEntity(VerificationStatusModel model) {
    return VerificationStatus(
      emailVerified: model.emailVerified,
      phoneVerified: model.phoneVerified,
      onboardingCompleted: model.onboardingCompleted,
      isFullyVerified: model.isFullyVerified,
      email: model.email,
      phone: model.phone,
      unverifiedMethod: model.unverifiedMethod,
    );
  }

  /// Converts [VerificationStatus] to [VerificationStatusModel].
  static VerificationStatusModel fromEntity(VerificationStatus entity) {
    return VerificationStatusModel(
      emailVerified: entity.emailVerified,
      phoneVerified: entity.phoneVerified,
      onboardingCompleted: entity.onboardingCompleted,
      isFullyVerified: entity.isFullyVerified,
      email: entity.email,
      phone: entity.phone,
      unverifiedMethod: entity.unverifiedMethod,
    );
  }
}
