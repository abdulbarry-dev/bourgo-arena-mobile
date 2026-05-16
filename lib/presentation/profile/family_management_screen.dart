import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/family_member_widgets.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      getChildrenUseCase: locator<GetChildrenUseCase>(),
      addChildUseCase: locator<AddChildUseCase>(),
      removeChildUseCase: locator<RemoveChildUseCase>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
                _viewModel.user?.phone?.isNotEmpty == true
                    ? _viewModel.user!.phone!
                    : _viewModel.user?.email ?? '',
              ),

              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            AuthTextField(
              label: l10n.profileOtpCodeLabel,
              hint: l10n.profileOtpCodeHint,
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
                        // Navigate to manage children
                        if (context.mounted) {
                          context.push('/manage-children');
                        }
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
    final spacing = context.spacing;

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
            padding: EdgeInsets.all(spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Family Account Status Section
                Container(
                  padding: EdgeInsets.all(spacing.lg),
                  decoration: BoxDecoration(
                    color: appColors.bgElevated,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: appColors.bgBorder),
                  ),
                  child: FamilyAccountToggle(
                    value: user.isParentAccount,
                    onChanged: _toggleFamilyAccount,
                  ),
                ),
                SizedBox(height: spacing.xl),

                // Manage Children Section (if family account is enabled)
                if (user.isParentAccount) ...[
                  Text(
                    l10n.profileManageChildren,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/manage-children'),
                    icon: const Icon(Symbols.groups),
                    label: Text(l10n.profileManageChildren),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: spacing.lg),
                    ),
                  ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Symbols.family_restroom,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                        SizedBox(height: spacing.lg),
                        Text(
                          l10n.profileFamilyNotEnabled,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
