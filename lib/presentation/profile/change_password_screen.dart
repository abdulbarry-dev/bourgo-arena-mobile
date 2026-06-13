import 'package:bourgo_arena_mobile/domain/usecases/auth/update_password_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import '../common/widgets/app_toast.dart';
import 'package:bourgo_arena_mobile/presentation/profile/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for changing the user's password.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final ChangePasswordViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChangePasswordViewModel(
      updatePasswordUseCase: locator<UpdatePasswordUseCase>(),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await _viewModel.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        if (success) {
          AppToast.show(
            context,
            AppLocalizations.of(context)!.passwordUpdateSuccess,
            type: AppToastType.success,
          );
          context.pop();
        } else {
          AppToast.show(
            context,
            AppLocalizations.of(context)!.errorUpdatingPassword,
            type: AppToastType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.passwordChangeTitle.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: appColors.bgElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: appColors.bgBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: appColors.brandPrimaryGhost,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Symbols.lock_reset,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                l10n.authNewPasswordSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        AuthTextField(
                          controller: _currentPasswordController,
                          label: l10n.passwordCurrentLabel,
                          hint: l10n.passwordCurrentHint,
                          leadingIcon: Symbols.lock_open,
                          isPassword: true,
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.commonRequiredField
                              : null,
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          controller: _newPasswordController,
                          label: l10n.authNewPasswordLabel,
                          hint: l10n.authNewPasswordHint,
                          leadingIcon: Symbols.lock,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.commonRequiredField;
                            }
                            if (value.length < 6) {
                              return l10n.authPasswordMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          label: l10n.authConfirmPasswordLabel,
                          hint: l10n.authConfirmPasswordHint,
                          leadingIcon: Symbols.lock_reset,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.commonRequiredField;
                            }
                            if (value != _newPasswordController.text) {
                              return l10n.authPasswordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _viewModel.isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _viewModel.isSaving
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            l10n.profileSave.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
