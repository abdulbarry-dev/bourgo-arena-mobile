import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/register_view_model.dart';
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
                    const AuthHeader(
                      title: AppConstants.authRegisterTitle,
                      subtitle: AppConstants.authRegisterSubtitle,
                    ),
                    const SizedBox(height: 32),
                    AuthTextField(
                      label: AppConstants.authFullNameLabel,
                      hint: AppConstants.authFullNameHint,
                      leadingIcon: Symbols.person,
                      controller: _viewModel.nameController,
                      validator: (value) => value?.isEmpty ?? true
                          ? AppConstants.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: AppConstants.authEmailLabel,
                      hint: AppConstants.authEmailLabelHint,
                      leadingIcon: Symbols.mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: _viewModel.emailController,
                      validator: (value) => value?.isEmpty ?? true
                          ? AppConstants.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: AppConstants.authPhoneLabel,
                      hint: AppConstants.authPhoneHint,
                      leadingIcon: Symbols.call,
                      keyboardType: TextInputType.phone,
                      controller: _viewModel.phoneController,
                      validator: (value) => value?.isEmpty ?? true
                          ? AppConstants.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: AppConstants.authPasswordLabel,
                      hint: AppConstants.authPasswordCreateHint,
                      leadingIcon: Symbols.lock,
                      isPassword: true,
                      controller: _viewModel.passwordController,
                      validator: (value) => (value?.length ?? 0) < 6
                          ? AppConstants.authPasswordMinLength
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
                          : const Text(AppConstants.authRegister),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.authHaveAccount,
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.65 * 255).round()),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            AppConstants.authLogin,
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
