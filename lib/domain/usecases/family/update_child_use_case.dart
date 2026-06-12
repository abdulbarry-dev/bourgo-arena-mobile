import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/repositories/family_repository.dart';

/// Use case to update an existing child profile.
class UpdateChildUseCase {
  final FamilyRepository _repository;

  UpdateChildUseCase(this._repository);

  Future<Result<ChildProfile, Failure>> execute({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    String? avatarUrl,
    String? avatarFilePath,
  }) {
    return _repository.updateChild(
      id: id,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      gender: gender,
      avatarUrl: avatarUrl,
      avatarFilePath: avatarFilePath,
    );
  }
}
