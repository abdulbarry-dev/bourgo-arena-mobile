import 'dart:async';

import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/complete_registration_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

/// Screen for account overview and profile picture setup.
class AccountSetupScreen extends StatefulWidget {
  /// Registration data passed from previous steps.
  final Map<String, dynamic> registrationData;

  /// Creates an [AccountSetupScreen].
  const AccountSetupScreen({super.key, required this.registrationData});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  late final Map<String, dynamic> _data;
  late final SessionRepository _sessionRepository;
  bool _isEditing = false;
  bool _isSubmitting = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthDateController;
  String? _selectedGender;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _sessionRepository = locator<SessionRepository>();
    _data = Map<String, dynamic>.from(widget.registrationData);

    // Fallback to AuthStateNotifier if data is missing
    if (_data.isEmpty) {
      final user = locator<AuthStateNotifier>().currentUser;
      if (user != null) {
        _data['firstName'] = user.firstName;
        _data['lastName'] = user.lastName;
        _data['email'] = user.email;
        _data['phone'] = user.phone ?? '';
        _data['gender'] = user.gender;
        _data['birthDate'] = user.birthDate;
        _data['isParentAccount'] = user.isParentAccount;
        _data['familyMembers'] = user.children;
      }
    }

    _firstNameController = TextEditingController(
      text: _data['firstName'] ?? '',
    );
    _lastNameController = TextEditingController(text: _data['lastName'] ?? '');
    _emailController = TextEditingController(text: _data['email'] ?? '');
    _phoneController = TextEditingController(text: _data['phone'] ?? '');

    _selectedBirthDate = _data['birthDate'];
    _selectedGender = _data['gender'];

    _birthDateController = TextEditingController(
      text: _selectedBirthDate != null
          ? DateFormat.yMMMd().format(_selectedBirthDate!)
          : '',
    );

    _firstNameController.addListener(_persistDraft);
    _lastNameController.addListener(_persistDraft);
    _emailController.addListener(_persistDraft);
    _phoneController.addListener(_persistDraft);
    _birthDateController.addListener(_persistDraft);

