import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/intro_view.dart';

class DesktopIntroView extends StatefulWidget {
  const DesktopIntroView({super.key});

  @override
  State<DesktopIntroView> createState() => _DesktopIntroViewState();
}

class _DesktopIntroViewState extends State<DesktopIntroView> {
  @override
  Widget build(BuildContext context) {
    return const IntroView();
  }
}