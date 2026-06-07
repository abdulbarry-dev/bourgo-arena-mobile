import 'dart:async';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/register_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_dropdown.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/family_member_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The registration screen for Bourgo Arena.
class RegisterScreen extends StatefulWidget {
  final RegisterUseCase registerUseCase;
  final Map<String, dynamic>? initialData;

  const RegisterScreen({
    super.key,
    required this.registerUseCase,
    this.initialData,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel;
  late final SessionRepository _sessionRepository;

  @override
  void initState() {
    super.initState();
    _sessionRepository = locator<SessionRepository>();
    _viewModel = RegisterViewModel(widget.registerUseCase);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.addListener(_persistDraft);
    _viewModel.firstNameController.addListener(_persistDraft);
    _viewModel.lastNameController.addListener(_persistDraft);
    _viewModel.emailController.addListener(_persistDraft);
    _viewModel.phoneController.addListener(_persistDraft);
    _viewModel.passwordController.addListener(_persistDraft);
    _viewModel.birthDateController.addListener(_persistDraft);

    if (widget.initialData != null) {
      _prefillData();
    }

    _persistDraft();
  }

  void _prefillData() {
    final data = widget.initialData!;
    _viewModel.firstNameController.text = data['firstName'] as String? ?? '';
    _viewModel.lastNameController.text = data['lastName'] as String? ?? '';
    _viewModel.emailController.text = data['email'] as String? ?? '';
    _viewModel.phoneController.text = data['phone'] as String? ?? '';
    if (data['gender'] != null) {
      _viewModel.setGender(data['gender'] as String);
    }
    if (data['birthDate'] != null) {
      final date = data['birthDate'] as DateTime;
      _viewModel.setBirthDate(date);
      _viewModel.birthDateController.text = DateFormat.yMMMd().format(date);
    }
    _viewModel.setParentAccount(data['isParentAccount'] as bool? ?? false);
  }

  @override
  void dispose() {
    _viewModel.firstNameController.removeListener(_persistDraft);
    _viewModel.lastNameController.removeListener(_persistDraft);
    _viewModel.emailController.removeListener(_persistDraft);
    _viewModel.phoneController.removeListener(_persistDraft);
    _viewModel.passwordController.removeListener(_persistDraft);
    _viewModel.birthDateController.removeListener(_persistDraft);
    _viewModel.removeListener(_persistDraft);
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _persistDraft() {
    unawaited(
      _sessionRepository.saveRegistrationDraft({
        'route': '/register',
        'extra': {
          'firstName': _viewModel.firstNameController.text,
          'lastName': _viewModel.lastNameController.text,
          'email': _viewModel.emailController.text,
          'phone': _viewModel.phoneController.text,
          'gender': _viewModel.selectedGender,
          'birthDate': _viewModel.selectedBirthDate,
          'isParentAccount': _viewModel.isParentAccount,
        },
      }),
    );
  }

  void _onViewModelChanged() {
    if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!)));
    }
  }

  void _onRegister() {
    _viewModel.register(
      onSuccess: (data) {
        unawaited(
          _sessionRepository.saveRegistrationDraft({
            'route': data['isParentAccount'] as bool
                ? '/family-onboarding'
                : '/verification-method',
            'extra': data,
          }),
        );
        if (data['isParentAccount'] as bool) {
          context.push('/family-onboarding', extra: data);
        } else {
          context.push('/verification-method', extra: data);
        }
      },
    );
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
      _persistDraft();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                    children:
                        [
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
                                      hint: l10n.authFirstNameHint,
                                      leadingIcon: Symbols.person,
                                      controller:
                                          _viewModel.firstNameController,
                                      validator: (value) =>
                                          value?.isEmpty ?? true
                                          ? l10n.commonRequiredField
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AuthTextField(
                                      label: l10n.authLastNameLabel,
                                      hint: l10n.authLastNameHint,
                                      leadingIcon: Symbols.person,
                                      controller: _viewModel.lastNameController,
                                      validator: (value) =>
                                          value?.isEmpty ?? true
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
                                hint: l10n.authBirthDateHint,
                                leadingIcon: Symbols.calendar_today,
                                controller: _viewModel.birthDateController,
                                readOnly: true,
                                onTap: _selectBirthDate,
                                validator: (value) => value?.isEmpty ?? true
                                    ? l10n.commonRequiredField
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              AuthDropdown<String>(
                                key: const Key('gender_dropdown'),
                                label: l10n.authGenderLabel,
                                hint: l10n.authGenderHint,
                                leadingIcon: Symbols.person_pin,
                                value: _viewModel.selectedGender,
                                items: [
                                  DropdownMenuItem(
                                    value: 'male',
                                    child: Text(l10n.commonGenderMale),
                                  ),
                                  DropdownMenuItem(
                                    value: 'female',
                                    child: Text(l10n.commonGenderFemale),
                                  ),
                                ],
                                onChanged: _viewModel.setGender,
                                validator: (value) => value == null
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
                              FamilyAccountToggle(
                                value: _viewModel.isParentAccount,
                                onChanged: _viewModel.setParentAccount,
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: _viewModel.isLoading
                                    ? null
                                    : _onRegister,
                                child: _viewModel.isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.colorScheme.onPrimary,
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
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.go('/login'),
                                    child: Text(
                                      l10n.authLogin,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ]
                            .animate(interval: 50.ms)
                            .fade(duration: 300.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
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
