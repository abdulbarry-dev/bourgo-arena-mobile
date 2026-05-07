import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for account overview and profile picture setup.
class AccountSetupScreen extends StatelessWidget {
  /// Registration data passed from previous steps.
  final Map<String, dynamic> registrationData;

  /// Creates an [AccountSetupScreen].
  const AccountSetupScreen({super.key, required this.registrationData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final name =
        '${registrationData['firstName']} ${registrationData['lastName']}';
    final email = registrationData['email'] as String;
    final phone = registrationData['phone'] as String;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: l10n.authAccountOverviewTitle,
                  subtitle: l10n.authAccountOverviewSubtitle,
                ),
                const SizedBox(height: 32),

                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // In a real app, this would trigger image picker
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.commonImagePickerPlaceholder),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(60),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainer,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Symbols.person,
                                size: 64,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Symbols.add_a_photo,
                                  size: 20,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          l10n.authProfilePictureRecommendation,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Details Section
                AuthTextField(
                  label: l10n.authFullNameLabel,
                  hint: '',
                  leadingIcon: Symbols.person,
                  controller: TextEditingController(text: name),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  label: l10n.authEmailLabel,
                  hint: '',
                  leadingIcon: Symbols.mail,
                  controller: TextEditingController(text: email),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  label: l10n.authPhoneLabel,
                  hint: '',
                  leadingIcon: Symbols.call,
                  controller: TextEditingController(text: phone),
                  readOnly: true,
                ),

                const SizedBox(height: 32),

                // Edit Action
                TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Symbols.edit, size: 18),
                  label: Text(l10n.authEditInformation),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: () =>
                      context.push('/pin-setup', extra: registrationData),
                  child: Text(l10n.authConfirmContinue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
