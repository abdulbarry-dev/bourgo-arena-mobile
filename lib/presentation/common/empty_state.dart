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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxHeight < 300;
        final iconSize = isSmall ? 48.0 : 64.0;
        final titleStyle = isSmall
            ? theme.textTheme.titleMedium
            : theme.textTheme.headlineSmall;
        final messageStyle = isSmall
            ? theme.textTheme.bodySmall
            : theme.textTheme.bodyLarge;

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
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(isSmall ? 16.0 : 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with soft background
                    Container(
                      padding: EdgeInsets.all(isSmall ? 16 : 24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                            theme.colorScheme.primary.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: theme.colorScheme.primary.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: isSmall ? 16 : 32),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: titleStyle?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: isSmall ? 4 : 12),
                    // Message
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: messageStyle?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.4,
                      ),
                    ),
                    // Action Button
                    if (actionLabel != null && onAction != null) ...[
                      SizedBox(height: isSmall ? 20 : 40),
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
          ),
        );
      },
    );
  }
}
