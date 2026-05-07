import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/family_member_widgets.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_view_model.dart';
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
      dataService: locator<DataService>(),
      authService: locator<AuthService>(),
    );
    _viewModel.addListener(_onViewModelChange);
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
        _viewModel.profile != null &&
        _firstNameController.text.isEmpty) {
      _firstNameController.text = _viewModel.profile!.firstName;
      _lastNameController.text = _viewModel.profile!.lastName;
      _emailController.text = _viewModel.profile!.email;
      _phoneController.text = _viewModel.profile!.phone;
      if (_viewModel.profile!.birthDate != null) {
        _selectedBirthDate = _viewModel.profile!.birthDate;
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

  Future<void> _selectChildBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.selectedChildBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _viewModel.setChildBirthDate(picked);
      _viewModel.childBirthDateController.text =
          DateFormat.yMMMd().format(picked);
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
            const SnackBar(
              content: Text('Error updating profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleFamilyAccount(bool value) async {
    if (value) {
      final success = await _viewModel.requestFamilyAccountOtp();
      if (success && mounted) {
        _showOtpDialog();
      }
    } else {
      _showDisableFamilyDialog();
    }
  }

  void _showDisableFamilyDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileFamilyAccount),
        content: Text('Are you sure you want to disable the family account? This will remove all child profiles.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              _viewModel.disableFamilyAccount();
              Navigator.pop(context);
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: appColors.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          l10n.profileVerifyFamilyTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileVerifyFamilySubtitle(
                _viewModel.profile!.phone.isNotEmpty
                    ? _viewModel.profile!.phone
                    : _viewModel.profile!.email,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            AuthTextField(
              label: 'OTP CODE',
              hint: '000000',
              leadingIcon: Symbols.lock,
              controller: otpController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.commonCancel,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => ElevatedButton(
              onPressed: _viewModel.isVerifyingOtp
                  ? null
                  : () async {
                      final success = await _viewModel.verifyFamilyAccountOtp(
                        otpController.text,
                      );
                      if (!context.mounted) return;
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.profileFamilyEnabled,
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
              child: _viewModel.isVerifyingOtp
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verify'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

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

          final profile = _viewModel.profile!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AvatarSection(avatarUrl: profile.avatarUrl),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: AuthTextField(
                          label: l10n.authFirstNameLabel,
                          hint: 'First name',
                          leadingIcon: Symbols.person,
                          controller: _firstNameController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AuthTextField(
                          label: l10n.authLastNameLabel,
                          hint: 'Last name',
                          leadingIcon: Symbols.person,
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: l10n.authEmailLabel,
                    hint: 'email@example.com',
                    leadingIcon: Symbols.mail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: l10n.authPhoneLabel,
                    hint: '+1 234 567 8900',
                    leadingIcon: Symbols.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: l10n.authBirthDateLabel,
                    hint: 'Select birth date',
                    leadingIcon: Symbols.calendar_today,
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _selectBirthDate,
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: appColors.bgElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: appColors.bgBorder),
                    ),
                    child: Column(
                      children: [
                  FamilyAccountToggle(
                    value: profile.isParentAccount,
                    onChanged: _toggleFamilyAccount,
                  ),
                        if (profile.isParentAccount) ...[
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          _ChildrenSection(
                            children: profile.children,
                            viewModel: _viewModel,
                            onSelectBirthDate: _selectChildBirthDate,
                          ),
                        ],
                      ],
                    ),
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

class _ChildrenSection extends StatelessWidget {
  final List<ChildProfileModel> children;
  final EditProfileViewModel viewModel;
  final VoidCallback onSelectBirthDate;

  const _ChildrenSection({
    required this.children,
    required this.viewModel,
    required this.onSelectBirthDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.authAddedMembers.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        if (children.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                style: BorderStyle.dashed,
              ),
            ),
            child: Text(
              l10n.profileNoChildren,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: children.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final child = children[index];
                return FamilyMemberCard(
                  name: child.firstName,
                  gender: child.gender,
                  onRemove: () => viewModel.removeChild(child.id),
                );
              },
            ),
          ),
        const SizedBox(height: 32),
        Text(
          l10n.profileAddChild.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        FamilyMemberForm(
          nameController: viewModel.childNameController,
          birthDateController: viewModel.childBirthDateController,
          selectedGender: viewModel.selectedChildGender,
          onGenderChanged: viewModel.setChildGender,
          onSelectBirthDate: onSelectBirthDate,
          onAdd: viewModel.addChildFromForm,
          nameError: viewModel.childNameError,
          genderError: viewModel.childGenderError,
          birthDateError: viewModel.childBirthDateError,
        ),
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String avatarUrl;

  const _AvatarSection({required this.avatarUrl});

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
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
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

