import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';

class ConfirmActionModal {
  static Future<bool?> show({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? message,
    String? cancelLabel,
    String? confirmLabel,
    bool isDestructive = false,
    Widget? content,
    Future<bool> Function(BuildContext dialogContext)? onConfirm,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (initialContext) {
        bool isConfirming = false;

        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            final appColors = theme.extension<AppColors>()!;
            final effectiveCancelLabel =
                cancelLabel ?? (isDestructive ? 'ANNULER' : 'ANNULER');
            final effectiveConfirmLabel =
                confirmLabel ?? (isDestructive ? 'CONFIRMER' : 'CONFIRMER');
            final accentColor = isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.primary;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: appColors.bgElevated,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  border: Border.all(color: accentColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accentColor, size: 32),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title.toUpperCase(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                        fontFamily: AppConstants.displayFontFamily,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (content != null) ...[
                      const SizedBox(height: 12),
                      content,
                    ],
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isConfirming
                                ? null
                                : () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              effectiveCancelLabel,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isConfirming
                                ? null
                                : () async {
                                    if (onConfirm != null) {
                                      setState(() => isConfirming = true);
                                      final shouldClose = await onConfirm(
                                        context,
                                      );
                                      setState(() => isConfirming = false);
                                      if (shouldClose) {
                                        Navigator.pop(context, true);
                                      }
                                    } else {
                                      Navigator.pop(context, true);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: isDestructive
                                  ? theme.colorScheme.onError
                                  : theme.colorScheme.onPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isConfirming
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: isDestructive
                                          ? theme.colorScheme.onError
                                          : theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : Text(
                                    effectiveConfirmLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
