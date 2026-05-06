import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for adding family members during registration.
class FamilyOnboardingScreen extends StatefulWidget {
  /// Registration data passed from previous steps.
  final Map<String, dynamic> registrationData;

  /// Creates a [FamilyOnboardingScreen].
  const FamilyOnboardingScreen({super.key, required this.registrationData});

  @override
  State<FamilyOnboardingScreen> createState() => _FamilyOnboardingScreenState();
}

class _FamilyOnboardingScreenState extends State<FamilyOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final List<Map<String, String>> _members = [];

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _addMember() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _members.add({
          'name': _nameController.text,
          'birthDate': _birthDateController.text,
        });
        _nameController.clear();
        _birthDateController.clear();
      });
    }
  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  void _onContinue() {
    context.push(
      '/verification-method',
      extra: {...widget.registrationData, 'familyMembers': _members},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _onContinue,
            child: Text(
              l10n.authDoItLater,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: l10n.authFamilyOnboardingTitle,
                subtitle: l10n.authFamilyOnboardingSubtitle,
              ),
              const SizedBox(height: 32),

              // Input Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: appColors.bgElevated,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: appColors.bgBorder),
                ),
                child: Column(
                  children: [
                    AuthTextField(
                      label: l10n.authFullNameLabel,
                      hint: l10n.authFullNameHint,
                      leadingIcon: Symbols.person,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: l10n.authBirthDateLabel,
                      hint: l10n.authBirthDateHint,
                      leadingIcon: Symbols.calendar_today,
                      controller: _birthDateController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _addMember,
                      icon: const Icon(Symbols.add, size: 20),
                      label: Text(l10n.authAddMember),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: theme.colorScheme.primary,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // List Section
              if (_members.isNotEmpty) ...[
                Text(
                  l10n.authAddedMembers,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _members.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    return _MemberItem(
                      name: member['name']!,
                      subtitle: member['birthDate']!,
                      onDelete: () => _removeMember(index),
                    );
                  },
                ),
              ],

              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: _onContinue,
                child: Text(AppLocalizations.of(context)!.commonStart),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onDelete;

  const _MemberItem({
    required this.name,
    required this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.family_history,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Symbols.delete,
              color: theme.colorScheme.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
