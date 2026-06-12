import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
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

  /// Repository for auth operations
  final AuthRepository authRepository;

  /// Use case to fetch verification status
  final GetVerificationStatusUseCase getVerificationStatusUseCase;

  /// Auth state notifier for session and persistence management
  final AuthStateNotifier authStateNotifier;

  const VerifyAdditionalMethodScreen({
    super.key,
    required this.unverifiedMethod,
    this.email,
    this.phone,
    required this.sendOtpUseCase,
    required this.authRepository,
    required this.getVerificationStatusUseCase,
    required this.authStateNotifier,
  });

  @override
  State<VerifyAdditionalMethodScreen> createState() =>
      _VerifyAdditionalMethodScreenState();
}

class _VerifyAdditionalMethodScreenState
    extends State<VerifyAdditionalMethodScreen> {
  bool _isLoading = false;
  bool _isFetchingStatus = false;
  String? _email;
  String? _phone;
  late String _unverifiedMethod;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _phone = widget.phone;
    _unverifiedMethod = widget.unverifiedMethod;
    _fetchVerificationStatus();
  }

  Future<void> _fetchVerificationStatus() async {
    setState(() {
      _isFetchingStatus = true;
    });

    final result = await widget.getVerificationStatusUseCase();

    if (mounted) {
      setState(() {
        _isFetchingStatus = false;
      });

      result.when(
        success: (status) {
          // Only update the local contact fields and unverified method.
          // Routing decisions (including onboarding redirects) are the
          // router's responsibility — never push from here.
          setState(() {
            _email = status.email ?? _email;
            _phone = status.phone ?? _phone;
            if (!status.emailVerified) {
              _unverifiedMethod = 'email';
            } else if (!status.phoneVerified) {
              _unverifiedMethod = 'phone';
            }
          });
        },
        failure: (failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
      );
    }
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _verifyNow() async {
    _setLoading(true);
    final identifier = _unverifiedMethod == 'email' ? _email : _phone;

    if (identifier != null && identifier.isNotEmpty) {
      // Send OTP to the unverified method
      final result = await widget.sendOtpUseCase(identifier);

      if (mounted) {
        _setLoading(false);
        result.when(
          success: (_) {
            // Navigate to OTP verification screen for the unverified method
            context.push(
              '/otp',
              extra: {'destination': identifier, 'is_password_reset': false},
            );
          },
          failure: (failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.message)));
          },
        );
      }
    } else {
      _setLoading(false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.commonMissingContactInfo)));
      }
    }
  }

  void _skipForNow() {
    widget.authStateNotifier.skipForSession();
  }

  void _skipForever() async {
    _setLoading(true);
    try {
      // Synchronize with backend if possible
      await widget.authRepository.skipAdditionalVerification();
      // Update local state and persistence
      await widget.authStateNotifier.skipForever();
    } catch (e) {
      // Even if backend fails, we respect the user's wish locally
      await widget.authStateNotifier.skipForever();
    } finally {
      if (mounted) {
        _setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final spacing = context.spacing;

    if (_isFetchingStatus) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final identifier = _unverifiedMethod == 'email' ? _email : _phone;

    final title = _unverifiedMethod == 'email'
        ? l10n.authVerifyEmailTitle
        : l10n.authVerifyPhoneTitle;

    final subtitle = _unverifiedMethod == 'email'
        ? l10n.authVerifyEmailSubtitle(identifier ?? '')
        : l10n.authVerifyPhoneSubtitle(identifier ?? '');

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: spacing.screenPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: l10n.authVerifyAdditionalMethodTitle,
                  subtitle: l10n.authVerifyAdditionalMethodMessage(
                    _unverifiedMethod == 'email'
                        ? l10n.authEmailLabel
                        : l10n.authPhoneLabel,
                  ),
                ),
                SizedBox(height: spacing.xxl),
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
                        _unverifiedMethod == 'email'
                            ? Symbols.mail
                            : Symbols.call,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.xl),
                // Method details
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.xxl),
                // Action buttons
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyNow,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.authVerifyNow),
                ),
                SizedBox(height: spacing.md),
                OutlinedButton(
                  onPressed: _isLoading ? null : _skipForNow,
                  child: Text(l10n.authSkipForNow),
                ),
                SizedBox(height: spacing.lg),
                const Divider(),
                SizedBox(height: spacing.md),
                TextButton(
                  onPressed: _isLoading ? null : _skipForever,
                  child: Text(
                    l10n.authDontShowAgain,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  l10n.authSkipForeverMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.lg),
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
