import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Screen displaying the application's Privacy Policy.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPrivacy), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.legalLastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: l10n.privacyPolicySection1Title,
              content: l10n.privacyPolicySection1Content,
            ),
            _Section(
              title: l10n.privacyPolicySection2Title,
              content: l10n.privacyPolicySection2Content,
            ),
            _Section(
              title: l10n.privacyPolicySection3Title,
              content: l10n.privacyPolicySection3Content,
            ),
            _Section(
              title: l10n.privacyPolicySection4Title,
              content: l10n.privacyPolicySection4Content,
            ),
            _Section(
              title: l10n.privacyPolicySection5Title,
              content: l10n.privacyPolicySection5Content,
            ),
            _Section(
              title: l10n.privacyPolicySection6Title,
              content: l10n.privacyPolicySection6Content,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
