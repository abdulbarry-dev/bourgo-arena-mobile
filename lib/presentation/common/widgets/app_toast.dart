import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/bourgo_theme.dart';
import '../../../core/utils/haptic_utils.dart';

enum AppToastType { success, error, info, warning }

/// Overlay-based, top-positioned toast for Bourgo Arena.
///
/// Shows one toast at a time; a new call replaces the current one
/// without delay. Slides in with a spring curve, drains a progress
/// bar, and removes itself on swipe-up or timer expiry.
class AppToast {
  AppToast._();

  static OverlayEntry? _entry;
  static Timer? _timer;
  static _AppToastWidgetState? _activeState;

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (!context.mounted) return;
    final d = duration ?? _durationFor(type);
    _dismiss(animate: false);

    _entry = OverlayEntry(
      builder: (_) => _AppToastWidget(
        message: message,
        type: type,
        duration: d,
        actionLabel: actionLabel,
        onAction: onAction,
        theme: Theme.of(context),
        onStateReady: (s) => _activeState = s,
        onDismissed: _onDismissed,
      ),
    );

    _hapticFor(type);
    Overlay.of(context).insert(_entry!);
    _timer = Timer(d, () => _dismiss(animate: true));
  }

  static void _dismiss({bool animate = true}) {
    _timer?.cancel();
    _timer = null;
    if (animate) {
      _activeState?.dismiss();
    } else {
      _entry?.remove();
      _entry = null;
      _activeState = null;
    }
  }

  static void _onDismissed() {
    _entry?.remove();
    _entry = null;
    _activeState = null;
  }

  static Duration _durationFor(AppToastType type) => switch (type) {
    AppToastType.error => const Duration(seconds: 4),
    AppToastType.warning => const Duration(milliseconds: 3500),
    _ => const Duration(seconds: 3),
  };

  static void _hapticFor(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        AppHaptics.success();
      case AppToastType.error:
        AppHaptics.error();
      case AppToastType.warning:
        AppHaptics.medium();
      case AppToastType.info:
        AppHaptics.selection();
    }
  }
}

Color _colorFor(AppToastType type, ThemeData theme) {
  final c = theme.extension<AppColors>();
  return switch (type) {
    AppToastType.success => c?.statusSuccess ?? const Color(0xFF4CAF50),
    AppToastType.error => c?.statusError ?? const Color(0xFFEF5350),
    AppToastType.warning => c?.statusWarning ?? const Color(0xFFFFD54F),
    AppToastType.info => theme.colorScheme.primary,
  };
}

IconData _iconFor(AppToastType type) => switch (type) {
  AppToastType.success => Symbols.check_circle,
  AppToastType.error => Symbols.error,
  AppToastType.warning => Symbols.warning,
  AppToastType.info => Symbols.info,
};

// ─────────────────────────────────────────────────────────────────
// Overlay widget — manages enter/exit animation + drag-to-dismiss
// ─────────────────────────────────────────────────────────────────

class _AppToastWidget extends StatefulWidget {
  const _AppToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.theme,
    required this.onStateReady,
    required this.onDismissed,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final AppToastType type;
  final Duration duration;
  final ThemeData theme;
  final void Function(_AppToastWidgetState) onStateReady;
  final VoidCallback onDismissed;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  State<_AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _progressCtrl;
  late final Animation<double> _slideY;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  double _dragY = 0;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    widget.onStateReady(this);

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _progressCtrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1,
    );

    _slideY = Tween<double>(begin: -88, end: 0).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: const Interval(0, 0.55),
        reverseCurve: Curves.easeIn,
      ),
    );

    _scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _slideCtrl.forward();
    _progressCtrl.reverse();
  }

  void dismiss() {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    _progressCtrl.stop();
    _slideCtrl
      ..duration = const Duration(milliseconds: 220)
      ..reverse().then((_) {
        if (mounted) widget.onDismissed();
      });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.viewPaddingOf(context).top;
    final typeColor = _colorFor(widget.type, widget.theme);

    return Positioned(
      top: topPad + 12,
      left: 16,
      right: 16,
      child: Semantics(
        liveRegion: true,
        child: AnimatedBuilder(
          animation: _slideCtrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _slideY.value + _dragY),
            child: Opacity(
              opacity: _fade.value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: _scale.value,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (d) {
              if (_isDismissing || d.delta.dy >= 0) return;
              setState(() {
                _dragY = (_dragY + d.delta.dy).clamp(-120.0, 0.0);
              });
            },
            onVerticalDragEnd: (d) {
              if (_isDismissing) return;
              final v = d.primaryVelocity ?? 0;
              if (_dragY < -36 || v < -500) {
                setState(() => _isDismissing = true);
                widget.onDismissed();
              } else {
                setState(() => _dragY = 0);
              }
            },
            child: Material(
              color: Colors.transparent,
              child: RepaintBoundary(
                child: _ToastCard(
                  type: widget.type,
                  message: widget.message,
                  typeColor: typeColor,
                  theme: widget.theme,
                  progressCtrl: _progressCtrl,
                  actionLabel: widget.actionLabel,
                  onAction: widget.onAction,
                  onDismiss: dismiss,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Visual card — frosted glass surface with left accent + progress
// ─────────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.type,
    required this.message,
    required this.typeColor,
    required this.theme,
    required this.progressCtrl,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  final AppToastType type;
  final String message;
  final Color typeColor;
  final ThemeData theme;
  final AnimationController progressCtrl;
  final VoidCallback onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>();
    final surface = isDark
        ? (appColors?.bgElevated ?? const Color(0xFF1A1A1A))
        : Colors.white;
    final textColor = isDark
        ? Colors.white.withValues(alpha: 0.92)
        : const Color(0xFF1A1A1A);
    final bodyStyle = theme.extension<AppTypography>()?.bodyText;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.10),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: typeColor.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: surface.withValues(alpha: isDark ? 0.94 : 0.97),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: typeColor.withValues(alpha: 0.22)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _AccentBar(color: typeColor),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 13, 12, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _TypeIconBadge(type: type, typeColor: typeColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: bodyStyle?.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (actionLabel != null && onAction != null)
                        _ActionButton(
                          label: actionLabel!,
                          typeColor: typeColor,
                          onTap: () {
                            onAction!();
                            onDismiss();
                          },
                        )
                      else
                        _DismissButton(typeColor: typeColor, onTap: onDismiss),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 4,
                  right: 0,
                  child: _ProgressDrain(
                    controller: progressCtrl,
                    color: typeColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────

class _AccentBar extends StatelessWidget {
  const _AccentBar({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 4, color: color);
  }
}

class _TypeIconBadge extends StatelessWidget {
  const _TypeIconBadge({required this.type, required this.typeColor});
  final AppToastType type;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_iconFor(type), size: 20, color: typeColor),
    );
  }
}

class _ProgressDrain extends StatelessWidget {
  const _ProgressDrain({required this.controller, required this.color});
  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) => SizedBox(
        height: 2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: controller.value,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color.withValues(alpha: 0.60)),
            ),
          ),
        ),
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.typeColor, required this.onTap});
  final Color typeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: typeColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Symbols.close,
          size: 16,
          color: typeColor.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.typeColor,
    required this.onTap,
  });
  final String label;
  final Color typeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: typeColor.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: typeColor.withValues(alpha: 0.30)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: typeColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
