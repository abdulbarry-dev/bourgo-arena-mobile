import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:flutter/material.dart';

/// A custom marquee/ticker strip widget.
class TickerStrip extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double height;

  const TickerStrip({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.height = 40,
  });

  @override
  State<TickerStrip> createState() => _TickerStripState();
}

class _TickerStripState extends State<TickerStrip>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 120))
          ..addListener(() {
            if (_scrollController.hasClients) {
              final maxScroll = _scrollController.position.maxScrollExtent;
              final currentScroll = _animationController.value * maxScroll;
              _scrollController.jumpTo(currentScroll);
            }
          });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: widget.backgroundColor,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          itemCount: 30, // Balanced count for a long strip
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.text.toUpperCase(),
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15, // Slightly larger
                    letterSpacing: 3.0, // More spacing for premium look
                    fontFamily: AppConstants.displayFontFamily,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
