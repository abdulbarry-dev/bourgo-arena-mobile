import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/onboarding_setup_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the Login screen.
class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final SessionRepository _sessionRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRememberMeChecked = false;
  bool get isRememberMeChecked => _isRememberMeChecked;

  LoginViewModel(this._loginUseCase, this._sessionRepository);

  /// Initializes the ViewModel by loading the remembered identifier if any.
  Future<void> initialize() async {
    final result = await _sessionRepository.getRememberedIdentifier();
    result.when(
      success: (identifier) {
        if (identifier != null && identifier.isNotEmpty) {
          identifierController.text = identifier;
          _isRememberMeChecked = true;
          notifyListeners();
        }
      },
      failure: (_) {},
    );
  }

  void toggleRememberMe(bool? value) {
    _isRememberMeChecked = value ?? false;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (_isLoading) return;
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);

      final result = await _loginUseCase(
        identifierController.text,
        passwordController.text,
      );

      setLoading(false);

      result.fold(
        onFailure: (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.message)));
          }
        },
        onSuccess: (session) async {
          if (_isRememberMeChecked) {
            await _sessionRepository.saveRememberedIdentifier(
              identifierController.text,
            );
          } else {
            await _sessionRepository.clearRememberedIdentifier();
          }

          if (session.state == AuthState.pendingOnboarding && context.mounted) {
            final shouldComplete = await OnboardingSetupModal.show(context);
            if (shouldComplete == true && context.mounted) {
              context.push('/account-setup');
            }
          }
          // Note: For other states, GoRouter redirect in router.dart will handle navigation
        },
      );
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
