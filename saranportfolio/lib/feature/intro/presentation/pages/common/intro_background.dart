import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/premium_blob.dart';

class IntroBackground extends StatelessWidget {
  const IntroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: const [
          PremiumBlob(
            top: -200,
            right: -80,
            size: 300,
            color: Colors.white,
            duration: 3,
          ),
          PremiumBlob(
            bottom: -200,
            left: -80,
            size: 300,
            color: Colors.yellow,
            duration: 3,
          ),
        ],
      ),
    );
  }
}