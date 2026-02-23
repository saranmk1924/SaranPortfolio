import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/intro_background.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/landscape_layout.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/portrait_layout.dart';
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
    final isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const IntroBackground(),

              IndexedStack(
                index: isLandscape ? 1 : 0,
                children: [
                  PortraitLayout(
                    avatarSlide: _avatarSlide,
                    avatarFade: _avatarFade,
                    textFade: _textFade,
                    buttonFade: _buttonFade,
                    flipController: _flipController,
                    onFlip: _flipCard,
                    isPressed: _isPressed,
                    onPressChange: (v) => setState(() => _isPressed = v),
                  ),
                  LandscapeLayout(
                    screenWidth: MediaQuery.of(context).size.width,
                    avatarSlide: _avatarSlide,
                    avatarFade: _avatarFade,
                    textFade: _textFade,
                    buttonFade: _buttonFade,
                    flipController: _flipController,
                    onFlip: _flipCard,
                    isPressed: _isPressed,
                    onPressChange: (v) => setState(() => _isPressed = v),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
