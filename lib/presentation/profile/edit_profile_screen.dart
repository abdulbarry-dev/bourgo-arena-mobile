import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_view_model.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for editing the user's profile information.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final EditProfileViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _viewModel = EditProfileViewModel(
      updateUserProfileUseCase: locator<UpdateUserProfileUseCase>(),
      authRepository: locator<AuthRepository>(),
      authStateNotifier: locator<AuthStateNotifier>(),
    );
    _viewModel.addListener(_onViewModelChange);
    // Populate fields immediately if user is already loaded
    // (in case the ViewModel notified listeners before this listener was attached)
    _onViewModelChange();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    if (!_viewModel.isLoading &&
        _viewModel.user != null &&
        _firstNameController.text.isEmpty) {
      _firstNameController.text = _viewModel.user!.firstName;
      _lastNameController.text = _viewModel.user!.lastName;
      _emailController.text = _viewModel.user!.email;
      _phoneController.text = _viewModel.user!.phone ?? '';
      if (_viewModel.user!.birthDate != null) {
        _selectedBirthDate = _viewModel.user!.birthDate;
        _birthDateController.text = DateFormat.yMMMd().format(
          _selectedBirthDate!,
        );
      }
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await _viewModel.saveProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        birthDate: _selectedBirthDate,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.profileUpdateSuccess),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorUpdatingProfile),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profileEditTitle,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = _viewModel.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AvatarSection(avatarUrl: user.avatarUrl),
                  const SizedBox(height: 32),
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
                      const SizedBox(width: 16),
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
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: l10n.authEmailLabel,
                    hint: l10n.authEmailLabelHint,
                    leadingIcon: Symbols.mail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: l10n.authPhoneLabel,
                    hint: l10n.authPhoneHint,
                    leadingIcon: Symbols.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: l10n.authBirthDateLabel,
                    hint: l10n.authBirthDateHint,
                    leadingIcon: Symbols.calendar_today,
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _selectBirthDate,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _viewModel.isSaving ? null : _save,
                    child: _viewModel.isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(l10n.profileSave),
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

class _AvatarSection extends StatelessWidget {
  final String? avatarUrl;

  const _AvatarSection({this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: avatarUrl == null
                  ? Icon(
                      Symbols.person,
                      size: 60,
                      color: theme.colorScheme.primary,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Symbols.edit, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
