import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';

enum AppToastType { success, error, info, warning }

class AppToast {
  AppToast._();

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    final colors = _resolveColors(theme, type);
    final icon = _iconFor(type);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: colors.text, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: colors.text)),
          ),
        ],
      ),
      backgroundColor: colors.background,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: Duration(seconds: type == AppToastType.error ? 4 : 3),
      dismissDirection: DismissDirection.horizontal,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: colors.text,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    if (context.mounted) {
      _animateIn(context, snackBar);
    }
  }

  static void _animateIn(BuildContext context, SnackBar snackBar) {
    final controller = ScaffoldMessenger.of(context);
    // The snackbar is already showing; the animation is handled by SnackBar itself.
    // For entrance animation override, we'd need a custom Overlay-based approach.
    // SnackBar provides a default 'FadeTransition' which is sufficient.
  }

  static _ToastColors _resolveColors(ThemeData theme, AppToastType type) {
    final appColors = theme.extension<AppColors>();

    return switch (type) {
      AppToastType.success => _ToastColors(
        appColors?.statusSuccess ?? const Color(0xFF2E7D32),
        Colors.white,
      ),
      AppToastType.error => _ToastColors(
        theme.colorScheme.error,
        theme.colorScheme.onError,
      ),
      AppToastType.warning => _ToastColors(
        appColors?.statusWarning ?? const Color(0xFFF57F17),
        Colors.black,
      ),
      AppToastType.info => _ToastColors(
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurface,
      ),
    };
  }

  static IconData _iconFor(AppToastType type) {
    return switch (type) {
      AppToastType.success => Symbols.check_circle,
      AppToastType.error => Symbols.error,
      AppToastType.warning => Symbols.warning,
      AppToastType.info => Symbols.info,
    };
  }
}

class _ToastColors {
  final Color background;
  final Color text;
  const _ToastColors(this.background, this.text);
}
