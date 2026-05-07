import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A card displaying a family member's brief info.
class FamilyMemberCard extends StatelessWidget {
  /// The member's name.
  final String name;

  /// The member's gender (e.g., 'male', 'female').
  final String? gender;

  /// Callback when the remove button is pressed.
  final VoidCallback onRemove;

  /// Creates a [FamilyMemberCard].
  const FamilyMemberCard({
    super.key,
    required this.name,
    this.gender,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData genderIcon;
    Color genderColor;

    switch (gender) {
      case 'male':
        genderIcon = Symbols.male;
        genderColor = const Color(0xFF00D1FF); // Brighter blue
      case 'female':
        genderIcon = Symbols.female;
        genderColor = const Color(0xFFFF00D1); // Brighter pink
      default:
        genderIcon = Symbols.person;
        genderColor = theme.colorScheme.primary;
    }

    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Subtle glow background
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: genderColor.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: genderColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: genderColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(genderIcon, color: genderColor, size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Symbols.close,
                      size: 14,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A premium toggle for enabling/disabling family account features.
class FamilyAccountToggle extends StatelessWidget {
  /// Whether the family account is enabled.
  final bool value;

  /// Callback when the toggle state changes.
  final ValueChanged<bool> onChanged;

  /// Creates a [FamilyAccountToggle].
  const FamilyAccountToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.family_restroom,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// A form for adding or editing a family member.
class FamilyMemberForm extends StatelessWidget {
  /// Controller for the member's first name.
  final TextEditingController firstNameController;

  /// Controller for the member's last name.
  final TextEditingController lastNameController;

  /// Controller for the member's birth date text field.
  final TextEditingController birthDateController;

  /// The currently selected gender.
  final String? selectedGender;

  /// Callback when gender is selected.
  final ValueChanged<String?> onGenderChanged;

  /// Callback when the birth date field is tapped.
  final VoidCallback onSelectBirthDate;

  /// Callback when the "Add" button is pressed.
  final VoidCallback onAdd;

  /// Text for the "Add" button.
  final String? addButtonLabel;

  /// Error text for first name field.
  final String? firstNameError;

  /// Error text for last name field.
  final String? lastNameError;

  /// Error text for gender selection.
  final String? genderError;

  /// Error text for birth date field.
  final String? birthDateError;

  /// Creates a [FamilyMemberForm].
  const FamilyMemberForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.birthDateController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSelectBirthDate,
    required this.onAdd,
    this.addButtonLabel,
    this.firstNameError,
    this.lastNameError,
    this.genderError,
    this.birthDateError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AuthTextField(
                  label: l10n.authFirstNameLabel,
                  hint: l10n.authFirstNameHint,
                  leadingIcon: Symbols.person,
                  controller: firstNameController,
                  errorText: firstNameError,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AuthTextField(
                  label: l10n.authLastNameLabel,
                  hint: l10n.authLastNameHint,
                  leadingIcon: Symbols.person,
                  controller: lastNameController,
                  errorText: lastNameError,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AuthTextField(
            label: l10n.authBirthDateLabel,
            hint: l10n.authBirthDateHint,
            leadingIcon: Symbols.calendar_today,
            controller: birthDateController,
            readOnly: true,
            onTap: onSelectBirthDate,
            errorText: birthDateError,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.authGenderLabel.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: genderError != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              if (genderError != null)
                Text(
                  genderError!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _GenderButton(
                icon: Symbols.male,
                label: l10n.commonGenderMale,
                isSelected: selectedGender == 'male',
                onTap: () => onGenderChanged('male'),
              ),
              const SizedBox(width: 12),
              _GenderButton(
                icon: Symbols.female,
                label: l10n.commonGenderFemale,
                isSelected: selectedGender == 'female',
                onTap: () => onGenderChanged('female'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Symbols.add, size: 20),
            label: Text(addButtonLabel ?? l10n.authAddMember),
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

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
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
