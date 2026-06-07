import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_view_model.dart';
import 'dart:async';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

/// High-fidelity OTP verification screen for Bourgo Arena.
class OtpScreen extends StatefulWidget {
  final String? destination;
  final Map<String, dynamic>? registrationData;
  final bool isPasswordReset;
  final bool autoSendOtp;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final GetVerificationStatusUseCase getVerificationStatusUseCase;

  const OtpScreen({
    super.key,
    this.destination,
    this.registrationData,
    this.isPasswordReset = false,
    this.autoSendOtp = true,
    required this.verifyOtpUseCase,
    required this.sendOtpUseCase,
    required this.getVerificationStatusUseCase,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final OtpViewModel _viewModel;
  String? _resolvedDestination;
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _timerCount = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewModel = OtpViewModel(
      widget.verifyOtpUseCase,
      widget.sendOtpUseCase,
      widget.getVerificationStatusUseCase,
    );
    _resolvedDestination = _resolveDestination();
    _viewModel.addListener(_onViewModelChanged);
    _startTimer();

    // Trigger initial OTP send if not already handled by the navigation origin
    // or if we want to ensure it's sent upon landing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoSendOtp && _resolvedDestination != null) {
        _viewModel.resend(_resolvedDestination!);
      }
    });
  }

  String? _resolveDestination() {
    final destination = widget.destination?.trim();
    if (destination != null && destination.isNotEmpty) {
      return destination;
    }

    final authNotifier = locator<AuthStateNotifier>();
    final pendingEmail = authNotifier.session.pendingEmail?.trim();
    if (pendingEmail != null && pendingEmail.isNotEmpty) {
      return pendingEmail;
    }

    final user = authNotifier.session.user;
    if (user != null) {
      final email = user.email.trim();
      if (email.isNotEmpty) {
        return email;
      }

      final phone = user.phone?.trim();
      if (phone != null && phone.isNotEmpty) {
        return phone;
      }
    }

    return null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_viewModel.errorMessage != null) {
      final l10n = AppLocalizations.of(context)!;
      final message = _viewModel.errorMessage == 'authInvalidVerificationCode'
          ? l10n.authInvalidVerificationCode
          : _viewModel.errorMessage!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _onVerify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      _viewModel.verify(
        identifier: _resolvedDestination ?? '',
        code: code,
        onSuccess: () async {
          if (widget.isPasswordReset) {
            context.push(
              '/new-password',
              extra: {'identifier': _resolvedDestination ?? '', 'otp': code},
            );
          } else {
            final authNotifier = locator<AuthStateNotifier>();
            final authState = authNotifier.state;

            if (authState == AuthState.authenticated) {
              context.go('/home');
              return;
            }

            if (authState == AuthState.pendingAdditionalVerification ||
                authState == AuthState.pendingVerification) {
              context.go('/verify-additional-method');
              return;
            }

            if (mounted) {
              context.go('/login');
            }
          }
        },
        onOnboardingIncomplete: () {
          if (mounted) {
            context.push('/account-setup', extra: _buildOnboardingData());
          }
        },
        onAdditionalVerificationNeeded: (unverifiedMethod, email, phone) {
          // Navigate to additional verification screen
          context.push(
            '/verify-additional-method',
            extra: {
              'unverified_method': unverifiedMethod,
              'email': email,
              'phone': phone,
            },
          );
        },
        isPasswordReset: widget.isPasswordReset,
      );
    }
  }

  void _onResend() {
    final destination = _resolvedDestination;
    if (destination == null || destination.isEmpty) {
      return;
    }

    _viewModel.resend(destination);
    setState(() => _timerCount = 60);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCount == 0) {
        timer.cancel();
      } else {
        setState(() => _timerCount--);
      }
    });
  }

  Map<String, dynamic> _buildOnboardingData() {
    final authNotifier = locator<AuthStateNotifier>();
    final user = authNotifier.session.user;

    return widget.registrationData ??
        {
          'firstName': user?.firstName ?? '',
          'lastName': user?.lastName ?? '',
          'email': user?.email ?? widget.destination ?? '',
          'phone': user?.phone ?? '',
          'gender': user?.gender,
          'birthDate': user?.birthDate,
          'isParentAccount': user?.isParentAccount ?? false,
          'familyMembers': user?.children ?? const [],
        };
  }

  void _showInvalidPasteToast() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Symbols.warning, color: theme.colorScheme.onError),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Invalid format. Please paste a 6-digit code.',
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  void _handlePaste(String text) {
    if (text.length == 6 && RegExp(r'^\d{6}$').hasMatch(text)) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = text[i];
      }
      _focusNodes[5].requestFocus();
    } else {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = '';
      }
      _focusNodes[0].requestFocus();
      _showInvalidPasteToast();
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text?.trim() ?? '';
    _handlePaste(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  [
                        AuthHeader(
                          title: l10n.authVerificationTitle,
                          subtitle: () {
                            final authNotifier = locator<AuthStateNotifier>();
                            if (authNotifier.state ==
                                AuthState.pendingDeletionCancellation) {
                              return l10n.authDeletionCancelSubtitle;
                            }

                            return '${l10n.authOtpSubtitlePrefix}'
                                '${_resolvedDestination ?? l10n.authOtpSubtitleDefault}.';
                          }(),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => _buildOTPField(index),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton.icon(
                            onPressed: _pasteFromClipboard,
                            icon: const Icon(Symbols.content_paste, size: 20),
                            label: const Text(
                              'Paste Code',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                l10n.authOtpResendTimer(_timerCount.toString()),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (_timerCount == 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextButton(
                                    onPressed: _viewModel.isLoading
                                        ? null
                                        : _onResend,
                                    child: Text(
                                      l10n.authSendCode,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _viewModel.isLoading ? null : _onVerify,
                          child: _viewModel.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.authVerify),
                        ),
                      ]
                      .animate(interval: 50.ms)
                      .fade(duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 48,
      height: 64,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainer,
        ),
        onChanged: (value) {
          if (value.length > 1) {
            _handlePaste(value);
            return;
          }
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
