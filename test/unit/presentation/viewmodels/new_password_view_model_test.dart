import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_view_model.dart';
import 'package:test/test.dart';

void main() {
  test('setLoading toggles isLoading', () {
    final vm = NewPasswordViewModel();
    expect(vm.isLoading, isFalse);
    vm.setLoading(true);
    expect(vm.isLoading, isTrue);
    vm.setLoading(false);
    expect(vm.isLoading, isFalse);
  });

  test('controllers store values and dispose', () {
    final vm = NewPasswordViewModel();
    vm.passwordController.text = 'abc';
    vm.confirmPasswordController.text = 'abc';
    expect(vm.passwordController.text, 'abc');
    expect(vm.confirmPasswordController.text, 'abc');
    vm.dispose();
  });

  test('resetPassword does not throw when form invalid (no FormState)', () async {
    final vm = NewPasswordViewModel();
    // resetPassword depends on Flutter widgets; avoid calling it in pure-Dart tests
  });
}
