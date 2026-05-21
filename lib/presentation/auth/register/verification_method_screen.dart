import 'dart:async';
import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen where users choose how they want to verify their account.
class VerificationMethodScreen extends StatefulWidget {
  /// Registration data passed from previous steps.
  final Map<String, dynamic> registrationData;

  /// Use case to send OTP.
  final SendOtpUseCase sendOtpUseCase;

  /// Creates a [VerificationMethodScreen].
  const VerificationMethodScreen({
    super.key,
    required this.registrationData,
    required this.sendOtpUseCase,
  });

  @override
  State<VerificationMethodScreen> createState() =>
      _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  bool _isLoading = false;
  late final SessionRepository _sessionRepository;

  @override
  void initState() {
    super.initState();
    _sessionRepository = locator<SessionRepository>();
    _persistDraft('/verification-method', widget.registrationData);
  }

  String? _asNonEmptyString(dynamic value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _persistDraft(String route, Map<String, dynamic> extra) {
    unawaited(
      _sessionRepository.saveRegistrationDraft({
        'route': route,
        'extra': extra,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    developer.log(
      'VerificationMethodScreen: registrationData = ${widget.registrationData}',
    );
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final email = _asNonEmptyString(widget.registrationData['email']);
    final phone = _asNonEmptyString(widget.registrationData['phone']);
    final hasAnyMethod = email != null || phone != null;

    return AuthBackground(
      child: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthHeader(
                            title: l10n.authVerificationMethodTitle,
                            subtitle: l10n.authVerificationMethodSubtitle,
                          ),
                          const SizedBox(height: 48),
                          if (email != null)
                            _MethodCard(
                              title: l10n.authEmailMethod,
                              value: email,
                              icon: Symbols.mail,
                              onTap: _isLoading
                                  ? () {}
                                  : () => _proceedToOtp(context, email),
                            ),
                          if (email != null && phone != null)
                            const SizedBox(height: 20),
                          if (phone != null)
                            _MethodCard(
                              title: l10n.authPhoneMethod,
                              value: phone,
                              icon: Symbols.call,
                              onTap: _isLoading
                                  ? () {}
                                  : () => _proceedToOtp(context, phone),
                            ),
                          if (!hasAnyMethod)
                            Text(
                              'No verification method is available for this account. Please log in again.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 48),
                          Text(
                            l10n.authMethodAccessInstruction,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(76),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _proceedToOtp(BuildContext context, String destination) async {
    _persistDraft('/otp', {
      ...widget.registrationData,
      'destination': destination,
    });
    _setLoading(true);

    final result = await widget.sendOtpUseCase(destination);

    _setLoading(false);

    if (!context.mounted) return;

    result.fold(
      onSuccess: (_) {
        context.push(
          '/otp',
          extra: {
            'destination': destination,
            'registrationData': widget.registrationData,
          },
        );
      },
      onFailure: (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _MethodCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: appColors.brandPrimaryGhost,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Symbols.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.3,
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
