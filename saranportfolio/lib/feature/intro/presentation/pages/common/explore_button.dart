import 'package:flutter/material.dart';
import 'package:saranportfolio/widgets/parent/gradient_button.dart';

class ExploreButton extends StatelessWidget {
  final double fontSize;
  final VoidCallback onPressed;

  const ExploreButton({
    super.key,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      onPressed: onPressed,
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
    );
  }
}
