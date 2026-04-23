import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    _viewModel = ForgotPasswordViewModel();
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
                      title: 'Mot de passe oublié',
                      subtitle: 'Ne vous inquiétez pas ! Entrez votre e-mail ou numéro pour recevoir un code.',
                    ),
                    const SizedBox(height: 48),
                    AuthTextField(
                      label: 'E-mail ou Téléphone',
                      hint: 'Entrez votre identifiant',
                      leadingIcon: Symbols.mail,
                      controller: _viewModel.identifierController,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () {
                              _viewModel.sendCode(context);
                              // For now, manual navigation for demo
                              context.push('/otp');
                            },
                      child: _viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text('ENVOYER LE CODE'),
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
