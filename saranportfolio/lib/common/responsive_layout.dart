import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop, ultraHd }

class ResponsiveLayout {
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1920) return ScreenType.ultraHd;
    if (width >= 1200) return ScreenType.desktop;
    if (width >= 800) return ScreenType.tablet;
    return ScreenType.mobile;
  }
}