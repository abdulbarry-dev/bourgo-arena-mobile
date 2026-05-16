import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/add_edit_child_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for adding/editing a child profile.
class AddEditChildScreen extends StatefulWidget {
  final String? childId;

  const AddEditChildScreen({super.key, this.childId});

  @override
  State<AddEditChildScreen> createState() => _AddEditChildScreenState();
}

class _AddEditChildScreenState extends State<AddEditChildScreen> {
  late final AddEditChildViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddEditChildViewModel(
      addChildUseCase: locator<AddChildUseCase>(),
      child: null, // TODO: Load child if editing
    );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profileAddChild,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.xl),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // First Name Field
                AuthTextField(
                  label: l10n.profileFirstName,
                  hint: l10n.profileFirstNameHint,
                  controller: _viewModel.firstNameController,
                  leadingIcon: Symbols.person,
                  errorText: _viewModel.hasFirstNameError
                      ? l10n.commonRequiredField
                      : null,
                ),
                SizedBox(height: spacing.lg),

                // Last Name Field
                AuthTextField(
                  label: l10n.profileLastName,
                  hint: l10n.profileLastNameHint,
                  controller: _viewModel.lastNameController,
                  leadingIcon: Symbols.person,
                  errorText: _viewModel.hasLastNameError
                      ? l10n.commonRequiredField
                      : null,
                ),
                SizedBox(height: spacing.lg),

                // Gender Selection
                Text(
                  l10n.profileGender,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.md),
                _buildGenderSelector(context),
                if (_viewModel.hasGenderError)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.md),
                    child: Text(
                      l10n.commonRequiredField,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                SizedBox(height: spacing.lg),

                // Birth Date Field
                Text(
                  l10n.profileBirthDate,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.md),
                GestureDetector(
                  onTap: _selectBirthDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.lg,
                      vertical: spacing.md,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _viewModel.hasBirthDateError
                            ? theme.colorScheme.error
                            : theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Symbols.calendar_today,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: spacing.md),
                        Expanded(
                          child: Text(
                            _viewModel.selectedBirthDate != null
                                ? DateFormat.yMMMd().format(
                                    _viewModel.selectedBirthDate!,
                                  )
                                : l10n.profileSelectDate,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _viewModel.selectedBirthDate != null
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Icon(
                          Symbols.expand_more,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_viewModel.hasBirthDateError)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.md),
                    child: Text(
                      l10n.commonRequiredField,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                SizedBox(height: spacing.xxl),

                // Error message
                if (_viewModel.errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(spacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _viewModel.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                if (_viewModel.errorMessage != null)
                  SizedBox(height: spacing.lg),

                // Submit Button
                ElevatedButton(
                  onPressed: _viewModel.isSubmitting
                      ? null
                      : () async {
                          final success = await _viewModel.submitChild();
                          if (!mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.profileChildAdded),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.pop(true);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: spacing.lg),
                  ),
                  child: _viewModel.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.profileAddChild),
                ),
                SizedBox(height: spacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderSelector(BuildContext context) {
    final spacing = context.spacing;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            icon: Symbols.boy,
            label: l10n.profileMale,
            isSelected: _viewModel.selectedGender == 'male',
            onTap: () => _viewModel.setGender('male'),
          ),
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: _GenderOption(
            icon: Symbols.girl,
            label: l10n.profileFemale,
            isSelected: _viewModel.selectedGender == 'female',
            onTap: () => _viewModel.setGender('female'),
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: spacing.sm),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
