import 'package:flutter/material.dart';

class ExploreButton extends StatelessWidget {
  final Animation<double> fade;
  final bool isPressed;
  final ValueChanged<bool> onPressChange;
  final double fontSize;

  const ExploreButton({
    super.key,
    required this.fade,
    required this.isPressed,
    required this.onPressChange,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: GestureDetector(
        onTapDown: (_) => onPressChange(true),
        onTapUp: (_) => onPressChange(false),
        onTapCancel: () => onPressChange(false),
        child: AnimatedScale(
          scale: isPressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD54F), Colors.white],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: isPressed
                  ? const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.yellow.withValues(alpha: 0.4),
                        blurRadius: 25,
                        offset: const Offset(1, 1),
                      ),
                      const BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Explore My Digital Craft",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: fontSize,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
