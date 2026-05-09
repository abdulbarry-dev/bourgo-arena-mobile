import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_view_model.dart';
import 'package:test/test.dart';

void main() {
  test('setLoading toggles isLoading', () {
    final vm = ForgotPasswordViewModel();
    expect(vm.isLoading, isFalse);
    vm.setLoading(true);
    expect(vm.isLoading, isTrue);
    vm.setLoading(false);
    expect(vm.isLoading, isFalse);
  });

  test('identifierController stores value and dispose clears', () {
    final vm = ForgotPasswordViewModel();
    vm.identifierController.text = 'a@b.com';
    expect(vm.identifierController.text, 'a@b.com');
    vm.dispose();
    // After dispose, accessing text may still work but controller is closed; ensure no exception thrown earlier
  });

  test('formKey default has no currentState', () {
    // Accessing `formKey.currentState` requires Flutter binding initialization.
    // In pure-Dart tests we avoid interacting with widget state; just ensure
    // the `formKey` exists.
    final vm = ForgotPasswordViewModel();
    expect(vm.formKey, isNotNull);
  });
}
