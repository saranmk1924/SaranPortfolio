import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/home/presentation/pages/common/glow_card.dart';

class UltrahdHomeView extends StatefulWidget {
  const UltrahdHomeView({super.key});

  @override
  State<UltrahdHomeView> createState() => UltrahdHomeViewState();
}

class UltrahdHomeViewState extends State<UltrahdHomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final ScrollController _scrollController = ScrollController();
  bool _showFullHeader = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _slide = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 400), () {
      _controller.forward();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 20 && _showFullHeader) {
        setState(() => _showFullHeader = false);
      } else if (_scrollController.offset <= 20 && !_showFullHeader) {
        setState(() => _showFullHeader = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          /// Scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Spacer to avoid content going under header
                SizedBox(height: 90),

                FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 24,
                      ),
                      child: GlowCard(
                        isBlinking: false,
                        title: "Professional Summary",
                        child: const Text(
                          "Highly motivated and detail-oriented Flutter Developer with 1.5 years of experience building scalable, high-performance cross-platform applications. Strongly focused on crafting intuitive, responsive UI designs and integrating RESTful APIs to deliver seamless user experiences.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 24,
                      ),
                      child: GlowCard(
                        isBlinking: false,
                        title: "Professional Summary",
                        child: const Text(
                          "Highly motivated and detail-oriented Flutter Developer with 1.5 years of experience building scalable, high-performance cross-platform applications. Strongly focused on crafting intuitive, responsive UI designs and integrating RESTful APIs to deliver seamless user experiences.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 24,
                      ),
                      child: GlowCard(
                        isBlinking: false,
                        title: "Professional Summary",
                        child: const Text(
                          "Highly motivated and detail-oriented Flutter Developer with 1.5 years of experience building scalable, high-performance cross-platform applications. Strongly focused on crafting intuitive, responsive UI designs and integrating RESTful APIs to deliver seamless user experiences.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Header container: always positioned, animates opacity
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showFullHeader ? 1 : 0,
              child: Container(
                height: 80,
                color: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: "avatarHero",
                      child: Material(
                        color: Colors.transparent,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/saran_profile.jpeg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        spacing: 30,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.home, color: Colors.black, size: 35),
                          Icon(Icons.work, color: Colors.black, size: 35),
                          Icon(Icons.psychology, color: Colors.black, size: 35),
                          Icon(
                            Icons.contact_phone_rounded,
                            color: Colors.black,
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Floating avatar when header is hidden
          if (!_showFullHeader)
            Positioned(
              top: 10,
              left: 20,
              child: Hero(
                tag: "avatarHero",
                child: Material(
                  color: Colors.transparent,
                  elevation: 20, // floating elevation
                  shape: const CircleBorder(),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(
                          4,
                        ), // space for outer border
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow, // outer border color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 4,
                            ), // inner border
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/saran_profile.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!_showFullHeader)
            Positioned(
              top: 20,
              right: 20,
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(30),
                color: Colors.amber,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 5),
                      Icon(Icons.home, color: Colors.black, size: 30),
                      SizedBox(width: 25),
                      Icon(Icons.work, color: Colors.black, size: 30),
                      SizedBox(width: 25),
                      Icon(Icons.psychology, color: Colors.black, size: 30),
                      SizedBox(width: 25),
                      Icon(
                        Icons.contact_phone_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
