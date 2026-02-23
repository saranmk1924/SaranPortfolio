import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/explore_button.dart';

class PortraitLayout extends StatelessWidget {
  final Animation<Offset> avatarSlide;
  final Animation<double> avatarFade;
  final Animation<double> textFade;
  final Animation<double> buttonFade;
  final AnimationController flipController;
  final VoidCallback onFlip;

  final bool isPressed;
  final ValueChanged<bool> onPressChange;

  const PortraitLayout({
    super.key,
    required this.avatarSlide,
    required this.avatarFade,
    required this.textFade,
    required this.buttonFade,
    required this.flipController,
    required this.onFlip,
    required this.isPressed,
    required this.onPressChange,
  });

  Widget _buildAvatar(String imagePath) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
    );
  }

  double scaleFont(double base, double screenWidth) {
    if (screenWidth >= 1600) return base * 1.4; // ultra wide
    if (screenWidth >= 1200) return base * 1.2; // desktop
    if (screenWidth >= 900) return base * 1.05; // small desktop
    return base; // fallback
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// AVATAR
          SlideTransition(
            position: avatarSlide,
            child: FadeTransition(
              opacity: avatarFade,
              child: GestureDetector(
                onTap: onFlip,
                child: AnimatedBuilder(
                  animation: flipController,
                  builder: (context, child) {
                    final angle = flipController.value * 3.1416;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: angle <= 1.5708
                          ? _buildAvatar("assets/images/saran_profile.jpeg")
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(3.1416),
                              child: _buildAvatar(
                                "assets/images/saran_animated.jpeg",
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          /// TEXT
          FadeTransition(
            opacity: textFade,
            child: Column(
              children: [
                Text(
                  "Hi, I'm Saran 👋",
                  style: TextStyle(
                    fontSize: scaleFont(28, screenWidth),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Flutter Developer",
                  style: TextStyle(
                    fontSize: scaleFont(20, screenWidth),
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: screenWidth * 0.8,
                  child: Text(
                    textAlign: TextAlign.center,
                    "I build scalable, high-performance cross-platform flutter applications using clean architecture and robust API integrations.",
                    style: TextStyle(
                      fontSize: scaleFont(18, screenWidth),
                      color: Colors.white60,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          /// BUTTON
          ExploreButton(
            fade: buttonFade,
            isPressed: isPressed,
            onPressChange: onPressChange,
            fontSize: scaleFont(18, screenWidth),
          ),
        ],
      ),
    );
  }
}
