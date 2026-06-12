import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Use case to add a new child profile to the family.
class AddChildUseCase {
  final FamilyRepository _repository;

  AddChildUseCase(this._repository);

  Future<Result<ChildProfile, Failure>> execute({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
    String? avatarFilePath,
  }) {
    return _repository.addChild(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      gender: gender,
      avatarUrl: avatarUrl,
      avatarFilePath: avatarFilePath,
    );
  }
}
