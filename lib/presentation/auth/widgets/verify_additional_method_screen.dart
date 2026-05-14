import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen shown when user has verified one method (email or phone) but needs to verify the other.
class VerifyAdditionalMethodScreen extends StatefulWidget {
  /// The unverified method: 'email' or 'phone'
  final String unverifiedMethod;

  /// The email address (if method is 'email')
  final String? email;

  /// The phone number (if method is 'phone')
  final String? phone;

  /// Use case to send OTP
  final SendOtpUseCase sendOtpUseCase;

  const VerifyAdditionalMethodScreen({
    super.key,
    required this.unverifiedMethod,
    this.email,
    this.phone,
    required this.sendOtpUseCase,
  });

  @override
  State<VerifyAdditionalMethodScreen> createState() =>
      _VerifyAdditionalMethodScreenState();
}

class _VerifyAdditionalMethodScreenState
    extends State<VerifyAdditionalMethodScreen> {
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _verifyNow() async {
    _setLoading(true);
    final identifier = widget.unverifiedMethod == 'email'
        ? widget.email
        : widget.phone;

    if (identifier != null) {
      // Send OTP to the unverified method
      await widget.sendOtpUseCase(identifier);

      if (mounted) {
        _setLoading(false);
        // Navigate to OTP verification screen for the unverified method
        context.push(
          '/otp',
          extra: {'destination': identifier, 'is_password_reset': false},
        );
      }
    }
  }

  void _skipForNow() {
    // Navigate to onboarding (can prompt for verification later)
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final identifier = widget.unverifiedMethod == 'email'
        ? widget.email
        : widget.phone;

    final title = widget.unverifiedMethod == 'email'
        ? l10n.authVerifyEmailTitle
        : l10n.authVerifyPhoneTitle;

    final subtitle = widget.unverifiedMethod == 'email'
        ? l10n.authVerifyEmailSubtitle(identifier ?? '')
        : l10n.authVerifyPhoneSubtitle(identifier ?? '');

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: l10n.authVerifyAdditionalMethodTitle,
                  subtitle: l10n.authVerifyAdditionalMethodMessage(
                    widget.unverifiedMethod,
                  ),
                ),
                const SizedBox(height: 48),
                // Icon representation of the method
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Icon(
                        widget.unverifiedMethod == 'email'
                            ? Symbols.mail
                            : Symbols.call,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Method details
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),
                // Action buttons
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyNow,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : Text(l10n.authVerifyNow),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : _skipForNow,
                  child: Text(l10n.authSkipForNow),
                ),
                const SizedBox(height: 32),
                // Informational text
                Text(
                  l10n.authMethodAccessInstruction,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
