import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/otp_delivery_method.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_modal.dart';
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

  List<_OtpMethodOption> _buildOtpMethodOptions(VerificationStatus status) {
    final user = _viewModel.user;
    final options = <_OtpMethodOption>[];

    final emailIdentifier = (status.email ?? user?.email ?? '').trim();
    if (status.emailVerified && emailIdentifier.isNotEmpty) {
      options.add(
        _OtpMethodOption(
          method: OtpDeliveryMethod.email,
          identifier: emailIdentifier,
        ),
      );
    }

    final phoneIdentifier = (status.phone ?? user?.phone ?? '').trim();
    if (status.phoneVerified && phoneIdentifier.isNotEmpty) {
      options.add(
        _OtpMethodOption(
          method: OtpDeliveryMethod.phone,
          identifier: phoneIdentifier,
        ),
      );
    }

    return options;
  }

  @override
  void initState() {
    super.initState();
    _viewModel = locator<FamilyManagementViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _toggleFamilyAccount(bool value) async {
    if (value) {
      final l10n = AppLocalizations.of(context)!;
      final status = await _viewModel.getVerificationStatus();
      if (status == null) return;

      final options = _buildOtpMethodOptions(status);
      if (options.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileNoVerifiedOtpMethod)),
        );
        return;
      }

      _showOtpMethodChoiceDialog(options, status);
    } else {
      _showDisableFamilyDialog();
    }
  }

  void _showOtpMethodChoiceDialog(
    List<_OtpMethodOption> options,
    VerificationStatus status,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AppModal(
        title: l10n.authVerificationMethodTitle,
        subtitle: l10n.authVerificationMethodSubtitle,
        icon: Symbols.verified_user,
        showCloseButton: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
            final isVerified = option.method == OtpDeliveryMethod.email
                ? status.emailVerified
                : status.phoneVerified;

            return ListTile(
              enabled: isVerified,
              title: Text(
                option.method == OtpDeliveryMethod.email
                    ? l10n.authEmailLabel
                    : l10n.authPhoneLabel,
              ),
              subtitle: Text(option.identifier),
              onTap: isVerified
                  ? () async {
                      Navigator.pop(dialogContext);
                      _showOtpDialog();
                      final success = await _viewModel.requestFamilyAccountOtp(
                        method: option.method,
                        identifier: option.identifier,
                      );
                      if (!mounted) return;

                      if (!success) {
                        Navigator.pop(context); // Close the OTP dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _viewModel.errorMessage ??
                                  l10n.commonErrorOccurred,
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                        );
                      }
                    }
                  : () {
                      // If somehow an unverified option is shown, give feedback.
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.profileNoVerifiedOtpMethod),
                        ),
                      );
                    },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDisableFamilyDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AppModal(
        title: l10n.profileDisableFamilyTitle,
        subtitle: l10n.profileFamilyAccount,
        icon: Symbols.family_restroom,
        content: Text(l10n.profileDisableFamilyContent),
        actions: [
          AppModalAction(
            label: l10n.commonCancel,
            onPressed: () => Navigator.pop(context),
          ),
          AppModalAction(
            label: l10n.profileDisableConfirm,
            isPrimary: true,
            isDestructive: true,
            onPressed: () async {
              await _viewModel.disableFamilyAccount();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showOtpDialog() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppModal(
        title: l10n.profileVerifyFamilyTitle,
        subtitle: l10n.authMethodAccessInstruction,
        icon: Symbols.shield_person,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileVerifyFamilySubtitle(
                _viewModel.selectedOtpIdentifier ?? '',
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
        actionWidgets: [
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
        showCloseButton: true,
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Symbols.family_restroom,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.settingsManageFamily,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
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
                    label: Text(
                      l10n.profileManageChildren.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: spacing.lg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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

class _OtpMethodOption {
  const _OtpMethodOption({required this.method, required this.identifier});

  final OtpDeliveryMethod method;
  final String identifier;
}
