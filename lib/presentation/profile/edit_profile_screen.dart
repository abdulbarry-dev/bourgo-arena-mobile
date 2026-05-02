import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = EditProfileViewModel(dataService: DataService());
    _viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    if (!_viewModel.isLoading &&
        _viewModel.profile != null &&
        _nameController.text.isEmpty) {
      _nameController.text = _viewModel.profile!.name;
      _emailController.text = _viewModel.profile!.email;
      _phoneController.text = _viewModel.profile!.phone;
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await _viewModel.saveProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AvatarSection(
                    avatarUrl: _viewModel.profile?.avatarUrl ?? '',
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.authFullNameLabel,
                      prefixIcon: const Icon(Symbols.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.commonRequiredField
                        : null,
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
