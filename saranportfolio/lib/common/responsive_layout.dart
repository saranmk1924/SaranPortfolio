import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop, ultraHd }

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget ultraHd;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.ultraHd,
  });

  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1920) return ScreenType.ultraHd;
    if (width >= 1200) return ScreenType.desktop;
    if (width >= 800) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final type = getScreenType(context);

    switch (type) {
      case ScreenType.ultraHd:
        return ultraHd;
      case ScreenType.desktop:
        return desktop;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.mobile:
      default:
        return mobile;
    }
  }
}