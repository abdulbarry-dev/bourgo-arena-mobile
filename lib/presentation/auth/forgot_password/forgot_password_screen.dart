import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The forgot password screen for Bourgo Arena.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final ForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ForgotPasswordViewModel(locator<ForgotPasswordUseCase>());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthHeader(
                        title: AppLocalizations.of(
                          context,
                        )!.authForgotPasswordTitle,
                        subtitle: AppLocalizations.of(
                          context,
                        )!.authForgotPasswordSubtitle,
                      ),
                      const SizedBox(height: 48),
                      AuthTextField(
                        label: AppLocalizations.of(
                          context,
                        )!.authIdentifierLabel,
                        hint: AppLocalizations.of(context)!.authEmailHint,
                        leadingIcon: Symbols.mail,
                        controller: _viewModel.identifierController,
                        validator: (value) => value?.isEmpty ?? true
                            ? AppLocalizations.of(context)!.commonRequiredField
                            : null,
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: _viewModel.isLoading
                            ? null
                            : () => _viewModel.sendCode(context),
                        child: _viewModel.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              )
                            : Text(AppLocalizations.of(context)!.authSendCode),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
