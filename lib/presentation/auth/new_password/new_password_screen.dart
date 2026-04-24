import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The new password screen for Bourgo Arena.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late final NewPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NewPasswordViewModel();
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
                      title: 'Nouveau mot de passe',
                      subtitle:
                          'Créez un nouveau mot de passe sécurisé pour votre compte.',
                    ),
                    const SizedBox(height: 48),
                    AuthTextField(
                      label: 'Nouveau mot de passe',
                      hint: 'Entrez le nouveau mot de passe',
                      leadingIcon: Symbols.lock,
                      isPassword: true,
                      controller: _viewModel.passwordController,
                      validator: (value) =>
                          (value?.length ?? 0) < 6 ? 'Min 6 caractères' : null,
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      label: 'Confirmer le mot de passe',
                      hint: 'Répétez le mot de passe',
                      leadingIcon: Symbols.lock,
                      isPassword: true,
                      controller: _viewModel.confirmPasswordController,
                      validator: (value) {
                        if (value != _viewModel.passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () => _viewModel.resetPassword(context),
                      child: _viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text('RÉINITIALISER'),
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
