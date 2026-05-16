import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/complete_registration_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'dart:developer' as developer;

/// Screen for setting up a gym entry PIN.
class PinSetupScreen extends StatefulWidget {
  /// Registration data passed from previous steps.
  final Map<String, dynamic> registrationData;

  /// Creates a [PinSetupScreen].
  const PinSetupScreen({super.key, required this.registrationData});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onFinish() async {
    developer.log('_onFinish called with PIN length: ${_pin.length}');
    final pin = _pin;
    if (pin.length == 4) {
      setState(() => _isLoading = true);

      try {
        final user = User(
          id: 'temp-id-${DateTime.now().millisecondsSinceEpoch}',
          firstName: widget.registrationData['firstName'] ?? '',
          lastName: widget.registrationData['lastName'] ?? '',
          email: widget.registrationData['email'] ?? '',
          phone: widget.registrationData['phone'] ?? '',
          avatarUrl: '',
          loyaltyPoints: 0,
          subscriptionLevel: 'FREE',
          subscriptionExpiry: 'N/A',
          totalCheckIns: 0,
          gender: widget.registrationData['gender'],
          birthDate: widget.registrationData['birthDate'],
          isParentAccount: widget.registrationData['isParentAccount'] ?? false,
          children:
              (widget.registrationData['familyMembers']
                  as List<ChildProfile>?) ??
              const [],
        );

        final completeRegistrationUseCase =
            locator<CompleteRegistrationUseCase>();
        final authStateNotifier = locator<AuthStateNotifier>();

        developer.log('Pre-registration AuthState: ${authStateNotifier.state}');

        final result = await completeRegistrationUseCase(user, pin);

        developer.log('UseCase returned: $result');
        developer.log(
          'Post-registration AuthState: ${authStateNotifier.state}',
        );

        result.fold(
          onSuccess: (_) {
            developer.log(
              'Registration complete. Redirect logic will handle navigation.',
            );
          },
          onFailure: (failure) {
            developer.log('Registration failed: ${failure.message}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
        );
      } catch (e, stack) {
        developer.log('Exception in _onFinish: $e', stackTrace: stack);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      developer.log('PIN length check failed: ${_pin.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final spacing = context.spacing;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: spacing.screenPadding(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthHeader(
                          title: l10n.authPinSetupTitle,
                          subtitle: l10n.authPinSetupSubtitle,
                        ),
                        SizedBox(height: spacing.xl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => _PinIndicator(
                              isFilled: _pin.length > index,
                              isCurrent: _pin.length == index,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.xl),
                        _NumericKeypad(
                          onNumberPressed: _onNumberPressed,
                          onBackspacePressed: _onBackspacePressed,
                        ),
                        SizedBox(height: spacing.xl),
                        Builder(
                          builder: (context) {
                            final isComplete = _pin.length == 4;
                            return ElevatedButton(
                              onPressed: (_isLoading || !isComplete)
                                  ? null
                                  : _onFinish,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(l10n.authCompleteRegistration),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onNumberPressed(String number) {
    if (_pin.length < 4) {
      setState(() => _pin += number);
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }
}

class _PinIndicator extends StatelessWidget {
  final bool isFilled;
  final bool isCurrent;

  const _PinIndicator({required this.isFilled, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: spacing.sm),
      width: isCurrent ? 24 : 20,
      height: isCurrent ? 24 : 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHigh,
        border: Border.all(
          color: isCurrent
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;

  const _NumericKeypad({
    required this.onNumberPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var number in row)
                  _KeypadButton(
                    label: number,
                    onPressed: () => onNumberPressed(number),
                  ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: spacing.xxxl + spacing.sm),
            _KeypadButton(label: '0', onPressed: () => onNumberPressed('0')),
            _KeypadButton(
              icon: Icons.backspace_outlined,
              onPressed: onBackspacePressed,
              isAction: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isAction;

  const _KeypadButton({
    this.label,
    this.icon,
    required this.onPressed,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAction
                ? Colors.transparent
                : theme.colorScheme.surfaceContainer,
            border: isAction
                ? null
                : Border.all(color: theme.colorScheme.outlineVariant, width: 1),
          ),
          child: label != null
              ? Text(
                  label!,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                )
              : Icon(icon, color: theme.colorScheme.onSurface, size: 28),
        ),
      ),
    );
  }
}
