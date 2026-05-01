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
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
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
      child: ListView.builder(
        itemCount: 100, // Provide a finite count to avoid infinite scroll crash
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.text.toUpperCase(),
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontFamily:
                      AppConstants.displayFontFamily, // Use the display font
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
