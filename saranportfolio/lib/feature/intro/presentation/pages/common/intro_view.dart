import 'package:flutter/material.dart';
import 'package:saranportfolio/common/responsive_layout.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/animated_blob.dart';
import 'dart:async';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _avatarSlide;
  late Animation<double> _avatarFade;
  late Animation<double> _textFade;
  late Animation<double> _buttonFade;
  late AnimationController _flipController;
  bool _showFront = true;
  bool _isPressed = false;

  late AnimationController _floatingController;
  Timer? _autoFlipTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _avatarSlide = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.4, curve: Curves.easeOutBack),
          ),
        );

    _avatarFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5)),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8)),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1)),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // faster
    )..repeat(reverse: true);

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _startAutoFlip();
  }

  void _startAutoFlip() {
    _autoFlipTimer?.cancel();

    _autoFlipTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _flipCard();
        _startAutoFlip(); // restart timer
      }
    });
  }

  void _flipCard() {
    if (_flipController.isAnimating) return;

    if (_showFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }

    _showFront = !_showFront;

    // Restart timer when user taps
    _startAutoFlip();
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatingController.dispose();
    _flipController.dispose();
    _autoFlipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveLayout.getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        break;
      case ScreenType.tablet:
        break;
      case ScreenType.desktop:
        break;
      case ScreenType.ultraHd:
        break;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F0F0F), // Deep black
              Color(0xFF1A1A1A), // Soft dark
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
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
              ),
              // Main Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar Slide + Fade
                    SlideTransition(
                      position: _avatarSlide,
                      child: FadeTransition(
                        opacity: _avatarFade,
                        child: GestureDetector(
                          onTap: _flipCard,
                          child: AnimatedBuilder(
                            animation: _flipController,
                            builder: (context, child) {
                              final angle = _flipController.value * 3.1416;

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle),
                                child: angle <= 1.5708
                                    ? _buildAvatar(
                                        "assets/images/saran_profile.jpeg",
                                      )
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

                    // Text Section
                    FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: "Hi, I'm ",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Saran ",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: "👋"),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Flutter Developer",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "API Integration & UI Definition Passionate",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Button
                    FadeTransition(
                      opacity: _buttonFade,
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() => _isPressed = true);
                        },
                        onTapUp: (_) {
                          setState(() => _isPressed = false);
                        },
                        onTapCancel: () {
                          setState(() => _isPressed = false);
                        },
                        onTap: () {
                          // Navigate to main portfolio
                        },
                        child: AnimatedScale(
                          scale: _isPressed ? 0.96 : 1.0,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD54F), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: _isPressed
                                  ? [
                                      // Reduced shadow when pressed
                                      const BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.yellow.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 25,
                                        spreadRadius: 1,
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
                                const Text(
                                  "Explore My Digital Craft",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Animated Arrow
                                AnimatedSlide(
                                  offset: _isPressed
                                      ? const Offset(0.1, 0)
                                      : Offset.zero,
                                  duration: const Duration(milliseconds: 120),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
