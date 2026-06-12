import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Use case for enabling the family account feature.
///
/// This use case coordinates the operation with the family repository
/// to enable the family-specific features for a verified parent account.
class EnableFamilyFeatureUseCase {
  final FamilyRepository _familyRepository;

  /// Creates a [EnableFamilyFeatureUseCase] with the required repository.
  EnableFamilyFeatureUseCase(this._familyRepository);

  /// Executes the use case to enable the family feature.
  ///
  /// Returns a [Result] indicating success or failure of the operation.
  Future<Result<bool, Failure>> call() async {
    return _familyRepository.enableFamilyFeature();
  }
}
