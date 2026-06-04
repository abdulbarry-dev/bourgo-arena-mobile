import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A modal dialog that prompts the user to complete their account setup.
class OnboardingSetupModal extends StatelessWidget {
  const OnboardingSetupModal({super.key});

  /// Shows the onboarding setup modal.
  ///
  /// Returns [true] if the user clicked "Complete Setup", [false] if "Cancel",
  /// or [null] if dismissed.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const OnboardingSetupModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.authSetupRequiredTitle),
      content: Text(l10n.authSetupRequiredMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.settingsCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(minimumSize: const Size(140, 44)),
          child: Text(l10n.authCompleteSetup),
        ),
      ],
    );
  }
}