    _persistDraft();
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_persistDraft);
    _lastNameController.removeListener(_persistDraft);
    _emailController.removeListener(_persistDraft);
    _phoneController.removeListener(_persistDraft);
    _birthDateController.removeListener(_persistDraft);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _persistDraft() {
    _syncDataFromControllers();
    unawaited(
      _sessionRepository.saveRegistrationDraft({
        'route': '/account-setup',
        'extra': Map<String, dynamic>.from(_data)..['isEditing'] = _isEditing,
      }),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Revert changes if cancelled
        _firstNameController.text = _data['firstName'] ?? '';
        _lastNameController.text = _data['lastName'] ?? '';
        _emailController.text = _data['email'] ?? '';
        _phoneController.text = _data['phone'] ?? '';
        _selectedBirthDate = _data['birthDate'];
        _selectedGender = _data['gender'];
        _birthDateController.text = _selectedBirthDate != null
            ? DateFormat.yMMMd().format(_selectedBirthDate!)
            : '';
      }
    });
    _persistDraft();
  }

  void _saveChanges() {
    _syncDataFromControllers();
    if (!_hasRequiredOnboardingData()) {
      _showValidationError();
      return;
    }

    setState(() {
      _isEditing = false;
    });
    _persistDraft();
  }

  User _buildRegistrationUser() {
    return User(
      id: 'temp-id-${DateTime.now().millisecondsSinceEpoch}',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      avatarUrl: '',
      loyaltyPoints: 0,
      subscriptionLevel: 'FREE',
      subscriptionExpiry: 'N/A',
      gender: _selectedGender,
      birthDate: _selectedBirthDate,
      isParentAccount: _data['isParentAccount'] == true,
      children:
          (_data['familyMembers'] as List<dynamic>?)
              ?.map((e) => e as ChildProfile)
              .toList() ??
          const [],
    );
  }

  Future<void> _submitRegistration() async {
    _syncDataFromControllers();
    if (!_hasRequiredOnboardingData()) {
      setState(() {
        _isEditing = true;
      });
      _showValidationError();
      _persistDraft();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final completeRegistrationUseCase = locator<CompleteRegistrationUseCase>();
    final authStateNotifier = locator<AuthStateNotifier>();
    final result = await completeRegistrationUseCase(_buildRegistrationUser());

    if (!mounted) {
      return;
    }

    result.fold(
      onSuccess: (_) {
        final currentState = authStateNotifier.state;
        final onboardingCompleted =
            authStateNotifier.session.verificationData?.onboardingCompleted ??
            false;

        if (currentState == AuthState.authenticated) {
          GoRouter.of(context).go('/home');
        } else if (currentState == AuthState.pendingAdditionalVerification &&
            onboardingCompleted) {
          GoRouter.of(context).go('/verify-additional-method');
        } else if (currentState == AuthState.pendingVerification) {
          GoRouter.of(context).go('/verification-method');
        } else if (currentState == AuthState.pendingOnboarding ||
            !onboardingCompleted) {
          GoRouter.of(context).go('/account-setup', extra: _data);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Your session needs to be refreshed. Please log in again.',
              ),
            ),
          );
          GoRouter.of(context).go('/login');
        }
      },
      onFailure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _syncDataFromControllers() {
    _data['firstName'] = _firstNameController.text.trim();
    _data['lastName'] = _lastNameController.text.trim();
    _data['email'] = _emailController.text.trim();
    _data['phone'] = _phoneController.text.trim();
    _data['birthDate'] = _selectedBirthDate;
    _data['gender'] = _selectedGender;
  }

  bool _hasRequiredOnboardingData() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final birthDate = _selectedBirthDate;
    final gender = _selectedGender;

    final isEmailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        isEmailValid &&
        phone.isNotEmpty &&
        birthDate != null &&
        birthDate.isBefore(DateTime.now()) &&
        (gender == 'male' || gender == 'female');
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please complete all required onboarding fields before continuing.',
        ),
      ),
    );
  }

  void _onContinue() {
    unawaited(
      _sessionRepository.saveRegistrationDraft({
        'route': '/account-setup',
        'extra': Map<String, dynamic>.from(_data),
      }),
    );
    unawaited(_submitRegistration());
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat.yMMMd().format(picked);
      });
      _persistDraft();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            if (_isEditing)
              IconButton(
                onPressed: _toggleEdit,
                icon: const Icon(Symbols.close),
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: spacing.screenPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  [
                        AuthHeader(
                          title: _isEditing
                              ? l10n.profileEditTitle
                              : l10n.authAccountOverviewTitle,
                          subtitle: _isEditing
                              ? l10n.profileEditSubtitle
                              : l10n.authAccountOverviewSubtitle,
                        ),
                        SizedBox(height: spacing.xl),

                        // Profile Picture Section (only show when not editing for clarity, or keep it)
                        if (!_isEditing) ...[
                          Center(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.commonImagePickerPlaceholder,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(60),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme
                                              .surfaceContainer,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: theme
                                                .colorScheme
                                                .outlineVariant,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Symbols.person,
                                          size: 64,
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Symbols.add_a_photo,
                                            size: 20,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: spacing.md),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing.lg,
                                  ),
                                  child: Text(
                                    l10n.authProfilePictureRecommendation,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacing.xxl),
                        ],

                        // Details Section
                        if (!_isEditing) ...[
                          AuthTextField(
                            label: l10n.authFullNameLabel,
                            hint: '',
                            leadingIcon: Symbols.person,
                            controller: TextEditingController(
                              text:
                                  '${_data['firstName']} ${_data['lastName']}',
                            ),
                            readOnly: true,
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: AuthTextField(
                                  label: l10n.authFirstNameLabel,
                                  hint: l10n.authFirstNameHint,
                                  leadingIcon: Symbols.person,
                                  controller: _firstNameController,
                                ),
                              ),
                              SizedBox(width: spacing.md),
                              Expanded(
                                child: AuthTextField(
                                  label: l10n.authLastNameLabel,
                                  hint: l10n.authLastNameHint,
                                  leadingIcon: Symbols.person,
                                  controller: _lastNameController,
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: spacing.lg),
                        AuthTextField(
                          label: l10n.authEmailLabel,
                          hint: '',
                          leadingIcon: Symbols.mail,
                          controller: _emailController,
                          readOnly: !_isEditing,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: spacing.lg),
                        AuthTextField(
                          label: l10n.authPhoneLabel,
                          hint: '',
                          leadingIcon: Symbols.call,
                          controller: _phoneController,
                          readOnly: !_isEditing,
                          keyboardType: TextInputType.phone,
                        ),

                        if (_isEditing || _selectedGender != null) ...[
                          SizedBox(height: spacing.lg),
                          if (_isEditing)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.authGenderLabel,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: spacing.xs),
                                Row(
                                  children: [
                                    _GenderOption(
                                      label: l10n.commonGenderMale,
                                      isSelected: _selectedGender == 'male',
                                      onTap: () {
                                        setState(
                                          () => _selectedGender = 'male',
                                        );
                                        _persistDraft();
                                      },
                                    ),
                                    SizedBox(width: spacing.sm),
                                    _GenderOption(
                                      label: l10n.commonGenderFemale,
                                      isSelected: _selectedGender == 'female',
                                      onTap: () {
                                        setState(
                                          () => _selectedGender = 'female',
                                        );
                                        _persistDraft();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            AuthTextField(
                              label: l10n.authGenderLabel,
                              hint: '',
                              leadingIcon: Symbols.person,
                              controller: TextEditingController(
                                text: _selectedGender,
                              ),
                              readOnly: true,
                            ),
                        ],

                        if (_isEditing || _selectedBirthDate != null) ...[
                          SizedBox(height: spacing.lg),
                          AuthTextField(
                            label: l10n.authBirthDateLabel,
                            hint: l10n.authBirthDateHint,
                            leadingIcon: Symbols.calendar_month,
                            controller: _birthDateController,
                            readOnly: true,
                            onTap: _isEditing ? _selectBirthDate : null,
                          ),
                        ],

                        SizedBox(height: spacing.xl),

                        // Edit Action
                        if (!_isEditing)
                          TextButton.icon(
                            onPressed: _toggleEdit,
                            icon: const Icon(Symbols.edit, size: 18),
                            label: Text(l10n.authEditInformation),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onPrimaryContainer,
                            ),
                            child: Text(l10n.profileSave),
                          ),

                        SizedBox(height: spacing.xxl),

                        if (!_isEditing)
                          ElevatedButton(
                            onPressed: _isSubmitting ? null : _onContinue,
                            child: Text(l10n.authConfirmContinue),
                          ),

                        SizedBox(height: spacing.lg),
                      ]
                      .animate(interval: 50.ms)
                      .fade(duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.spacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
