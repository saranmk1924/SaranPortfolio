import 'package:flutter/material.dart';
import 'package:saranportfolio/common/responsive_layout.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/desktop/desktop_intro_view.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/mobile/mobile_intro_view.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/tablet/tablet_intro_view.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/ultrahd/ultrahd_intro_view.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveLayout.getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return const MobileIntroView();

      case ScreenType.tablet:
        return const TabletIntroView();

      case ScreenType.desktop:
        return const DesktopIntroView();

      case ScreenType.ultraHd:
        return const UltrahdIntroView();
    }
  }
}