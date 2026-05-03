import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Screen displaying the application's Terms of Service.
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTerms),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: May 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: '1. Acceptance of Terms',
              content:
                  'By accessing or using Bourgo Arena services, you agree to be bound by these terms. If you do not agree, please do not use the application.',
            ),
            _Section(
              title: '2. Description of Service',
              content:
                  'Bourgo Arena provides a platform for booking sports facilities, managing gym memberships, and participating in scheduled fitness classes in Djerba, Tunisia.',
            ),
            _Section(
              title: '3. User Responsibilities',
              content:
                  'Users are responsible for maintaining the confidentiality of their accounts and for all activities that occur under their credentials. You agree to follow gym rules and respect other members.',
            ),
            _Section(
              title: '4. Bookings and Payments',
              content:
                  'All bookings are subject to availability. Payments made through the app are processed securely. Cancellations must be made according to our cancellation policy to be eligible for refunds.',
            ),
            _Section(
              title: '5. Limitation of Liability',
              content:
                  'Bourgo Arena is not liable for any personal injury or property damage sustained while using the facilities, except where caused by our gross negligence.',
            ),
            _Section(
              title: '6. Changes to Terms',
              content:
                  'We reserve the right to modify these terms at any time. Your continued use of the app after such changes constitutes acceptance of the new terms.',
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
