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

/// High-fidelity OTP verification screen for Bourgo Arena.
class OtpScreen extends StatefulWidget {
  final String? destination;
  final Map<String, dynamic>? registrationData;
  final bool isPasswordReset;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final GetVerificationStatusUseCase getVerificationStatusUseCase;

  const OtpScreen({
    super.key,
    this.destination,
    this.registrationData,
    this.isPasswordReset = false,
    required this.verifyOtpUseCase,
    required this.sendOtpUseCase,
    required this.getVerificationStatusUseCase,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final OtpViewModel _viewModel;
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
    _viewModel.addListener(_onViewModelChanged);
    _startTimer();

    // Trigger initial OTP send if not already handled by the navigation origin
    // or if we want to ensure it's sent upon landing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.destination != null) {
        _viewModel.resend(widget.destination!);
      }
    });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!)));
    }
  }

  void _onVerify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      _viewModel.verify(
        identifier: widget.destination ?? '',
        code: code,
        onSuccess: () {
          if (widget.isPasswordReset) {
            context.push(
              '/new-password',
              extra: {'identifier': widget.destination ?? '', 'otp': code},
            );
          } else {
            context.push(
              '/account-setup',
              extra:
                  widget.registrationData ??
                  {
                    'email': widget.destination ?? '',
                    'phone': '',
                    'firstName': 'User',
                    'lastName': '',
                  },
            );
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
      );
    }
  }

  void _onResend() {
    _viewModel.resend(widget.destination ?? '');
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
              children: [
                AuthHeader(
                  title: l10n.authVerificationTitle,
                  subtitle:
                      '${l10n.authOtpSubtitlePrefix}'
                      '${widget.destination ?? l10n.authOtpSubtitleDefault}.',
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOTPField(index)),
                ),
                const SizedBox(height: 48),
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
                            onPressed: _viewModel.isLoading ? null : _onResend,
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.authVerify),
                ),
              ],
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
        maxLength: 1,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
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
