import 'package:flutter/material.dart';
import 'package:saranportfolio/common/responsive_layout.dart';
import 'package:saranportfolio/feature/home/presentation/pages/desktop/desktop_home_view.dart';
import 'package:saranportfolio/feature/home/presentation/pages/mobile/mobile_home_view.dart';
import 'package:saranportfolio/feature/home/presentation/pages/tablet/tablet_home_view.dart';
import 'package:saranportfolio/feature/home/presentation/pages/ultrahd/ultrahd_home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ResponsiveLayout(
          mobile: const MobileHomeView(),
          tablet: const TabletHomeView(),
          desktop: const DesktopHomeView(),
          ultraHd: const UltrahdHomeView(),
        ),
      ),
    );
  }
}
