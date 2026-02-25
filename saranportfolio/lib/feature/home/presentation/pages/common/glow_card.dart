import 'package:flutter/material.dart';
import 'package:saranportfolio/common/constants/fontsize_constant.dart';

class GlowCard extends StatefulWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool isBlinking;
  final Color? shadowColor1;
  final Color? shadowColor2;
  final double? blurRadius1;
  final double? blurRadius2;
  final double? blurRadius3;
  final double? blurRadius4;
  final double? titleFontSize;

  const GlowCard({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.boxShadow,
    required this.isBlinking,
    this.shadowColor1,
    this.shadowColor2,
    this.blurRadius1,
    this.blurRadius2,
    this.blurRadius3,
    this.blurRadius4,
    this.titleFontSize,
  });

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant GlowCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isBlinking) {
      _controller.repeat(reverse: true);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.stop();
          _controller.reset();
        }
      });
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowValue = widget.isBlinking ? _glowAnimation.value : 0.6;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow:
                widget.boxShadow ??
                [
                  BoxShadow(
                    color:
                        widget.shadowColor1?.withOpacity(glowValue) ??
                        Colors.yellow.withOpacity(glowValue),
                    blurRadius: (widget.blurRadius1 ?? 15) * glowValue,
                    spreadRadius: (widget.blurRadius2 ?? 2) * glowValue,
                  ),
                  BoxShadow(
                    color:
                        widget.shadowColor2?.withOpacity(glowValue) ??
                        Colors.white.withOpacity(glowValue * 0.6),
                    blurRadius: (widget.blurRadius3 ?? 25) * glowValue,
                    spreadRadius: (widget.blurRadius4 ?? 3) * glowValue,
                  ),
                ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: const LinearGradient(
                colors: [Colors.yellow, Colors.white],
              ),
            ),
            padding: const EdgeInsets.all(1.5),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius - 2),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1E1E), Color(0xFF262626)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: widget.titleFontSize?? PageHeading2.small,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  widget.child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
