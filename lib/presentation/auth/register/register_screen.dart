import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/register_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _viewModel.selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _viewModel.setBirthDate(picked);
      _viewModel.birthDateController.text = DateFormat.yMMMd().format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                      title: l10n.authRegisterTitle,
                      subtitle: l10n.authRegisterSubtitle,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: AuthTextField(
                            label: l10n.authFirstNameLabel,
                            hint: 'First',
                            leadingIcon: Symbols.person,
                            controller: _viewModel.firstNameController,
                            validator: (value) => value?.isEmpty ?? true
                                ? l10n.commonRequiredField
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AuthTextField(
                            label: l10n.authLastNameLabel,
                            hint: 'Last',
                            leadingIcon: Symbols.person,
                            controller: _viewModel.lastNameController,
                            validator: (value) => value?.isEmpty ?? true
                                ? l10n.commonRequiredField
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: l10n.authEmailLabel,
                      hint: l10n.authEmailLabelHint,
                      leadingIcon: Symbols.mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: _viewModel.emailController,
                      validator: (value) => value?.isEmpty ?? true
                          ? l10n.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: l10n.authPhoneLabel,
                      hint: l10n.authPhoneHint,
                      leadingIcon: Symbols.call,
                      keyboardType: TextInputType.phone,
                      controller: _viewModel.phoneController,
                      validator: (value) => value?.isEmpty ?? true
                          ? l10n.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: l10n.authBirthDateLabel,
                      hint: 'Select your birth date',
                      leadingIcon: Symbols.calendar_today,
                      controller: _viewModel.birthDateController,
                      readOnly: true,
                      onTap: _selectBirthDate,
                      validator: (value) => value?.isEmpty ?? true
                          ? l10n.commonRequiredField
                          : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: l10n.authPasswordLabel,
                      hint: l10n.authPasswordCreateHint,
                      leadingIcon: Symbols.lock,
                      isPassword: true,
                      controller: _viewModel.passwordController,
                      validator: (value) => (value?.length ?? 0) < 6
                          ? l10n.authPasswordMinLength
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.profileFamilyAccount,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.profileFamilyAccountDescription,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _viewModel.isParentAccount,
                            onChanged: _viewModel.setParentAccount,
                          ),
                        ],
                      ),
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
                          : Text(l10n.authRegister),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authHaveAccount,
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.65 * 255).round()),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            l10n.authLogin,
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
