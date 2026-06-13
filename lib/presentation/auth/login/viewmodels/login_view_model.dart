import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/onboarding_setup_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_toast.dart';

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

  bool _disposed = false;

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
    if (_disposed) return;
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

      if (context.mounted) {
        setLoading(false);
      }

      result.fold(
        onFailure: (failure) {
          if (context.mounted) {
            AppToast.show(context, failure.message, type: AppToastType.error);
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
              context.push(
                '/account-setup',
                extra: _buildOnboardingData(session),
              );
            }
          } else if (session.state == AuthState.authenticated &&
              context.mounted) {
            // Force navigation to home to prevent being stuck on login screen
            context.go('/home');
          }
          // Note: For other states (verification, etc.), GoRouter redirect will handle it
        },
      );
    }
  }

  Map<String, dynamic> _buildOnboardingData(AuthSession session) {
    final user = session.user;

    return {
      'firstName': user?.firstName ?? '',
      'lastName': user?.lastName ?? '',
      'email': user?.email ?? identifierController.text.trim(),
      'phone': user?.phone ?? '',
      'gender': user?.gender,
      'birthDate': user?.birthDate,
      'isParentAccount': user?.isParentAccount ?? false,
      'familyMembers': user?.children ?? const [],
    };
  }

  @override
  void dispose() {
    _disposed = true;
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
