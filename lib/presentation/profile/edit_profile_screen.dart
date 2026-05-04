import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
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
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.profileUpdateSuccess),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (mounted) {
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
    if (value && !_viewModel.profile!.isParentAccount) {
      // Request OTP to enable
      final requested = await _viewModel.requestFamilyAccountOtp();
      if (requested && mounted) {
        _showOtpDialog();
      }
    } else if (!value && _viewModel.profile!.isParentAccount) {
      // Disable directly or confirm
      // For now just allow it
      // In a real app we might want to warn about losing children data
    }
  }

  void _showOtpDialog() {
    final l10n = AppLocalizations.of(context)!;
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileVerifyFamilyTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.profileVerifyFamilySubtitle(
                _viewModel.profile!.phone.isNotEmpty
                    ? _viewModel.profile!.phone
                    : _viewModel.profile!.email,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => TextButton(
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
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: l10n.authFirstNameLabel,
                            prefixIcon: const Icon(Symbols.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.commonRequiredField
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: l10n.authLastNameLabel,
                            prefixIcon: const Icon(Symbols.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.commonRequiredField
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.authEmailLabel,
                      prefixIcon: const Icon(Symbols.mail),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.commonRequiredField
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.authPhoneLabel,
                      prefixIcon: const Icon(Symbols.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.commonRequiredField
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _selectBirthDate,
                    decoration: InputDecoration(
                      labelText: l10n.authBirthDateLabel,
                      prefixIcon: const Icon(Symbols.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.profileFamilyAccount,
                              style: theme.textTheme.titleMedium?.copyWith(
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
                        value: profile.isParentAccount,
                        onChanged: _toggleFamilyAccount,
                      ),
                    ],
                  ),
                  if (profile.isParentAccount) ...[
                    const SizedBox(height: 24),
                    _ChildrenList(
                      children: profile.children,
                      onAdd: () => _showAddChildDialog(),
                      onRemove: (id) => _viewModel.removeChild(id),
                    ),
                  ],
                  const SizedBox(height: 40),
                  FilledButton(
                    onPressed: _viewModel.isSaving ? null : _save,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _viewModel.isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            l10n.profileSave,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddChildDialog() {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    DateTime? childBirthDate;
    final birthDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.profileAddChild),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.profileChildName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: birthDateController,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 365 * 10),
                    ),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      childBirthDate = picked;
                      birthDateController.text = DateFormat.yMMMd().format(
                        picked,
                      );
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: l10n.profileChildBirthDate,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && childBirthDate != null) {
                  final child = ChildProfileModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    firstName: nameController.text.split(' ').first,
                    lastName: nameController.text.split(' ').length > 1
                        ? nameController.text.split(' ').last
                        : '',
                    birthDate: childBirthDate!,
                  );
                  await _viewModel.addChild(child);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildrenList extends StatelessWidget {
  final List<ChildProfileModel> children;
  final VoidCallback onAdd;
  final Function(String) onRemove;

  const _ChildrenList({
    required this.children,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Children',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Symbols.add, size: 18),
              label: Text(l10n.profileAddChild),
            ),
          ],
        ),
        if (children.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.profileNoChildren,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Symbols.child_care)),
                  title: Text('${child.firstName} ${child.lastName}'),
                  subtitle: Text(DateFormat.yMMMd().format(child.birthDate)),
                  trailing: IconButton(
                    icon: const Icon(Symbols.delete, color: Colors.red),
                    onPressed: () => onRemove(child.id),
                  ),
                ),
              );
            },
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
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 3),
              ),
              child: const Icon(Symbols.edit, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
