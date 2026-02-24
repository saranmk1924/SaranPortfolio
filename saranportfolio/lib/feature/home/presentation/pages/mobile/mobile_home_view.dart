import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:saranportfolio/feature/home/presentation/pages/common/glow_card.dart';

class MobileHomeView extends StatefulWidget {
  const MobileHomeView({super.key});

  @override
  State<MobileHomeView> createState() => MobileHomeViewState();
}

class MobileHomeViewState extends State<MobileHomeView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late final List<Map<String, String>> _projects;
  late AnimationController _controller;

  late Animation<double> _summaryFade;
  late Animation<Offset> _summarySlide;

  late Animation<double> _projectsFade;
  late Animation<Offset> _projectsSlide;
  int? _selectedProjectIndex;
  late final List<GlobalKey> _projectKeys;
  bool _isAutoSliding = true;
  final ScrollController _scrollController = ScrollController();
  bool _showFullHeader = true;
  int? _blinkingIndex;
  Timer? _autoSlideTimer;
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _projectsTitleKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // FIRST initialize projects
    _projects = [
      {
        "title": "RevoRacers",
        "subtitle": "Flutter | BLoC",
        "description":
            "Tournament platform with Organizer & Player Apps. Leaderboards, Messaging & Localization.",
      },
      {
        "title": "P3 Reporting Tool",
        "subtitle": "Flutter | BLoC",
        "description":
            "Advanced reporting tool with dynamic templates, calculations & real-time document updates.",
      },
      {
        "title": "RG Workspace",
        "subtitle": "Flutter | setState",
        "description":
            "Employee management system with leave tracking, task workflows & REST API integration.",
      },
      {
        "title": "Endraw",
        "subtitle": "Flutter",
        "description":
            "Canva-inspired design platform with admin panel for templates & category management.",
      },
      {
        "title": "AppStudio",
        "subtitle": "Flutter | BLoC | Drift DB",
        "description":
            "Project creation tool with Express Builder workflow & offline database persistence.",
      },
    ];
    // THEN create keys
    _projectKeys = List.generate(_projects.length, (_) => GlobalKey());

    /// SUMMARY (first half)
    _summaryFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _summarySlide = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );

    /// PROJECTS (second half)
    _projectsFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _projectsSlide = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

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

    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: 1000, // fake middle
    );

    _currentPage = 1000;

    /// Auto slide
    Future.delayed(const Duration(seconds: 3), startAutoSlide);
  }

  Future<void> _triggerBlink(int index) async {
    setState(() {
      _blinkingIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() {
      _blinkingIndex = null;
    });
  }

  Future<void> _waitForPageViewToStop() async {
    final notifier = _pageController.position.isScrollingNotifier;

    final completer = Completer<void>();

    void listener() {
      if (!notifier.value) {
        notifier.removeListener(listener);
        completer.complete();
      }
    }

    notifier.addListener(listener);

    return completer.future;
  }

  void startAutoSlide() {
    _autoSlideTimer?.cancel();

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_isAutoSliding) return;

      _currentPage++;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  double _getScale(int index) {
    if (!_pageController.hasClients) return 0.85;

    double page = _pageController.page ?? _currentPage.toDouble();
    double diff = (page - index).abs();

    // smoother falloff
    return (1 - (diff * 0.15)).clamp(0.85, 1.0);
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToKey(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;

    await Scrollable.of(context).position.ensureVisible(
      context.findRenderObject()!,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1, // stop at top
    );
  }

  Widget _buildDetailedProject(int index) {
    switch (index) {
      case 0:
        return _revoRacersDetail(index);
      case 1:
        return _p3ReportingDetail(index);
      case 2:
        return _rgWorkspaceDetail(index);
      case 3:
        return _endrawDetail(index);
      case 4:
        return _appStudioDetail(index);
      default:
        return const SizedBox();
    }
  }

  Widget _p3ReportingDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        isBlinking: _blinkingIndex == index,
        blurRadius1: 10,
        blurRadius2: 1,
        blurRadius3: 20,
        blurRadius4: 1,
        title: "P3 Reporting Tool",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Domain: Flutter | BLoC",
              style: TextStyle(color: Colors.amber),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("• Dynamic document & template creation"),
            Text("• Text, image, link & table mapping system"),
            Text("• Real-time arithmetic table calculations"),
            Text("• Word/Excel-like structured editor"),
            Text("• Scalable BLoC-based architecture"),
          ],
        ),
      ),
    );
  }

  Widget _rgWorkspaceDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        isBlinking: _blinkingIndex == index,
        blurRadius1: 10,
        blurRadius2: 1,
        blurRadius3: 20,
        blurRadius4: 1,
        title: "RG Workspace",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Domain: Flutter | setState",
              style: TextStyle(color: Colors.amber),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("• Employee leave & permission management"),
            Text("• Task management (Add/Edit/Delete/View)"),
            Text("• Admin approval & rejection workflows"),
            Text("• Clean validation & user feedback system"),
            Text("• REST API integration for data handling"),
          ],
        ),
      ),
    );
  }

  Widget _endrawDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        isBlinking: _blinkingIndex == index,
        blurRadius1: 10,
        blurRadius2: 1,
        blurRadius3: 20,
        blurRadius4: 1,
        title: "Endraw",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Domain: Flutter", style: TextStyle(color: Colors.amber)),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("• Canva-inspired digital design platform"),
            Text("• Authentication (Login / Signup / Forgot)"),
            Text("• Admin template & category management"),
            Text("• Add / Edit / Delete / Fetch operations"),
            Text("• Consistent multi-screen UI architecture"),
          ],
        ),
      ),
    );
  }

  Widget _appStudioDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        isBlinking: _blinkingIndex == index,
        blurRadius1: 10,
        blurRadius2: 1,
        blurRadius3: 20,
        blurRadius4: 1,
        title: "AppStudio",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Domain: Flutter | BLoC",
              style: TextStyle(color: Colors.amber),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("• Project & template creation tool"),
            Text("• Express Builder guided workflow"),
            Text("• My Projects CRUD module"),
            Text("• Drift DB offline data persistence"),
            Text("• Complex UI state management using BLoC"),
          ],
        ),
      ),
    );
  }

  Widget _revoRacersDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        isBlinking: _blinkingIndex == index,
        blurRadius1: 10,
        blurRadius2: 1,
        blurRadius3: 20,
        blurRadius4: 1,
        title: "RevoRacers",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Domain: Flutter | BLoC",
              style: TextStyle(color: Colors.amber),
            ),
            SizedBox(height: 12),

            Text(
              "Organizer App (Admin Panel):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("• Tournament creation & management"),
            Text("• Fixture generation & scheduling"),
            Text("• Registration dashboard approval system"),
            Text("• Structured admin workflows"),
            SizedBox(height: 12),

            Text(
              "Player App (Public App):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("• Team management system"),
            Text("• Multi-language localization"),
            Text("• Leaderboard & statistics"),
            Text("• Team messaging (Gmail-style UI)"),
            Text("• Unity engine integration"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          /// Scrollable content
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Spacer to avoid content going under header
                  SizedBox(height: 90),

                  FadeTransition(
                    opacity: _summaryFade,
                    child: SlideTransition(
                      position: _summarySlide,
                      child: Padding(
                        key: _homeKey,
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

                  // SizedBox(height: 10),
                  FadeTransition(
                    opacity: _projectsFade,
                    child: SlideTransition(
                      position: _projectsSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Section Title
                          Text(
                            key: _projectsTitleKey,
                            "Projects",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// Auto Sliding PageView
                          SizedBox(
                            height: 220,
                            child: NotificationListener<UserScrollNotification>(
                              onNotification: (notification) {
                                if (notification.direction ==
                                    ScrollDirection.idle) {
                                  _isAutoSliding = true;
                                } else {
                                  _isAutoSliding = false;
                                }
                                return false;
                              },
                              child: PageView.builder(
                                controller: _pageController,
                                itemBuilder: (context, index) {
                                  final realIndex = index % _projects.length;
                                  final project = _projects[realIndex];

                                  return AnimatedBuilder(
                                    animation: _pageController,
                                    builder: (context, child) {
                                      final scale = _getScale(index);

                                      return Center(
                                        child: Transform.translate(
                                          offset: Offset(0, (1 - scale) * 30),
                                          child: Transform.scale(
                                            scale: scale,
                                            child: Opacity(
                                              opacity: scale,
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () async {
                                        final realIndex =
                                            index % _projects.length;

                                        _isAutoSliding = false;

                                        // Resume auto slide after 6 seconds
                                        Future.delayed(
                                          const Duration(seconds: 6),
                                          () {
                                            if (mounted) {
                                              _isAutoSliding = true;
                                              startAutoSlide();
                                            }
                                          },
                                        );

                                        if (_pageController
                                            .position
                                            .isScrollingNotifier
                                            .value) {
                                          await _waitForPageViewToStop();
                                        }

                                        final targetContext =
                                            _projectKeys[realIndex]
                                                .currentContext;

                                        if (targetContext != null) {
                                          // 👇 KEY FIX: if at extreme top, move 1 pixel first
                                          if (_scrollController.offset == 0) {
                                            await _scrollController.animateTo(
                                              0.5,
                                              duration: const Duration(
                                                milliseconds: 1,
                                              ),
                                              curve: Curves.linear,
                                            );
                                          }

                                          await Scrollable.of(
                                            targetContext,
                                          ).position.ensureVisible(
                                            targetContext.findRenderObject()!,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                            alignment: 0.3,
                                          );
                                          await _triggerBlink(realIndex);
                                        }
                                      },
                                      child: GlowCard(
                                        isBlinking: false,
                                        boxShadow: [],
                                        title: project["title"]!,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              project["subtitle"]!,
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              project["description"]!,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                height: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 13),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text(
                                                    "View More",
                                                    style: TextStyle(
                                                      color: Colors.amber,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// Page Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_projects.length, (index) {
                              final selectedIndex =
                                  _currentPage % _projects.length;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: selectedIndex == index ? 18 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? Colors.amber
                                      : Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            }),
                          ),

                          // const SizedBox(height: 20),
                          const SizedBox(height: 10),

                          Column(
                            children: List.generate(_projects.length, (index) {
                              return Padding(
                                key: _projectKeys[index],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 20,
                                ),
                                child: _buildDetailedProject(index),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(key: _skillsKey),
                ],
              ),
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
                          GestureDetector(
                            onTap: () async {
                              await _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Icon(
                              Icons.home,
                              color: Colors.black,
                              size: 35,
                            ),
                          ),

                          GestureDetector(
                            onTap: () => _scrollToKey(_projectsTitleKey),
                            child: const Icon(
                              Icons.work,
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _scrollToKey(_skillsKey),
                            child: Icon(
                              Icons.psychology,
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _scrollToKey(_skillsKey),
                            child: Icon(
                              Icons.contact_phone_rounded,
                              color: Colors.black,
                              size: 35,
                            ),
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
                    children: [
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () async {
                          await _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Icon(Icons.home, color: Colors.black, size: 30),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () => _scrollToKey(_projectsTitleKey),
                        child: Icon(Icons.work, color: Colors.black, size: 30),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () => _scrollToKey(_skillsKey),
                        child: Icon(
                          Icons.psychology,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () => _scrollToKey(_skillsKey),
                        child: Icon(
                          Icons.contact_phone_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
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
