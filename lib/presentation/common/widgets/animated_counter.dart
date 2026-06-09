import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final num value;
  final String? prefix;
  final String? suffix;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final int? decimalPlaces;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.style,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOutCubic,
    this.decimalPlaces,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _previousValue;
  double? _targetDecimal;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value.toDouble();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addListener(() => setState(() {}));
    _animation = Tween<double>(begin: 0, end: _previousValue)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = Tween<double>(begin: _previousValue, end: widget.value.toDouble())
          .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
      _targetDecimal = null;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animatedValue = _animation.value;
    String displayValue;

    if (widget.decimalPlaces != null) {
      displayValue = animatedValue.toStringAsFixed(widget.decimalPlaces!);
    } else if (widget.value is double) {
      displayValue = animatedValue.toStringAsFixed(0);
    } else {
      displayValue = animatedValue.round().toString();
    }

    final buffer = StringBuffer();
    if (widget.prefix != null) buffer.write(widget.prefix!);
    buffer.write(displayValue);
    if (widget.suffix != null) buffer.write(widget.suffix!);

    return Text(
      buffer.toString(),
      style: widget.style,
    );
  }
}
