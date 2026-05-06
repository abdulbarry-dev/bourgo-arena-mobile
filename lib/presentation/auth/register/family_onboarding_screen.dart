import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/family_onboarding_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  late final FamilyOnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FamilyOnboardingViewModel();
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
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _viewModel.setBirthDate(picked);
      _viewModel.birthDateController.text = DateFormat.yMMMd().format(picked);
    }
  }

  void _onContinue() {
    context.push(
      '/verification-method',
      extra: {
        ...widget.registrationData,
        'familyMembers': _viewModel.members.map((m) => m.toJson()).toList(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthHeader(
                          title: l10n.authFamilyOnboardingTitle,
                          subtitle: l10n.authFamilyOnboardingSubtitle,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                if (_viewModel.members.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MembersList(
                      members: _viewModel.members,
                      onRemove: _viewModel.removeMember,
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _MemberForm(
                          viewModel: _viewModel,
                          onSelectBirthDate: _selectBirthDate,
                        ),
                        const SizedBox(height: 48),
                        ElevatedButton(
                          onPressed: _onContinue,
                          child: Text(l10n.commonStart),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  final List members;
  final Function(int) onRemove;

  const _MembersList({required this.members, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            l10n.authAddedMembers.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final member = members[index];
              return _MemberCard(
                name: member.firstName,
                gender: member.gender,
                onRemove: () => onRemove(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String name;
  final String? gender;
  final VoidCallback onRemove;

  const _MemberCard({required this.name, this.gender, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    IconData genderIcon;
    Color genderColor;

    switch (gender) {
      case 'male':
        genderIcon = Symbols.male;
        genderColor = Colors.blue;
      case 'female':
        genderIcon = Symbols.female;
        genderColor = Colors.pink;
      default:
        genderIcon = Symbols.person;
        genderColor = theme.colorScheme.primary;
    }

    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: genderColor.withValues(alpha: 0.1),
                  child: Icon(genderIcon, color: genderColor, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: onRemove,
              icon: Icon(
                Symbols.close,
                size: 16,
                color: theme.colorScheme.error,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberForm extends StatelessWidget {
  final FamilyOnboardingViewModel viewModel;
  final VoidCallback onSelectBirthDate;

  const _MemberForm({required this.viewModel, required this.onSelectBirthDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            label: l10n.authFullNameLabel,
            hint: l10n.authFullNameHint,
            leadingIcon: Symbols.person,
            controller: viewModel.nameController,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            label: l10n.authBirthDateLabel,
            hint: l10n.authBirthDateHint,
            leadingIcon: Symbols.calendar_today,
            controller: viewModel.birthDateController,
            readOnly: true,
            onTap: onSelectBirthDate,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.authGenderLabel.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _GenderButton(
                icon: Symbols.male,
                label: l10n.commonGenderMale,
                isSelected: viewModel.selectedGender == 'male',
                onTap: () => viewModel.setGender('male'),
              ),
              const SizedBox(width: 12),
              _GenderButton(
                icon: Symbols.female,
                label: l10n.commonGenderFemale,
                isSelected: viewModel.selectedGender == 'female',
                onTap: () => viewModel.setGender('female'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: viewModel.addMember,
            icon: const Icon(Symbols.add, size: 20),
            label: Text(l10n.authAddMember),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              foregroundColor: theme.colorScheme.primary,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : appColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : appColors.bgBorder,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
