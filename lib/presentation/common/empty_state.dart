import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final spacing = context.spacing;

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

        return Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(isSmall ? spacing.lg : spacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with cleaner, subtle background
                      Container(
                            padding: EdgeInsets.all(
                              isSmall ? spacing.md : spacing.lg,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              icon,
                              size: iconSize,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .slideY(
                            begin: 0,
                            end: -0.05,
                            duration: 2.seconds,
                            curve: Curves.easeInOutSine,
                          )
                          .scaleXY(
                            begin: 1.0,
                            end: 1.05,
                            duration: 2.seconds,
                            curve: Curves.easeInOutSine,
                          ),

                      SizedBox(height: isSmall ? spacing.lg : spacing.xl),
                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: titleStyle?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: isSmall ? spacing.xs : spacing.sm),
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
                        SizedBox(height: isSmall ? spacing.lg : spacing.xl),
                        FilledButton.icon(
                          onPressed: onAction,
                          icon: const Icon(Icons.add, size: 20),
                          label: Text(actionLabel!),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.lg,
                              vertical: spacing.sm,
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
            )
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOutQuad)
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 400.ms,
              curve: Curves.easeOutQuad,
            );
      },
    );
  }
}
