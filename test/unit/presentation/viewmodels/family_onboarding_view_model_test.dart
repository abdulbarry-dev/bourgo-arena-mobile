import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/family_onboarding_view_model.dart';
import 'package:test/test.dart';

void main() {
  test('setBirthDate and setGender update state', () {
    final vm = FamilyOnboardingViewModel();
    expect(vm.selectedBirthDate, isNull);
    vm.setBirthDate(DateTime(2020, 1, 1));
    expect(vm.selectedBirthDate, isNotNull);
    expect(vm.selectedBirthDate?.year, 2020);

    expect(vm.selectedGender, isNull);
    vm.setGender('male');
    expect(vm.selectedGender, 'male');
  });

  test('addMember validation prevents adding when fields missing', () {
    final vm = FamilyOnboardingViewModel();
    vm.addMember();
    expect(vm.members, isEmpty);
  });

  test('addMember adds member when form valid and can remove', () {
    final vm = FamilyOnboardingViewModel();
    vm.firstNameController.text = 'A';
    vm.lastNameController.text = 'B';
    vm.setBirthDate(DateTime(2018, 1, 1));
    vm.setGender('female');
    vm.addMember();
    expect(vm.members.length, 1);
    vm.removeMember(0);
    expect(vm.members, isEmpty);
  });
}
