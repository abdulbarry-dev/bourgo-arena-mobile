import 'package:flutter/material.dart';

/// A reusable, premium empty state widget.
/// Used to indicate that a list or section has no data to display.
class EmptyState extends StatelessWidget {
  /// The main title of the empty state.
  final String title;

  /// Supporting text to guide the user.
  final String message;

  /// The icon to display above the text.
  final IconData icon;

  /// Optional label for the call-to-action button.
  final String? actionLabel;

  /// Optional callback for the call-to-action button.
  final VoidCallback? onAction;

  /// Creates a new [EmptyState] instance.
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with soft background
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withAlpha(15),
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: theme.colorScheme.primary.withAlpha(150),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                  height: 1.5,
                ),
              ),
              // Action Button
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(actionLabel!),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
