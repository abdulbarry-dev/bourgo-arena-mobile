import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A custom stepper component for the booking flow.
class ProgressStepper extends StatelessWidget {
  /// The current active step (0, 1, or 2).
  final int currentStep;

  /// Whether the booking flow includes a member selection step.
  final bool isFamilyFlow;

  /// Creates a new [ProgressStepper] instance.
  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.isFamilyFlow,
  });

  @override
  Widget build(BuildContext context) {
    final steps = isFamilyFlow
        ? [
            (Symbols.person, AppLocalizations.of(context)!.bookingStepMember),
            (
              Symbols.sports_soccer,
              AppLocalizations.of(context)!.bookingStepSport,
            ),
            (Symbols.schedule, AppLocalizations.of(context)!.bookingStepTime),
            (Symbols.payment, AppLocalizations.of(context)!.bookingStepPayment),
          ]
        : [
            (
              Symbols.sports_soccer,
              AppLocalizations.of(context)!.bookingStepSport,
            ),
            (Symbols.schedule, AppLocalizations.of(context)!.bookingStepTime),
            (Symbols.payment, AppLocalizations.of(context)!.bookingStepPayment),
          ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _StepCircle(
              icon: steps[i].$1,
              label: steps[i].$2,
              isActive: currentStep >= i,
              isCompleted: currentStep > i,
            ),
            if (i != steps.length - 1) _StepLine(isCompleted: currentStep > i),
          ],
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepCircle({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCompleted || isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.24);

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? theme.colorScheme.primary
                  : isActive
                  ? theme.colorScheme.primary.withAlpha(40)
                  : theme.colorScheme.surface,
              border: Border.all(color: color, width: 1.5),
            ),
            child: Icon(
              isCompleted ? Symbols.check : icon,
              size: 20,
              color: isCompleted ? theme.colorScheme.onPrimary : color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isCompleted;

  const _StepLine({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 24),
        color: isCompleted
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withValues(alpha: 0.12),
      ),
    );
  }
}
