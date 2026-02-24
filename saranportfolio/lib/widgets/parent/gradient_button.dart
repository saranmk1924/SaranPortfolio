import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  final List<Color> gradientColors;
  final double borderRadius;
  final double elevation;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.gradientColors = const [Color(0xFFFFD54F), Colors.white],
    this.borderRadius = 40,
    this.elevation = 10,
    this.shadowColor = Colors.yellow,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(elevation),
        shadowColor: WidgetStateProperty.all(shadowColor),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),

        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return null; // keep default splash
          }
          return Colors.transparent; // remove hover shade
        }),

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),

        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
