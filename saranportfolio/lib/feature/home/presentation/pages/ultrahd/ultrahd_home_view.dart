import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:saranportfolio/common/constants/color_constant.dart';
import 'package:saranportfolio/common/constants/fontsize_constant.dart';
import 'package:saranportfolio/feature/home/presentation/pages/common/blinking_cv_link.dart';
import 'package:saranportfolio/feature/home/presentation/pages/common/contact_icon.dart';
import 'package:saranportfolio/feature/home/presentation/pages/common/glow_card.dart';
import 'package:saranportfolio/feature/home/presentation/pages/common/skill_card.dart';

class UltrahdHomeView extends StatefulWidget {
  const UltrahdHomeView({super.key});

  @override
  State<UltrahdHomeView> createState() => UltrahdHomeViewState();
}

class UltrahdHomeViewState extends State<UltrahdHomeView>
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
  final GlobalKey _contactKey = GlobalKey();

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
        "subtitle": "Flutter | BLoC",
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
        titleFontSize: PageHeading2.large,
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
              style: TextStyle(
                color: ColorConstant.darkYellow,
                fontWeight: FontWeight.w700,
                fontSize: PageSubHeading.large,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "• Dynamic document & template creation",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Text, image, link & table mapping system",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Real-time arithmetic table calculations",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Word/Excel-like structured editor",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Scalable BLoC-based architecture",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rgWorkspaceDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        titleFontSize: PageHeading2.large,
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
              style: TextStyle(
                color: ColorConstant.darkYellow,
                fontWeight: FontWeight.w700,
                fontSize: PageSubHeading.large,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "• Employee leave & permission management",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Task management (Add/Edit/Delete/View)",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Admin approval & rejection workflows",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Clean validation & user feedback system",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• REST API integration for data handling",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _endrawDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        titleFontSize: PageHeading2.large,
        isBlinking: _blinkingIndex == index,
        blurRadius1: 10,
        blurRadius2: 1,
        blurRadius3: 20,
        blurRadius4: 1,
        title: "Endraw",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Domain: Flutter",
              style: TextStyle(
                color: ColorConstant.darkYellow,
                fontWeight: FontWeight.w700,
                fontSize: PageSubHeading.large,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "• Canva-inspired digital design platform",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Authentication (Login / Signup / Forgot)",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Admin template & category management",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Add / Edit / Delete / Fetch operations",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Consistent multi-screen UI architecture",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appStudioDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        titleFontSize: PageHeading2.large,
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
              style: TextStyle(
                color: ColorConstant.darkYellow,
                fontWeight: FontWeight.w700,
                fontSize: PageSubHeading.large,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Key Features:",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "• Project & template creation tool",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Express Builder guided workflow",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• My Projects CRUD module",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Drift DB offline data persistence",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Complex UI state management using BLoC",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _revoRacersDetail(int index) {
    return SizedBox(
      width: double.infinity,
      child: GlowCard(
        titleFontSize: PageHeading2.large,
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
              style: TextStyle(
                color: ColorConstant.darkYellow,
                fontWeight: FontWeight.w700,
                fontSize: PageSubHeading.large,
              ),
            ),
            SizedBox(height: 8),

            Text(
              "Organizer App (Admin Panel):",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "• Tournament creation & management",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Fixture generation & scheduling",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Registration dashboard approval system",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Structured admin workflows",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Player App (Public App):",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "• Team management system",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Multi-language localization",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Leaderboard & statistics",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Team messaging (Gmail-style UI)",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
            Text(
              "• Unity engine integration",
              style: TextStyle(
                fontSize: PageSubHeading.large,
                color: ColorConstant.halfWhite,
              ),
            ),
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
                          titleFontSize: PageHeading2.large,
                          isBlinking: false,
                          title: "Professional Summary",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Highly motivated and detail-oriented Flutter Developer with 1.5 years of experience building scalable, high-performance cross-platform applications. Strongly focused on crafting intuitive, responsive UI designs and integrating RESTful APIs to deliver seamless user experiences.",
                                style: TextStyle(
                                  color: ColorConstant.halfWhite,
                                  fontSize: PageSubHeading.large,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.center,
                                child: const BlinkingCvLink(
                                  fontSize: PageLabel.large,
                                  iconSize: 30,
                                ),
                              ),
                            ],
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
                              fontSize: PageHeading.large,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.white,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// Auto Sliding PageView
                          SizedBox(
                            height: 205,
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

                                          // await Scrollable.of(
                                          //   targetContext,
                                          // ).position.ensureVisible(
                                          //   targetContext.findRenderObject()!,
                                          //   duration: const Duration(
                                          //     milliseconds: 500,
                                          //   ),
                                          //   curve: Curves.easeInOut,
                                          //   alignment: 1,
                                          // );
                                          final renderBox =
                                              targetContext.findRenderObject()
                                                  as RenderBox;

                                          // Position of project card relative to screen
                                          final position = renderBox
                                              .localToGlobal(Offset.zero);

                                          // Convert that to scroll offset
                                          final offset =
                                              _scrollController.offset +
                                              position.dy;

                                          // Adjust based on header height (tweak this value)
                                          const headerHeight = 120;

                                          await _scrollController.animateTo(
                                            offset - headerHeight,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                          await _triggerBlink(realIndex);
                                        }
                                      },
                                      child: GlowCard(
                                        titleFontSize: PageHeading2.large,
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
                                                color: ColorConstant.darkYellow,
                                                fontSize: PageSubHeading.large,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              project["description"]!,
                                              style: const TextStyle(
                                                color: ColorConstant.halfWhite,
                                                height: 1.5,
                                                fontSize: PageSubHeading.large,
                                              ),
                                            ),
                                            const SizedBox(height: 13),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "View More",
                                                    style: TextStyle(
                                                      color: ColorConstant
                                                          .darkYellow,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: PageLabel.large,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Transform.translate(
                                                    offset: Offset(0, 2),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      color: ColorConstant
                                                          .darkYellow,
                                                      size: 18,
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
                                      ? ColorConstant.darkYellow
                                      : ColorConstant.halfWhite,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            }),
                          ),

                          // const SizedBox(height: 20),
                          const SizedBox(height: 10),

                          MasonryGridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 34,
                              vertical: 20,
                            ),
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3, // change to 1 for mobile, 2+ for tablet
                                ),
                            mainAxisSpacing: 35,
                            crossAxisSpacing: 30,
                            itemCount: _projects.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                key: _projectKeys[index],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                child: _buildDetailedProject(index),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Replace your SizedBox(key: _skillsKey) with this:
                  Padding(
                    key: _skillsKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Skills",
                          style: TextStyle(
                            color: ColorConstant.white,
                            fontSize: PageHeading.large,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Minimum width for a single card
                            const minCardWidth = 140.0;
                            // Horizontal spacing between cards
                            const spacing = 16.0;

                            // Calculate how many cards can fit per row
                            int cardsPerRow =
                                (constraints.maxWidth /
                                        (minCardWidth + spacing))
                                    .floor();
                            cardsPerRow = cardsPerRow.clamp(
                              1,
                              6,
                            ); // ensure at least 1, at most 6

                            // Calculate exact width per card
                            final double cardWidth =
                                (constraints.maxWidth -
                                    (spacing * (cardsPerRow - 1))) /
                                cardsPerRow;

                            final skills = [
                              {"icon": Icons.flutter_dash, "label": "Flutter"},
                              {"icon": Icons.code, "label": "Dart"},
                              {"icon": Icons.merge_type, "label": "Git"},
                              {"icon": Icons.cloud, "label": "AWS"},
                              {"icon": Icons.coffee, "label": "Java"},
                              {"icon": Icons.web, "label": "HTML & CSS"},
                            ];

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              children: skills
                                  .map(
                                    (skill) => SizedBox(
                                      width: cardWidth,
                                      child: SkillCard(
                                        icon: skill["icon"] as IconData,
                                        label: skill["label"] as String,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Contact Me Section
                  Padding(
                    key: _contactKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Contact Me",
                          style: TextStyle(
                            color: ColorConstant.white,
                            fontSize: PageHeading.small,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// Icons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 30,
                          children: [
                            /// Gmail
                            ContactIcon(
                              icon: Icons.email,
                              label: "Gmail",
                              url: "mksaran0@gmail.com",
                            ),

                            /// Phone
                            ContactIcon(
                              icon: Icons.phone,
                              label: "Phone",
                              url: "9840795810",
                            ),

                            /// GitHub
                            ContactIcon(
                              icon: Icons.code,
                              label: "GitHub",
                              url: "https://github.com/saranmk1924",
                            ),

                            /// LinkedIn
                            ContactIcon(
                              icon: Icons.work,
                              label: "LinkedIn",
                              url:
                                  "https://www.linkedin.com/in/saran-m-k-163069228/",
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
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
                color: ColorConstant.darkYellow,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: "avatarHero",
                      child: Material(
                        color: ColorConstant.transparent,
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
                                  color: ColorConstant.black,
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
                              color: ColorConstant.black,
                              size: 35,
                            ),
                          ),

                          GestureDetector(
                            onTap: () => _scrollToKey(_projectsTitleKey),
                            child: const Icon(
                              Icons.work,
                              color: ColorConstant.black,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _scrollToKey(_skillsKey),
                            child: Icon(
                              Icons.psychology,
                              color: ColorConstant.black,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _scrollToKey(_contactKey),
                            child: Icon(
                              Icons.contact_phone_rounded,
                              color: ColorConstant.black,
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
                  color: ColorConstant.transparent,
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
                          color: ColorConstant.yellow, // outer border color
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
                              color: ColorConstant.black,
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
                color: ColorConstant.darkYellow,
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
                        child: Icon(
                          Icons.home,
                          color: ColorConstant.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () => _scrollToKey(_projectsTitleKey),
                        child: Icon(
                          Icons.work,
                          color: ColorConstant.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () => _scrollToKey(_skillsKey),
                        child: Icon(
                          Icons.psychology,
                          color: ColorConstant.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () => _scrollToKey(_contactKey),
                        child: Icon(
                          Icons.contact_phone_rounded,
                          color: ColorConstant.black,
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
