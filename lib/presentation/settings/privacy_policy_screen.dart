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
              'Last Updated: May 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: '1. Information Collection',
              content:
                  'We collect personal information that you provide to us, such as your name, email address, phone number, and payment information when you register or use our services.',
            ),
            _Section(
              title: '2. Use of Information',
              content:
                  'Your information is used to provide and improve our services, process payments, send notifications about your bookings, and communicate with you about updates or offers.',
            ),
            _Section(
              title: '3. Data Security',
              content:
                  'We implement industry-standard security measures to protect your personal data. However, no method of transmission over the internet is 100% secure.',
            ),
            _Section(
              title: '4. Third-Party Services',
              content:
                  'We may use third-party service providers to facilitate our services, such as payment processors. These third parties have access to your information only to perform specific tasks on our behalf.',
            ),
            _Section(
              title: '5. Your Rights',
              content:
                  'You have the right to access, update, or delete your personal information at any time through the app settings or by contacting our support team.',
            ),
            _Section(
              title: '6. Cookies and Tracking',
              content:
                  'We use cookies and similar tracking technologies to track activity on our service and hold certain information to improve your experience.',
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
