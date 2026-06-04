import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/viewmodels/login_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The login screen for Bourgo Arena.
class LoginScreen extends StatefulWidget {
  final LoginUseCase loginUseCase;
  final SessionRepository sessionRepository;

  const LoginScreen({
    super.key,
    required this.loginUseCase,
    required this.sessionRepository,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(widget.loginUseCase, widget.sessionRepository);
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final spacing = context.spacing;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: spacing.screenPadding(context),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Form(
                            key: _viewModel.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthHeader(
                                  title: l10n.authLoginTitle,
                                  subtitle: l10n.authLoginSubtitle,
                                ),
                                SizedBox(height: spacing.xxxl),
                                AuthTextField(
                                  label: l10n.authIdentifierLabel,
                                  hint: l10n.authEmailHint,
                                  leadingIcon: Symbols.person,
                                  controller: _viewModel.identifierController,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? l10n.commonRequiredField
                                      : null,
                                ),
                                SizedBox(height: spacing.lg),
                                AuthTextField(
                                  label: l10n.authPasswordLabel,
                                  hint: l10n.authPasswordHint,
                                  leadingIcon: Symbols.lock,
                                  isPassword: true,
                                  controller: _viewModel.passwordController,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? l10n.commonRequiredField
                                      : null,
                                ),
                                SizedBox(height: spacing.sm),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value:
                                                _viewModel.isRememberMeChecked,
                                            onChanged:
                                                _viewModel.toggleRememberMe,
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            activeColor:
                                                theme.colorScheme.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          SizedBox(width: spacing.xs),
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _viewModel.toggleRememberMe(
                                                    !_viewModel
                                                        .isRememberMeChecked,
                                                  ),
                                              child: Text(
                                                l10n.authRememberMe,
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          context.push('/forgot-password'),
                                      child: Text(
                                        l10n.authForgotPassword,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: spacing.xl),
                                ElevatedButton(
                                  onPressed: _viewModel.isLoading
                                      ? null
                                      : () => _viewModel.login(context),
                                  child: _viewModel.isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        )
                                      : Text(l10n.authLogin),
                                ),
                                SizedBox(height: spacing.lg),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      l10n.authNoAccount,
                                      style: TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => context.go('/register'),
                                      child: Text(
                                        l10n.authRegister,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
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
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
