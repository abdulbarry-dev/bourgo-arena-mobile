import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A custom stepper component for the booking flow.
class ProgressStepper extends StatelessWidget {
  /// The current active step (0, 1, or 2).
  final int currentStep;

  /// Creates a new [ProgressStepper] instance.
  const ProgressStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          _StepCircle(
            icon: Symbols.sports_soccer,
            label: 'SPORT',
            isActive: currentStep >= 0,
            isCompleted: currentStep > 0,
          ),
          _StepLine(isCompleted: currentStep > 0),
          _StepCircle(
            icon: Symbols.schedule,
            label: 'HORAIRE',
            isActive: currentStep >= 1,
            isCompleted: currentStep > 1,
          ),
          _StepLine(isCompleted: currentStep > 1),
          _StepCircle(
            icon: Symbols.payment,
            label: 'PAIEMENT',
            isActive: currentStep >= 2,
            isCompleted: false,
          ),
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
        : Colors.white24;

    return Column(
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
            color: isCompleted ? Colors.black : color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
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
        color: isCompleted ? theme.colorScheme.primary : Colors.white12,
      ),
    );
  }
}
