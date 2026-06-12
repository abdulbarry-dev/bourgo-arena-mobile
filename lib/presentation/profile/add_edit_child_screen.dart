import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/update_child_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/add_edit_child_view_model.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for adding/editing a child profile.
class AddEditChildScreen extends StatefulWidget {
  final String? childId;
  final ChildProfile? child;

  const AddEditChildScreen({super.key, this.childId, this.child});

  @override
  State<AddEditChildScreen> createState() => _AddEditChildScreenState();
}

class _AddEditChildScreenState extends State<AddEditChildScreen> {
  late final AddEditChildViewModel _viewModel;
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = AddEditChildViewModel(
      addChildUseCase: locator<AddChildUseCase>(),
      updateChildUseCase: locator<UpdateChildUseCase>(),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked != null) {
      _viewModel.setAvatarFilePath(picked.path);
    }
  }

  Future<void> _selectBirthDate() async {
    AppHaptics.light();
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

  Future<void> _onSubmit() async {
    AppHaptics.light();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final success = await _viewModel.submitChild();
    if (!mounted) return;

    if (success) {
      AppHaptics.success();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.isEditing
                  ? l10n.profileChildUpdated
                  : l10n.profileChildAdded,
            ),
            backgroundColor: appColors.statusSuccess,
            behavior: SnackBarBehavior.floating,
          ),
        );
      context.pop(true);
    } else {
      // Move focus to the first invalid text field so the user can fix it
      // immediately (errors below gender/date are shown inline).
      AppHaptics.error();
      if (_viewModel.hasFirstNameError) {
        _firstNameFocus.requestFocus();
      } else if (_viewModel.hasLastNameError) {
        _lastNameFocus.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          (_viewModel.isEditing ? l10n.profileEditChild : l10n.profileAddChild)
              .toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
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
                // Avatar Picker
                _buildAvatarPicker(theme),
                SizedBox(height: spacing.lg),

                // First Name Field
                AuthTextField(
                  label: l10n.profileFirstName,
                  hint: l10n.profileFirstNameHint,
                  controller: _viewModel.firstNameController,
                  focusNode: _firstNameFocus,
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
                  focusNode: _lastNameFocus,
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
                Semantics(
                  button: true,
                  label: l10n.profileBirthDate,
                  child: InkWell(
                    onTap: _selectBirthDate,
                    borderRadius: BorderRadius.circular(12),
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
                    child: Row(
                      children: [
                        Icon(
                          Symbols.error,
                          size: 20,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_viewModel.errorMessage != null)
                  SizedBox(height: spacing.lg),

                // Submit Button
                FilledButton(
                  onPressed: _viewModel.isSubmitting ? null : _onSubmit,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: spacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _viewModel.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          (_viewModel.isEditing
                                  ? l10n.commonSave
                                  : l10n.profileAddChild)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
                SizedBox(height: spacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarPicker(ThemeData theme) {
    final hasAvatar = _viewModel.avatarFilePath != null || _viewModel.isEditing;
    return GestureDetector(
      onTap: _pickAvatar,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: _viewModel.avatarFilePath != null
                ? Image.file(
                    File(_viewModel.avatarFilePath!),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.add_a_photo,
                        size: 28,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PHOTO',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
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
            onTap: () {
              AppHaptics.selection();
              _viewModel.setGender('male');
            },
          ),
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: _GenderOption(
            icon: Symbols.girl,
            label: l10n.profileFemale,
            isSelected: _viewModel.selectedGender == 'female',
            onTap: () {
              AppHaptics.selection();
              _viewModel.setGender('female');
            },
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

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
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
      ),
    );
  }
}
