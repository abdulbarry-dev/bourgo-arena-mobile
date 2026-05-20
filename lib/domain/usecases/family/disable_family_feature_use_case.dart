import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Use case for disabling the family account feature.
class DisableFamilyFeatureUseCase {
  final FamilyRepository _familyRepository;

  DisableFamilyFeatureUseCase(this._familyRepository);

  /// Executes the use case to disable the family feature.
  Future<Result<void, Failure>> call() async {
    return _familyRepository.disableFamilyFeature();
  }
}
