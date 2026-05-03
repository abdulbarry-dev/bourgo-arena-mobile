import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/register_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The registration screen for Bourgo Arena.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      title: AppLocalizations.of(context)!.authRegisterTitle,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.authRegisterSubtitle,
                    ),
                    const SizedBox(height: 32),
                    AuthTextField(
                      label: AppLocalizations.of(context)!.authFullNameLabel,
                      hint: AppLocalizations.of(context)!.authFullNameHint,
                      leadingIcon: Symbols.person,
                      controller: _viewModel.nameController,
                      validator: (value) => value?.isEmpty ?? true
                          ? AppLocalizations.of(context)!.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: AppLocalizations.of(context)!.authEmailLabel,
                      hint: AppLocalizations.of(context)!.authEmailLabelHint,
                      leadingIcon: Symbols.mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: _viewModel.emailController,
                      validator: (value) => value?.isEmpty ?? true
                          ? AppLocalizations.of(context)!.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: AppLocalizations.of(context)!.authPhoneLabel,
                      hint: AppLocalizations.of(context)!.authPhoneHint,
                      leadingIcon: Symbols.call,
                      keyboardType: TextInputType.phone,
                      controller: _viewModel.phoneController,
                      validator: (value) => value?.isEmpty ?? true
                          ? AppLocalizations.of(context)!.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: AppLocalizations.of(context)!.authPasswordLabel,
                      hint: AppLocalizations.of(
                        context,
                      )!.authPasswordCreateHint,
                      leadingIcon: Symbols.lock,
                      isPassword: true,
                      controller: _viewModel.passwordController,
                      validator: (value) => (value?.length ?? 0) < 6
                          ? AppLocalizations.of(context)!.authPasswordMinLength
                          : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () => _viewModel.register(context),
                      child: _viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(AppLocalizations.of(context)!.authRegister),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.authHaveAccount,
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.65 * 255).round()),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            AppLocalizations.of(context)!.authLogin,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
