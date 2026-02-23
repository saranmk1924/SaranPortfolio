import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/explore_button.dart';

class LandscapeLayout extends StatelessWidget {
  final Animation<Offset> avatarSlide;
  final Animation<double> avatarFade;
  final Animation<double> textFade;
  final Animation<double> buttonFade;
  final AnimationController flipController;
  final VoidCallback onFlip;
  final double screenWidth;

  final bool isPressed;
  final ValueChanged<bool> onPressChange;

  const LandscapeLayout({
    super.key,
    required this.avatarSlide,
    required this.avatarFade,
    required this.textFade,
    required this.buttonFade,
    required this.flipController,
    required this.onFlip,
    required this.isPressed,
    required this.onPressChange,
    required this.screenWidth,
  });

  Widget _buildAvatar(String imagePath, double screenWidth) {
    return Container(
      width: screenWidth * 0.29,
      height: screenWidth * 0.29,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                                  ? _buildAvatar(
                                      "assets/images/saran_profile.jpeg",
                                      screenWidth,
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(3.1416),
                                      child: _buildAvatar(
                                        "assets/images/saran_animated.jpeg",
                                        screenWidth,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),
            VerticalDivider(),
            const SizedBox(width: 20),

            Expanded(
              child:
                  /// TEXT
                  FadeTransition(
                    opacity: textFade,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            "I build scalable, high-performance cross-platform flutter applications using clean architecture and robust API integrations.",
                            style: TextStyle(
                              fontSize: scaleFont(18, screenWidth),
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// BUTTON
                        ExploreButton(
                          fade: buttonFade,
                          isPressed: isPressed,
                          onPressChange: onPressChange,
                          fontSize: scaleFont(14, screenWidth),
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
