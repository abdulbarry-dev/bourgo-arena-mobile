import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CelebrationOverlay extends StatefulWidget {
  final Duration autoDismiss;

  const CelebrationOverlay({
    super.key,
    this.autoDismiss = const Duration(seconds: 2),
  });

  static void show(
    BuildContext context, {
    Duration autoDismiss = const Duration(seconds: 2),
  }) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim, secondaryAnim) {
        return FadeTransition(
          opacity: anim,
          child: CelebrationOverlay(autoDismiss: autoDismiss),
        );
      },
    );
  }

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = Random();
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(24, (i) => _generateParticle(i));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addListener(() => setState(() {}));

    _controller.forward();
    Future.delayed(widget.autoDismiss, () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  _Particle _generateParticle(int index) {
    const colors = [
      Color(0xFFAAFF00),
      Color(0xFF88CC00),
      Color(0xFF66FF00),
      Color(0xFFFFFFFF),
    ];

    final angle = (index / 24) * 2 * pi + (_random.nextDouble() - 0.5) * 0.5;
    final speed = 80.0 + _random.nextDouble() * 120.0;
    final size = 6.0 + _random.nextDouble() * 8.0;

    return _Particle(
      angle: angle,
      speed: speed,
      size: size,
      color: colors[index % colors.length],
      delay: Duration(milliseconds: index * 30 + _random.nextInt(100)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Center(
            child: AnimatedScale(
              scale: _controller.value < 0.3
                  ? Curves.elasticOut.transform(_controller.value / 0.3)
                  : 1.0,
              duration: Duration.zero,
              child: AnimatedOpacity(
                opacity: _controller.value < 0.8
                    ? 1.0
                    : 1.0 - ((_controller.value - 0.8) / 0.2),
                duration: Duration.zero,
                child:
                    Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFFAAFF00,
                            ).withValues(alpha: 0.15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFAAFF00,
                                ).withValues(alpha: 0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 48,
                            color: Color(0xFFAAFF00),
                          ),
                        )
                        .animate()
                        .fade(duration: 200.ms)
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 600.ms,
                        ),
              ),
            ),
          ),
          ..._particles.map(_buildParticle),
        ],
      ),
    );
  }

  Widget _buildParticle(_Particle particle) {
    final progress =
        ((_controller.value * 1800) - particle.delay.inMilliseconds).clamp(
          0.0,
          1800.0,
        ) /
        1800.0;
    if (progress <= 0) return const SizedBox.shrink();

    final distance = particle.speed * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final x = cos(particle.angle) * distance;
    final y = sin(particle.angle) * distance;

    return Positioned(
      top: MediaQuery.of(context).size.height / 2 + y - particle.size / 2,
      left: MediaQuery.of(context).size.width / 2 + x - particle.size / 2,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: particle.size,
            height: particle.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: particle.color,
            ),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final Duration delay;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.delay,
  });
}
