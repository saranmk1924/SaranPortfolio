import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumBlob extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;
  final int duration;

  const PremiumBlob({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<PremiumBlob> createState() => _PremiumBlobState();
}

class _PremiumBlobState extends State<PremiumBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _vertical;
  late Animation<double> _horizontal;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..repeat(reverse: true);

    _vertical = Tween<double>(
      begin: -20,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _horizontal = Tween<double>(
      begin: -15,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scale = Tween<double>(
      begin: 0.95,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(_horizontal.value, _vertical.value),
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          );
        },
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 40, // reduced blur
            sigmaY: 40,
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withOpacity(0.6),
                  widget.color.withOpacity(0.35),
                  widget.color.withOpacity(0.15),
                  Colors.transparent,
                ],
                stops: const [0.2, 0.5, 0.8, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}