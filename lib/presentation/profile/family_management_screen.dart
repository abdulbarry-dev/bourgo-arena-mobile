import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/family_member_widgets.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for managing family account and children profiles.
class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  late final FamilyManagementViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FamilyManagementViewModel(
      getUserProfileUseCase: locator<GetUserProfileUseCase>(),
      updateUserProfileUseCase: locator<UpdateUserProfileUseCase>(),
      verifyOtpUseCase: locator<VerifyOtpUseCase>(),
      requestFamilyAccountOtpUseCase: locator<RequestFamilyAccountOtpUseCase>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _selectChildBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _viewModel.selectedChildBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _viewModel.setChildBirthDate(picked);
      _viewModel.childBirthDateController.text = DateFormat.yMMMd().format(
        picked,
      );
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
        title: Text(l10n.profileDisableFamilyTitle),
        content: Text(l10n.profileDisableFamilyContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              await _viewModel.disableFamilyAccount();
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.profileDisableConfirm),
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
                _viewModel.user?.phone.isNotEmpty == true
                    ? _viewModel.user!.phone
                    : _viewModel.user?.email ?? '',
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
                        final messenger = ScaffoldMessenger.of(context);
                        final successMessage = AppLocalizations.of(
                          context,
                        )!.profileFamilyEnabled;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(successMessage),
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
                  : Text(l10n.authVerify),
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
          l10n.settingsManageFamily,
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

          final user = _viewModel.user;
          if (user == null) {
            return Center(child: Text(l10n.commonErrorOccurred));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        value: user.isParentAccount,
                        onChanged: _toggleFamilyAccount,
                      ),
                      if (user.isParentAccount) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                        _ChildrenSection(
                          children: user.children,
                          viewModel: _viewModel,
                          onSelectBirthDate: _selectChildBirthDate,
                        ),
                      ],
                    ],
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

class _ChildrenSection extends StatelessWidget {
  final List<ChildProfile> children;
  final FamilyManagementViewModel viewModel;
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
                style: BorderStyle.solid,
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
                  name: child.name,
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
          firstNameController: viewModel.childFirstNameController,
          lastNameController: viewModel.childLastNameController,
          birthDateController: viewModel.childBirthDateController,
          selectedGender: viewModel.selectedChildGender,
          onGenderChanged: viewModel.setChildGender,
          onSelectBirthDate: onSelectBirthDate,
          onAdd: () => viewModel.addChildFromForm(),
          firstNameError: viewModel.hasChildFirstNameError
              ? l10n.commonRequiredField
              : null,
          lastNameError: viewModel.hasChildLastNameError
              ? l10n.commonRequiredField
              : null,
          genderError: viewModel.hasChildGenderError
              ? l10n.commonRequiredField
              : null,
          birthDateError: viewModel.hasChildBirthDateError
              ? l10n.commonRequiredField
              : null,
        ),
      ],
    );
  }
}
