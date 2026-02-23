import 'package:flutter/material.dart';

class IntroTextSection extends StatelessWidget {
  final Animation<double> fade;
  final double? maxWidth;

  const IntroTextSection({
    super.key,
    required this.fade,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: Column(
        children: [
          const Text.rich(
            TextSpan(
              text: "Hi, I'm ",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "Saran ",
                  style: TextStyle(color: Colors.yellow),
                ),
                TextSpan(text: "👋"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Flutter Developer",
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: maxWidth,
            child: const Text(
              textAlign: TextAlign.center,
              "I build scalable, high-performance cross-platform flutter applications using clean architecture and robust API integrations.",
              style: TextStyle(fontSize: 18, color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }
}